package;

import sys.net.Host;
import rn.net.tcp.telnet.TelnetClient;

class Main {
	public static function main () {
		var client = new TelnetClient ();
		
		if (client.connect(new Host("avalon-rpg.com"), 23)) {
			Sys.sleep(.5);
			Sys.print(client.readText());

			while (client.connected) {
				var input = Sys.stdin().readLine() + "\n";
				client.sendTextLine(input);
				Sys.sleep(.5);
				Sys.print(client.readText());
			}
		}
		else
			trace("can't connect to Avalon!");
		
		client.disconnect();
	}
}