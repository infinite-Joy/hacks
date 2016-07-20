# this will create all the directories and touch the file
# and then use it like any other command
# source mktouch.sh
# mktouch ./base/data/sounds/effects/camera_click.ogg ./some/other/file
# taken from: http://stackoverflow.com/questions/9452935/unix-create-path-of-folders-and-file
mktouch() {
  if [ $# -lt 1 ]; then
    echo "Missing argument";
    return 1;
  fi

  for f in "$@"; do
     mkdir -p -- "$(dirname -- "$f")"
     touch -- "$f"
  done
}
