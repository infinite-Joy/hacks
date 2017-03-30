
**To record a mscreencast**::

    ffmpeg -f x11grab -video_size 1366x768 -t 1:00 -i $DISPLAY -f alsa -i default -c:v ffvhuff -c:a flac test.mkv

**to convert a vid**::

    mencoder test.mkv -oac copy -ovc x264 -o test_low_qual1.avi

Refs: https://wiki.archlinux.org/index.php/MEncoder

**How to crop a video**::

    ffmpeg -i run_python_from_file.mkv -filter:v "crop=300:300:0:0" out.mkv
    
ref: https://superuser.com/questions/510985/how-can-i-crop-a-video-to-a-part-of-the-view
