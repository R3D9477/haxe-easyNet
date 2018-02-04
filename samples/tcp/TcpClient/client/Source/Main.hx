package;

import sys.net.Host;
import rn.net.tcp.TcpClient;

class Main {
	public static function main () {
		var client = new TcpClient ();
		
		if (client.connect(new Host("localhost"), 5000)) {
			trace("connected to server!");
			
			client.sendText("hello from client!");
			trace('server: ${client.readText()}');
		}
		else
			trace("can't connect to server!");
		
		Sys.sleep(1);
		client.disconnect();
	}
}
