package;

import sys.net.Host;
import rn.net.tcp.TcpSocket;

class Main {
	public static function main () {
		var client = new TcpSocket ();
		
		if (client.connect(new Host("localhost"), 5000)) {
			trace("connected to server!");
			
			trace(client.dataStream.writeByte(1));

			while (!client.dataStream.dataAvailable)
				Sys.sleep(.01);
			
			trace('data length to read: ${client.dataStream.length}');
			trace('server: ${client.dataStream.readByte()}');
		}
		else
			trace("can't connect to server!");
		
		/*var isConnected:Bool;
		do {
			isConnected = client.connected;
			trace('client connected: $isConnected');
			Sys.sleep(.5);
		}
		while (isConnected);*/
		
		Sys.sleep(1.5);
		client.close();
		trace('client connected: ${client.connected}');
	}
}
