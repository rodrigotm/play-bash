# play-bash

<p align="center">
  <img width="600" height="300" src="./header.png">
</p>

 
## About

Help manage yours Play framework production servers on the bash terminal

### Symbolic link playb

> Create Symbolic link playb for execute everywhere
```sh
sudo ln -s /your/path/play-bash/playb.sh /usr/bin/playb
```
 
### Commands

 1. Start 
 > Start one play server. You need to put the port number and path project
```sh
sudo playb start 9001 /opt/git/play-project/
```

 2. Kill 
 > Kill only one. You need to put the port number
```sh
sudo playb kill 9001
```

 > Kill all servers. You need to put -a ( all ) option
```sh
sudo playb kill -a
```

 3. Compile 
 > Compile one project
```sh
sudo playb compile /opt/git/play-project/
```
> Compile one project with memory
```sh
sudo playb compile /opt/git/play-project/ -mem 256
```

4. Snapshot 
> Use for save all servers running and restore all
> For save use -s
```sh
sudo playb snapshot -s
```
> For restore use -r
```sh
sudo playb snapshot -r
```

 5. Restart
 > Restart one server. You need to put one port and path project
```sh
sudo playb restart 9001 /opt/git/play-project/
```
