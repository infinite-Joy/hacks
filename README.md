# hacks


### change from print "string" to print("string")

in notepad++ cntrl+h

from `print\s"(.*)"(.*)` to `print\("\1"\2\)`

example:

`print "some string %s" % some_variable`

will become 

`print("some string %s" % some_variable)`

### find a specific line in file when line number is given

```perl
perl -ne 'print "$ARGV : $_" if $. == <line number>; } continue { close ARGV if eof;' <file name>
```

### how to get the longitude latitude from city

curl http://maps.googleapis.com/maps/api/geocode/json?address=London&sensor=false

### vimrc
This is my vimrc file

docs: https://github.com/klen/python-mode
http://docs.python-guide.org/en/latest/dev/env/

Also first install pathogen for this to work

clone it
```
git clone https://github.com/infinite-Joy/hacks.git
```
put it in the home folder and install
```
cd ~
cp hacks/myvimrc .vimrc

:so ~/.vimrc
:PluginInstall
```

### get output from a webpage
perl -MLWP::Simple -e "getprint 'https://domain.com/dummy/context/root/with/rest/api';"

### how to find which process taking which pid
```bash
port=$1
addr=`netstat -Aan | grep $port | awk '{print $1}'`
pid=`rmsock $addr tcpcb | awk '{print $9}'`
ps -ef | grep $pid
```

### install docker in ubuntu 32 bit

http://stackoverflow.com/questions/33420241/docker-on-ubuntu-15-10-32-bit-os-and-processor/38681348#38681348
```bash
git clone https://github.com/docker-32bit/ubuntu.git
cd ubuntu
bash build-image.sh
```

### copy a list of files later older than 2 days but not older than 30 days to new_folder
```find . -type f -mtime +2 -a -mtime -30 -print | xargs -I {} cp {} new_folder```

### Use jq to pretty print some json data with ANSI color coded syntax and use -R in less to process the color.

jq -C '.' data.json | less -R

### Generate output similar to 'tree' without using tree

```find . -print | sort | sed 's;[^/]*/;|---;g;s;---|; |;g'```
