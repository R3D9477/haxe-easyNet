package rn.net.tcp.telnet;

import rn.net.tcp.TcpServer;

using StringTools;

class TelnetServer extends TcpServer {
	public var telnetWelcome:String;

	//------------------------------------------------------------------------------------------
	
	public dynamic function telnetAuthProc (login:String, password:String) : Bool return true;

	public dynamic function onClientAuthSucceed (client:TelnetClient) { }

	public dynamic function onClientAuthFailed (client:TelnetClient) { }

	//------------------------------------------------------------------------------------------

	public function new (?tcpListener:TcpSocket, ?inputBufferSize:Int) {
		super(tcpListener, inputBufferSize);

		clientClass = TelnetClient;
		clientCheckingProc = clientAuthProc;
	}

	//------------------------------------------------------------------------------------------

	function clientAuthProc (client:ITcpClient) {
		var result = true;
		
		if (telnetAuthProc != null) {
			client.sendTextLine("login:");
			var login = client.readText().trim();
			
			client.sendTextLine("passw:");
			var passw = client.readText().trim();
			
			result = telnetAuthProc(login, passw);
		}
		
		if (result) {
			client.sendText(telnetWelcome);
			onClientAuthSucceed(cast(client, TelnetClient));
		}
		else
			onClientAuthFailed(cast(client, TelnetClient));
		
		return result;
	}
}