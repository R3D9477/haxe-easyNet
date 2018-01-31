package rn.net.tcp;

#if cpp
	import cpp.vm.Mutex;
	import cpp.vm.Thread;
#elseif neko
	import neko.vm.Mutex;
	import neko.vm.Thread;
#end

import haxe.io.Bytes;

class TcpServer {
	var clientClass:Class<Dynamic>;

	//------------------------------------------------------------------------------------------
	
	var tcpListener:TcpSocket;
	var listenderThread:Thread;
	var clientCheckerThread:Thread;
	
	//------------------------------------------------------------------------------------------
	
	public var started (get, null) : Bool;
	function get_started () return if (tcpListener != null) tcpListener.connected else false;

	//------------------------------------------------------------------------------------------
	
	var clients:Map<String, ITcpClient>;
	var clientThreads:Map<String, Thread>;
	var clientsLocker:Mutex;
	
	//------------------------------------------------------------------------------------------
	
	public dynamic function onClientBeforeConnect (client:ITcpClient) { }
	public dynamic function onClientAfterConnect (clientGuid:String) { }
	public dynamic function onClientDisconnect (clientGuid:String) { }

	public dynamic function clientCheckingProc (client:ITcpClient) : Bool return true;

	public dynamic function onClientData (clientGuid:String, data:haxe.io.Bytes) { }
	public dynamic function onClientText (clientGuid:String, text:String) { }
	
	//------------------------------------------------------------------------------------------
	
	public function new (?tcpListener:TcpSocket, ?inputBufferSize:Int) {
		clientClass = TcpClient;

		this.tcpListener = tcpListener != null ? tcpListener : new TcpSocket(null, inputBufferSize);
		listenderThread = null;
		clientCheckerThread = null;
		clientsLocker = new Mutex();

		clients = new Map<String, ITcpClient>();
		clientThreads = new Map<String, Thread>();
	}
	
	//------------------------------------------------------------------------------------------
	
	function clientsAutocheckingProc () {
		while (started) {
			//clientsLocker.acquire();
			
			for (clientGuid in clients.keys())
				if (!clients[clientGuid].connected) {
					disconnect(clientGuid);
					break;
				}
			
			//clientsLocker.release();
			
			Sys.sleep(.1);
		}
	}

	function clientProc () {
		var clientGuid:String = Thread.readMessage(true);
		var tcpClient = clients.exists(clientGuid) ? clients[clientGuid] : null;

		if (tcpClient != null)
			while (tcpClient.connected) {
				var data = tcpClient.readData();
				
				onClientData(clientGuid, data);
				onClientText(clientGuid, data.toString());
			}

		disconnect(clientGuid);
	}

	function listenderProc () {
		while (tcpListener != null) {
			var tcpClient:ITcpClient;
			
			try {
				tcpClient = Type.createInstance(clientClass, [tcpListener.accept(), tcpListener.inputBufferSize]);
			}
			catch (e:Dynamic) {
				tcpClient = null;
			}
			
			if (tcpClient != null) {
				onClientBeforeConnect(tcpClient);
				
				if (tcpClient != null)
					if (tcpClient.connected) {
						if (clientCheckingProc(tcpClient)) {
							//clientsLocker.acquire();
							
							var clientGuid = DateTools.format(Date.now(), "%Y%m%d%H%M%S") + (Math.random() * Lambda.count(clients)) + Lambda.count(clients);
							
							clients.set(clientGuid, tcpClient);
							
							var clientThread = Thread.create(clientProc);
							clientThread.sendMessage(clientGuid);

							//clientsLocker.release();

							clientThreads.set(clientGuid, clientThread);

							onClientAfterConnect(clientGuid);
						}
					}
			}
		}
	}

	//------------------------------------------------------------------------------------------

	public function start (host:sys.net.Host, port:Int, clientsAutochecking:Bool = true) {
		var result = false;

		if (result = tcpListener.bind(host, port)) 
			listenderThread = Thread.create(listenderProc);

		if (result && clientsAutochecking)
			clientCheckerThread = Thread.create(clientsAutocheckingProc);

		return result;
	}
	
	public function stop () {
		//if (tcpListener != null)
		//	try { tcpListener.close(); } catch (e:Dynamic) { }

		tcpListener = null;
		listenderThread = null;
		clientCheckerThread = null;
		
		disconnectAll();
	}

	//------------------------------------------------------------------------------------------

	public function disconnectAll () {
		//clientsLocker.acquire();
		
		for (clientGuid in clients.keys())
			disconnect(clientGuid);
		
		//clientsLocker.release();
	}
	
	public function disconnect (clientGuid:String) {
		//clientsLocker.acquire();

		if (clientThreads.exists(clientGuid))
			clientThreads.remove(clientGuid);

		if (clients.exists(clientGuid)) {
			//clients[clientGuid].disconnect();
			clients.remove(clientGuid);
		}

		//clientsLocker.release();

		onClientDisconnect(clientGuid);
	}

	//------------------------------------------------------------------------------------------

	public function sendData (clientGuid:String, data:Bytes) {
		var result = false;

		//clientsLocker.acquire();

		if (clients.exists(clientGuid))
			result = clients[clientGuid].sendData(data);

		//clientsLocker.release();

		return result;
	}

	public function sendText (clientGuid:String, text:String) {
		var result = false;

		//clientsLocker.acquire();

		if (clients.exists(clientGuid))
			return clients[clientGuid].sendText(text);

		//clientsLocker.release();

		return result;
	}

	public function sendTextLine (clientGuid:String, text:String)
		return text != null ? sendText(clientGuid, text + "\n") : false;
}