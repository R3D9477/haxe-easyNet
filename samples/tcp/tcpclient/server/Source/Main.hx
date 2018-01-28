package;

import sys.net.Host;
import rn.net.tcp.TcpServer;
import rn.net.tcp.ITcpClient;

class Main {
	public static function main () {
		var server = new TcpServer ();
		
		server.onClientBeforeConnect = function (client:ITcpClient) trace ('client connected');
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