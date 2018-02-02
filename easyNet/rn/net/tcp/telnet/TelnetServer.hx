package rn.net.tcp.telnet;

import rn.net.tcp.TcpServer;
import rn.net.INetworkClient;

using StringTools;

class TelnetServer extends TcpServer {
	public var telnetLoginMessage = "login:";
	public var telnetPasswMessage = "passw:";

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

	function clientAuthProc (client:INetworkClient) {
		var result = true;
		
		if (telnetAuthProc != null)
			if (result = client.sendTextLine(telnetLoginMessage)) {
				var login = client.readText().trim();
				if (result = client.sendTextLine(telnetPasswMessage)) {
					var passw = client.readText().trim();
					result = telnetAuthProc(login, passw);
				}
			}
		
		if (result)
			onClientAuthSucceed(cast(client, TelnetClient));
		else
			onClientAuthFailed(cast(client, TelnetClient));
		
		return result;
	}
}