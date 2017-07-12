# play-bash
Help manage yours Play framework servers on the bash terminal

Create Symbolic link playb

`sudo ln -s /your/path/play-bash/playb.sh /usr/bin/playb`
 > Create sympolic link for execute everywhere
```sh
sudo ln -s /your/path/play-bash/playb.sh /usr/bin/playb
```

Commands:

# play-bash

<p align="center">
  <img width="600" height="300" src="./header.png">
</p>

 
## About

Help manage yours Play framework production servers on the bash terminal

### Create Symbolic link playb
 
### Commands

 1. Start 
 > Start one play server. Do you need put port number and path project
```sh
sudo playb start 9001 /opt/git/play-project/
```

 2. Kill 
 > Kill only one. Do you need put port number
```sh
sudo playb kill 9001
```

 > Kill all servers. Do you need put -a ( all ) option
```sh
sudo playb kill -a
```

 3. Compile 
 > Compile one project
```sh
sudo playb compile
```
> Compile one project with memory
```sh
sudo playb compile -mem 256
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
 > Restart one server. Do you need put one port and path project
```sh
sudo playb restart 9001 /opt/git/play-project/
```