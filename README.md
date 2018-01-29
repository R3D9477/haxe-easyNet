# haxe-easyNet

A simple network library for Haxe.
<br/>
<br/>
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
<br/>
## Samples collection:
* TCP [Client](samples/tcp/socket/client/Source/Main.hx#L1)/[Server](samples/tcp/socket/server/Source/Main.hx#L1) (one thread) via TcpSocket
* TCP [Client](samples/tcp/tcpclient/client/Source/Main.hx#L1)/[Server](samples/tcp/tcpclient/server/Source/Main.hx#L1) (multithreaded) via TcpClient/TcpServer
* Telnet [Client](samples/tcp/telnet/client/Source/Main.hx#L1)/[Server](samples/tcp/telnet/server/Source/Main.hx#L1) (multithreaded) via TelnetClient/TelnetServer
<br/>
See wiki for more information!