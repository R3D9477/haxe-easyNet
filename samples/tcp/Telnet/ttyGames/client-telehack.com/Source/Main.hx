package;

import sys.net.Host;
import rn.net.tcp.telnet.TelnetClient;

class Main {
	public static function main () {
		var client = new TelnetClient ();
		
		if (client.connect(new Host("telehack.com"), 23)) {
			Sys.print(client.telnetResponse());
			
			while (client.connected) {
				var cmdBuff = Sys.stdin().readLine();
				Sys.print(client.telnetResponse(cmdBuff).substring(cmdBuff.length));
			}
		}
		else
			trace("can't connect to Telehack!");
		
		client.disconnect();
	}
}