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
