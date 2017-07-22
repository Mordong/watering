#!/bin/bash

raspivid -o - -t 0 -fps 25 -b 2500000 | ffmpeg -re -ar 44100 -ac 2 -acodec pcm_s16le -f s16le -ac 2 -i /dev/zero -f h264 -i - -vcodec copy -acodec aac -ab 128k -g 50 -f flv rtmp://a.rtmp.youtube.com/live2/8r0q-8tep-223h-dmuz

exit 0

