__author__="joydeep bhattacharjee"

# Lets say you have a lot of chunk jsonl files and these files are processed in batches and something failed
# in the nth batch. Now you want to know which batch it belongs to. This is a handy function that will do that.

var=0
for filename in *filanemapatterns.jsonl; do
	printf $filename;
	printf " ";
	current_count=$(cat $filename | wc -l)
	printf $current_count
	printf " ";
	var=$((var+$current_count));
	printf $var ;
	printf " ";
	echo "scale=0 ; $var / 20000" | bc
done
