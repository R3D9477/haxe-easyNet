package rn.net.tcp;

interface ITcpClient {
	public var connected (get, null) : Bool;

	public function connect (host:sys.net.Host, port:Int) : Bool;
	public function reconnect () : Bool;
	public function disconnect () : Void;

	public function sendData (data:haxe.io.Bytes) : Bool;
	public function sendText (text:String) : Bool;
	public function sendTextLine (text:String) : Bool;

	public function readData (notEmpty:Bool = true, readLine:Bool = false) : haxe.io.Bytes;
	public function readText (notEmpty:Bool = true, readLine:Bool = false) : String;
}