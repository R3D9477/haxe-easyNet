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
				var cmdBuff = Sys.stdin().readLine() + String.fromCharCode(13);

				for (i in 0...cmdBuff.length) {
					client.sendByte(cmdBuff.charCodeAt(i));
					Sys.sleep(.1);
				}
				
				Sys.sleep(.5);
				Sys.print(client.readText().substring(cmdBuff.length));
			}
		}
		else
			trace("can't connect to Telehack!");
		
		client.disconnect();
	}
}