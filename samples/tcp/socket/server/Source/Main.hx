package;

import sys.net.Host;
import rn.net.tcp.TcpSocket;

class Main {
	public static function main () {
		var server = new TcpSocket ();
		
		if (server.bind(new Host("localhost"), 5000)) {
			trace("server started at 5000");

			var client:TcpSocket = server.accept();
			trace("client accepted");

			while (!client.dataStream.dataAvailable)
				Sys.sleep(1);
			
			trace('data length to read: ${client.dataStream.length}');
			trace('client: ${client.dataStream.readByte()}');

			client.dataStream.writeByte(2);

			var isConnected:Bool;
			do {
				isConnected = client.connected;
				trace('client connected: $isConnected');
				Sys.sleep(.5);
			}
			while (isConnected);
		}
		else
			trace("can't start server!");

		server.close();
	}
}
