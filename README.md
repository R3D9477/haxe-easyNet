# haxe-easyNet

A simple network library for Haxe.

## Installation:
Via [haxelib](https://lib.haxe.org/): `haxelib git easyNet https://github.com/r3d9u11/haxe-easyNet`

## Currently provides:
* Data streaming
  * [NetworkStream](../../wiki/rn.net.io.NetworkStream#networkstream)
* TCP connection
  * [TcpSocket](../../wiki/rn.net.tcp.TcpSocket#tcpsocket)
  * [TcpClient](../../wiki/rn.net.tcp.TcpClient#tcpclient)
  * [TcpServer](../../wiki/rn.net.tcp.TcpServer#tcpserver)
* Telnet connection (over TCP)
  * [TelnetClient](../../wiki/rn.net.tcp.telnet.TelnetClient#telnetclient)
  * [TelnetServer](../../wiki/rn.net.tcp.telnet.TelnetServer#telnetserver)

## Samples collection:
* TCP [Client](samples/tcp/socket/client/Source/Main.hx#L1)/[Server](samples/tcp/socket/server/Source/Main.hx#L1) (one thread) via [TcpSocket](../../wiki/rn.net.tcp.TcpSocket#tcpsocket)
* TCP [Client](samples/tcp/tcpclient/client/Source/Main.hx#L1)/[Server](samples/tcp/tcpclient/server/Source/Main.hx#L1) (multithreaded) via [TcpClient](../../wiki/rn.net.tcp.TcpClient#tcpclient)/[TcpServer](../../wiki/rn.net.tcp.TcpServer#tcpserver)
* Telnet [Client](samples/tcp/telnet/client/Source/Main.hx#L1)/[Server](samples/tcp/telnet/server/Source/Main.hx#L1) (multithreaded) via [TelnetClient](../../wiki/rn.net.tcp.telnet.TelnetClient#telnetclient)/[TelnetServer](../../wiki/rn.net.tcp.telnet.TelnetServer#telnetserver)
  * [Sample of the Telnet Client](samples/tcp/telnet-ttygames/client-telehack.com) for online game [Telehack.com](http://telehack.wikia.com/wiki/Telehack_Wiki)

See [wiki](../../wiki) for more information!