package;

import sys.net.Host;
import rn.net.tcp.telnet.TelnetClient;

class Main {
	public static function main () {
		var client = new TelnetClient ();
		
		if (client.connect(new Host("telehack.com"), 23)) {
			Sys.sleep(.5);
			Sys.print(client.readText());
			
			while (client.connected) {
				var cmdBuff = Sys.stdin().readLine();
				client.sendTextLine(cmdBuff);
				Sys.sleep(.5);
				Sys.print(client.readText().substring(cmdBuff.length));
			}
		}
		else
			trace("can't connect to Telehack!");
		
		client.disconnect();
	}
}