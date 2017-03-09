
**To record a mscreencast**

ffmpeg -f x11grab -video_size 1366x768 -t 1:00 -i $DISPLAY -f alsa -i default -c:v ffvhuff -c:a flac test.mkv

**to convert a vid**

mencoder test.mkv -oac copy -ovc x264 -o test_low_qual1.avi

Refs: https://wiki.archlinux.org/index.php/MEncoder
