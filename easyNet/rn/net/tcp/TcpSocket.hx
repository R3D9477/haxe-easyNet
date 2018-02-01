package rn.net.tcp;

import sys.net.Host;
import sys.net.Socket;
import rn.net.io.NetworkStream;

typedef EndPoint = { host:Host, port:Int }

class TcpSocket {
	var socket:Socket;
	public var inputBufferSize (default, null) : Int;
	public var dataStream (default, null) : NetworkStream;
	
	public var endPoint (default, null) : EndPoint;
	
	public var connected (get, null) : Bool;
	function get_connected () return socket != null && dataStream != null ? dataStream.canRead && dataStream.canWrite : false;

	public var connectTimeout:Float;
	public var dataTransferTimeout:Float;
	
	//----------------------------------------------------------------------------------------------

	public function new (?socket:Socket, ?inputBufferSize:Int) {
		this.endPoint = { host: new Host("localhost"), port: 5000 };
		this.inputBufferSize = inputBufferSize == null ? 1 : inputBufferSize;
		
		setSocket(socket);
	}

	//----------------------------------------------------------------------------------------------

	function setSocket (socket:Socket) {
		if (socket != null) {
			this.socket = socket;

			var sockEp = this.socket.host();
			endPoint = { host: sockEp.host, port: sockEp.port };

			dataStream = new NetworkStream(inputBufferSize);
			dataStream.setSocketStream(this.socket);
		}
		else close();
	}

	//----------------------------------------------------------------------------------------------

	public function accept () {
		var clientSocket = socket.accept();
		clientSocket.setBlocking(false);
		return new TcpSocket(clientSocket, inputBufferSize);
	}

	public function bind (host:Host, port:Int, ?count:Int) {
		endPoint = { host: host, port: port };
		return rebind(count);
	}

	public function rebind (?count:Int) {
		close();
		
		var result;
		
		if (result = endPoint.port > 0)
			try {
				var serverSocket = new Socket();
				
				serverSocket.bind(endPoint.host, endPoint.port);
				serverSocket.listen(count == null ? 1 : count);
				
				serverSocket.setBlocking(true);
				setSocket(serverSocket);
			}
			catch (e:Dynamic) {
				close();
				result = false;
			}
		
		return result;
	}

	//----------------------------------------------------------------------------------------------

	public function connect (host:Host, port:Int) {
		endPoint = { host: host, port: port };
		return reconnect();
	}

	public function reconnect () {
		close();
		
		var result;
		
		if (result = endPoint.port > 0)
			try {
				var clientSocket = new Socket();
				
				clientSocket.connect(endPoint.host, endPoint.port);
				
				clientSocket.setBlocking(false);
				setSocket(clientSocket);
			}
			catch (e:Dynamic) {
				close();
				result = false;
			}
		
		return result;
	}

	//----------------------------------------------------------------------------------------------

	public function close () {
		if (dataStream != null)
			dataStream.close();
		
		if (socket != null)
			try { socket.close(); } catch (e:Dynamic) { }
		
		socket = null;
	}
}