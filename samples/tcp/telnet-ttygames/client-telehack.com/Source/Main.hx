package;

import sys.net.Host;
import rn.net.tcp.telnet.TelnetClient;

class Main {
	public static function main () {
		var client = new TelnetClient ();
		client.telnetCheckingProc = null;
		
		if (client.connect(new Host("telehack.com"), 23)) {
			Sys.print(client.readText());
			Sys.print(client.readText());

			while (client.connected) {
				client.sendByte(Sys.getChar(false));
				Sys.print(client.readText(true, true));
			}
		}
		else
			trace("can't connect to Telehack!");
		
		client.disconnect();
	}
}