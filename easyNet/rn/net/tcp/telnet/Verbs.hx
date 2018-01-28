package rn.net.tcp.telnet;

@:enum
abstract Verbs(Int) from Int to Int {
	var WILL = 251;
	var WONT = 252;
	var DO = 253;
	var DONT = 254;
	var IAC = 255;
}