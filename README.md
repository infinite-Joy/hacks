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

### How to check the links in the webpage and find  broken links

    wget --spider -r -nd -nv -H -l 1 -w 2 -o run1.log  https://flawcode.com/episode/show/6/

### In case you want jupyter notebook to have a new environment as well

source activate myenv
python -m ipykernel install --user --name myenv --display-name "Python (myenv)"
source activate other-env
python -m ipykernel install --user --name other-env --display-name "Python (other-env)"

source: http://ipython.readthedocs.io/en/stable/install/kernel_install.html#kernels-for-different-environments

### Count the number of commits in the last one month.

    git log --before={`date "+%Y-%m-01"`} --after={`date --date='-1 month' "+%Y-%m-01"`} --author="joydeep bhattacharjee" --reverse --pretty=format:"%cd  %h  %an  %s" --date=short | cat | wc -l

### put all file paths that needs to be changed and run sed file replace on all of them

git diff and find only the file names

    git diff --name-only mario_26_code_coverage dev | cat > file_path.txt
     
run sed file replace on all of them

    cat file_path.txt| xargs sed -i 's/old/new/g'

### find old word to be replaced and replace them everywhere in the project

    grep -r old_word * | cut -d ":" -f1 | grep -v Binary | grep -v .ropeproject | sort | uniq | xargs -L1 sed -i.bak -e 's/old_word/new_word/g'

### Setup vim based code jump in code

You need to have exuberant ctags installed first.

    sudo apt-get install exuberant-ctags
    
Run the following command in your code.

    ctags -R --fields=+l --languages=python --python-kinds=-iv -f ./tags $(python -c "import os, sys; print(' '.join('{}'.format(d) for d in sys.path if os.path.isdir(d)))")
    
 That should create a tag file in your root folder.
 
 ### Keep track of the memory with time stamp
 
    ➜  ~ vm_stat 10 | gawk 'NR>2 {now=strftime("%Y-%m-%d %T "); gsub("K","000");print now ($1+$4)/256000}'
    2018-08-25 21:40:55 6.16284
    2018-08-25 21:41:05 6.79999
    2018-08-25 21:41:15 6.57524
    2018-08-25 21:41:25 6.75619
    2018-08-25 21:41:35 6.40904

### Check if all the lines in a jsonl file are valid json.

while read line; do echo $line | python -c "import sys,json;json.loads(sys.stdin.read())"; done < filename.jsonl
