package rn.net.tcp.telnet;

import sys.net.Host;
import haxe.io.Bytes;
import haxe.io.BytesBuffer;

import rn.net.tcp.TcpClient;
import rn.net.tcp.ITcpClient;
import rn.net.io.NetworkStream;

using StringTools;

class TelnetClient extends TcpClient implements ITcpClient {
	public var telnetControlChar:String;
	public var telnetSendWaiting:Float = .1;
	public var telnetResponseWaiting:Float = .5;
	public var telnetEndLineChar:String = String.fromCharCode(13);

	//------------------------------------------------------------------------------------------

	public var telnetLogin:String;
	public var telnetPassword:String;

	//------------------------------------------------------------------------------------------

	public dynamic function telnetLoginProc () {
		var result = true;

		if (telnetLogin != null ? telnetLogin.length > 0 : false) {
			Sys.sleep(.05);
			_readData(false);
			Sys.sleep(.05);
			result = sendTextLine(telnetLogin);
		}

		if (result && (telnetPassword != null ? telnetPassword.length > 0 : false)) {
			Sys.sleep(.05);
			_readData(false);
			Sys.sleep(.05);
			result = sendTextLine(telnetPassword);
		}

		return result;
	}

	public dynamic function telnetCheckingProc () {
		if (connected) {
			Sys.sleep(.5);
			return telnetControlChar != null ? readText().indexOf(telnetControlChar) >= 0 : true;
		}
		
		return false;
	}

	//------------------------------------------------------------------------------------------

	function telnetConnectProc () {
		var result = telnetLoginProc != null ? telnetLoginProc() : true;
		
		if (result)
			result = telnetCheckingProc != null ? telnetCheckingProc() : true;
		
		if (!result)
			disconnect();
		
		return result;
	}

	public override function connect (host:Host, port:Int) {
		if (super.connect(host, port))
			return telnetConnectProc();
		
		return false;
	}

	public override function reconnect () {
		if (super.reconnect())
			return telnetConnectProc();

		return false;
	}

	//------------------------------------------------------------------------------------------

	override public function sendData (data:Bytes) {
		if (connected)
			try {
				for (i in 0...data.length) {
					sendByte(data.get(i));
					Sys.sleep(telnetSendWaiting);
				}
			}
			catch (e:Dynamic) {
				disconnect();
			}
		
		return false;
	}

	override public function sendText (text:String) {
		var char = String.fromCharCode(0xFF);
		return text != null ? sendData(Bytes.ofString(text.replace(char, char+char))) : false;
	}

	override public function sendTextLine (text:String)
		return text != null ? sendText(text + telnetEndLineChar) : false;

	//------------------------------------------------------------------------------------------

	override function _readData (readLine:Bool)
		return parseTelnet(tcpSocket.dataStream, new BytesBuffer(), readLine).getBytes();

	function parseTelnet (stream:NetworkStream, sb:BytesBuffer, readline:Bool) {
		do {
			while (stream != null ? stream.dataAvailable : false) {
				var input = stream.readByte();
				
				switch (input) {
					case Verbs.IAC:
						var inputverb = stream.readByte();

						switch (inputverb) {
							case Verbs.IAC:
								sb.addByte(inputverb); // literal IAC = 255 escaped, so append char 255 to string
							case Verbs.DO, Verbs.DONT, Verbs.WILL, Verbs.WONT:
								var inputoption = stream.readByte();
								
								if (inputoption == -1)
									break;
								
								stream.writeByte(Verbs.IAC);
								
								if (inputoption == Options.SGA)
									stream.writeByte(inputverb == Verbs.DO ? Verbs.WILL : Verbs.DO);
								else
									stream.writeByte(inputverb == Verbs.DO ? Verbs.WONT : Verbs.DONT);
								
								stream.writeByte(inputoption);
							default:
						}
					default:
						if (readline && (input == 0 || input == 10 || input == 13))
							return sb;
						
						if (input != -1)
							sb.addByte(input);
				}
			}
			
			Sys.sleep(.01);
		}
		while (stream != null ? stream.dataAvailable : false);

		return sb;
	}

	//------------------------------------------------------------------------------------------

	public function telnetResponse (?request:String) {
		if (request != null)
			sendTextLine(request);
		
		Sys.sleep(telnetResponseWaiting);
		return readText();
	}
}