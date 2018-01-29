package rn.net.tcp;

import sys.net.Host;
import haxe.io.Bytes;
import haxe.io.BytesBuffer;

class TcpClient implements ITcpClient {
	var tcpSocket:TcpSocket;
	
	public var connected (get, null) : Bool;
	function get_connected () return if (tcpSocket != null) tcpSocket.connected else false;
	
	//------------------------------------------------------------------------------------------
	
	public function new (?tcpSocket:TcpSocket, ?inputBufferSize:Int)
		this.tcpSocket = tcpSocket != null ? tcpSocket : new TcpSocket(null, inputBufferSize);
	
	//------------------------------------------------------------------------------------------
	
	public function connect (host:Host, port:Int) return tcpSocket.connect(host, port);
	
	public function reconnect () return tcpSocket.reconnect();
	
	public function disconnect () tcpSocket.close();
	
	//------------------------------------------------------------------------------------------
	
	public function sendByte (data:Int) {
		if (connected)
			try {
				return tcpSocket.dataStream.writeByte(data);
			}
			catch (e:Dynamic) {
				disconnect();
			}
		
		return false;
	}

	public function sendData (data:Bytes) {
		if (connected)
			try {
				return tcpSocket.dataStream.write(data);
			}
			catch (e:Dynamic) {
				disconnect();
			}
		
		return false;
	}

	public function sendText (text:String)
		return text != null ? sendData(Bytes.ofString(text)) : false;
	
	public function sendTextLine (text:String)
		return text != null ? sendText(text + "\n") : false;

	//------------------------------------------------------------------------------------------
	
	function _readData (readLine:Bool) {
		var data = new BytesBuffer();
		
		while (tcpSocket.dataStream.dataAvailable)
			data.addByte(tcpSocket.dataStream.readByte());
		
		return data.getBytes();
	}

	public function readData (notEmpty:Bool = true, readLine:Bool = false) {
		var data:Bytes;

		while ((data = _readData(readLine)).length < 1)
			Sys.sleep(.1);
		
		return data;
	}
	
	public function readText (notEmpty:Bool = true, readLine:Bool = false)
		return readData(notEmpty, readLine).toString();
}