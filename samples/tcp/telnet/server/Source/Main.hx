package;

import sys.net.Host;
import rn.net.tcp.telnet.TelnetServer;
import rn.net.tcp.ITcpClient;

class Main {
	public static function main () {
		var server = new TelnetServer ();
		
		server.onClientBeforeConnect = function (client:ITcpClient) trace ('client connected');
		server.onClientAuthSucceed = function (client:ITcpClient) trace ('client authorized');
		server.onClientAfterConnect = function (clientUuid:String) server.sendTextLine(clientUuid, "hello from server!");
		
		server.onClientText = function (clientUuid:String, text:String) trace ('client: $text');
		
		if (server.start(new Host("localhost"), 5000)) {
			trace("server started at 5000");
			trace("press any key to exit...");
			Sys.getChar(false);
		}
		else
			trace("can't start server!");

		server.stop();
	}
}