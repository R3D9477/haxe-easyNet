package rn.net.tcp;

#if cpp
	import cpp.vm.Thread;
#elseif neko
	import neko.vm.Thread;
#end

import haxe.io.Bytes;

class TcpServer {
	var clientClass:Class<Dynamic>;

	//------------------------------------------------------------------------------------------
	
	var tcpListener:TcpSocket;
	var listenderThread:Thread;
	
	//------------------------------------------------------------------------------------------
	
	var clients:Map<String, ITcpClient>;
	var clientThreads:Map<String, Thread>;
	
	//------------------------------------------------------------------------------------------
	
	public dynamic function onClientBeforeConnect (client:ITcpClient) { }
	public dynamic function onClientAfterConnect (clientGuid:String) { }

	public dynamic function clientCheckingProc (client:ITcpClient) : Bool return true;

	public dynamic function onClientData (clientGuid:String, data:haxe.io.Bytes) { }
	public dynamic function onClientText (clientGuid:String, text:String) { }
	
	//------------------------------------------------------------------------------------------
	
	public function new (?tcpListener:TcpSocket, ?inputBufferSize:Int) {
		clientClass = TcpClient;

		this.tcpListener = tcpListener != null ? tcpListener : new TcpSocket(null, inputBufferSize);
		listenderThread = null;

		clients = new Map<String, ITcpClient>();
		clientThreads = new Map<String, Thread>();
	}
	
	//------------------------------------------------------------------------------------------
	
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
							var clientGuid = DateTools.format(Date.now(), "%Y%m%d%H%M%S") + (Math.random() * Lambda.count(clients)) + Lambda.count(clients);
							
							clients.set(clientGuid, tcpClient);
							
							var clientThread = Thread.create(clientProc);
							clientThread.sendMessage(clientGuid);

							clientThreads.set(clientGuid, clientThread);

							onClientAfterConnect(clientGuid);
						}
					}
			}
		}
	}

	//------------------------------------------------------------------------------------------

	public function start (host:sys.net.Host, port:Int) {
		if (tcpListener.bind(host, port)) {
			listenderThread = Thread.create(listenderProc);
			return true;
		}

		return false;
	}
	
	public function stop () {
		//if (tcpListener != null)
		//	try { tcpListener.close(); } catch (e:Dynamic) { }

		tcpListener = null;
		listenderThread = null;
		
		disconnectAll();
	}

	//------------------------------------------------------------------------------------------

	public function disconnectAll () for (clientGuid in clients.keys()) disconnect(clientGuid);
	
	public function disconnect (clientGuid:String) {
		if (clients.exists(clientGuid)) {
			clients[clientGuid].disconnect();
			clients.remove(clientGuid);
		}
		
		if (clientThreads.exists(clientGuid))
			clientThreads.remove(clientGuid);
	}

	//------------------------------------------------------------------------------------------

	public function sendData (clientGuid:String, data:Bytes) {
		if (clients.exists(clientGuid))
			return clients[clientGuid].sendData(data);

		return false;
	}

	public function sendText (clientGuid:String, text:String) {
		if (clients.exists(clientGuid))
			return clients[clientGuid].sendText(text);

		return false;
	}

	public function sendTextLine (clientGuid:String, text:String)
		return text != null ? sendText(clientGuid, text + "\n") : false;
}