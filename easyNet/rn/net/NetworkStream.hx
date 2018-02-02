package rn.net;

import haxe.io.*;

class NetworkStream {
	var inputBufferSize:Int;
	var inputBuffer:BufferInput;
	var outputStream:Output;

	//----------------------------------------------------------------------------------------------

	public var canRead (get, null) : Bool;
	function get_canRead () return if (inputBufferSize > 0 && inputBuffer != null) try { refill(); true; } catch (e:Dynamic) { Type.getClass(e) != haxe.io.Eof; } else false;

	public var canWrite (get, null) : Bool;
	function get_canWrite () return outputStream != null;

	//----------------------------------------------------------------------------------------------

	public var length (get, null) : Int;
	function get_length () return canRead ? inputBuffer.available : 0;

	public var dataAvailable (get, null) : Bool;
	function get_dataAvailable () return length > 0;

	//----------------------------------------------------------------------------------------------

	public function new (?inputBufferSize:Int) {
		this.inputBufferSize = inputBufferSize == null ? 1 : inputBufferSize;
		inputBuffer = null;
	}

	//----------------------------------------------------------------------------------------------

	public function setStream (inputStream:Input, outputStream:Output) {
		inputBuffer = new BufferInput(inputStream, Bytes.alloc(inputBufferSize));
		this.outputStream = outputStream;
	}

	public function setSocketStream (socket:sys.net.Socket) setStream(socket.input, socket.output);

	//----------------------------------------------------------------------------------------------

	public function refill (force:Bool = false)
		if (inputBuffer.available < 1 || force) inputBuffer.refill();

	public function readByte ()
		return dataAvailable ? try { inputBuffer.readByte(); } catch (e:Dynamic) { -1; } : -1;

	public function writeByte (data:Int)
		return if (canWrite && data != null) try { outputStream.writeByte(data); true; } catch (e:Dynamic) { false; } else false;

	public function write (data:Bytes)
		return if (canWrite && (data != null ? data.length > 0 : false)) try { outputStream.write(data); true; } catch (e:Dynamic) { false; } else false;
	
	//----------------------------------------------------------------------------------------------

	public function close () {
		inputBufferSize = 0;
		
		if (inputBuffer != null)
			try { inputBuffer.close(); } catch (e:Dynamic) { }

		inputBuffer = null;

		if (outputStream != null)
			try { outputStream.close(); } catch (e:Dynamic) { }

		outputStream = null;
	}
}