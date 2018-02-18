# EasyNet

Library for easy and convenient working with network.<br/>
Currently for [Neko](https://api.haxe.org/neko/index.html) & [C++](https://api.haxe.org/cpp/index.html).

## Installation:
* via [haxelib](https://lib.haxe.org/)
  * stable: `haxelib install easyNet`
  * development: `haxelib git easyNet https://github.com/r3d9u11/haxe-easyNet`
* via [git](https://git-scm.com/): `git clone https://github.com/r3d9u11/haxe-easyNet`

## Currently provides:
* Data streaming
  * [NetworkStream](../../wiki/rn.net.io.NetworkStream#networkstream)
* TCP connection
  * [TcpSocket](../../wiki/rn.net.tcp.TcpSocket#tcpsocket)
  * [TcpClient](../../wiki/rn.net.tcp.TcpClient#tcpclient)
  * [TcpServer](../../wiki/rn.net.tcp.TcpServer#tcpserver) (multithreaded)
  * Telnet over TCP
    * [TelnetClient](../../wiki/rn.net.tcp.telnet.TelnetClient#telnetclient)
    * [TelnetServer](../../wiki/rn.net.tcp.telnet.TelnetServer#telnetserver) (multithreaded)

## Samples collection:
* TCP [Client](samples/tcp/TcpSocket/client/Source/Main.hx#L1)/[Server](samples/tcp/TcpSocket/server/Source/Main.hx#L1) via [TcpSocket](../../wiki/rn.net.tcp.TcpSocket#tcpsocket)
* TCP [Client](samples/tcp/TcpClient/client/Source/Main.hx#L1)/[Server](samples/tcp/TcpClient/server/Source/Main.hx#L1) via [TcpClient](../../wiki/rn.net.tcp.TcpClient#tcpclient)/[TcpServer](../../wiki/rn.net.tcp.TcpServer#tcpserver)
* Telnet [Client](samples/tcp/Telnet/TelnetClient/client/Source/Main.hx#L1)/[Server](samples/tcp/Telnet/TelnetClient/server/Source/Main.hx#L1) via [TelnetClient](../../wiki/rn.net.tcp.telnet.TelnetClient#telnetclient)/[TelnetServer](../../wiki/rn.net.tcp.telnet.TelnetServer#telnetserver)
  * [Telnet Client](samples/tcp/Telnet/ttyGames/client-telehack.com/Source/Main.hx#L1) for online game [Telehack.com](http://telehack.wikia.com/wiki/Telehack_Wiki)
  * [Telnet Client](samples/tcp/Telnet/ttyGames/client-avalon-rpg.com/Source/Main.hx#L1) for online game [Avalon-rpg.com](https://www.avalon-rpg.com/guide/facts/)

## Tested with:
* Haxe 3.4.4
* Neko 2.1.0
* HXCPP 3.4.188
* Linux Mint 18.3 x64

See [wiki](../../wiki) for more information!