package;

import sys.net.Host;
import rn.net.tcp.telnet.TelnetClient;

class Main {
	public static function main () {
		var client = new TelnetClient ();
		
		if (client.connect(new Host("avalon-rpg.com"), 23)) {
			Sys.print(client.telnetResponse());

			while (client.connected)
				Sys.print(client.telnetResponse(Sys.stdin().readLine()));
		}
		else
			trace("can't connect to Avalon!");
		
		client.disconnect();
	}
}