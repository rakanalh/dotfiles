#!/bin/bash

pgrep i3lock || {
    FILE=/tmp/lock$RANDOM.png
    TEXT=/tmp/locktext$(whoami).png
    LOCK=$HOME/.config/i3/lock-screen.png

    scrot -z $FILE
    i3lock -i $FILE

    [ -f $TEXT ] || {
        convert -size 2560x60 xc:black -font Hack-Regular -pointsize 26 -fill "#00ff00" -gravity center -annotate +0+0 "$(whoami)@$(hostname)" $TEXT
        convert $TEXT -alpha set -channel A -evaluate set 75% $TEXT;
    }

    convert $FILE -blur 0x7 $FILE
    convert $FILE $LOCK -gravity center -composite $FILE
    convert $FILE $TEXT -gravity center -geometry +0+200 -composite $FILE

    kill $(pgrep i3lock)

    i3lock -i $FILE
    rm $FILE
    # xset dpms force off
}
