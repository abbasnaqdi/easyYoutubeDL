#!/usr/bin/env bash
terminal=$(tty)
clear
echo "LOADING ..."

q="highest"
s="none"
p=$PWD
m="2g"

while getopts q:m:f:p:s: option; do
    case "${option}" in

    q) q=${OPTARG} ;;
    m) m=${OPTARG} ;;
    f) f=${OPTARG} ;;
    p) p=${OPTARG} ;;
    s) s=${OPTARG} ;;
    esac
done

log="log.txt"
rm -rf $log
touch $log
printLOG() {
    echo $1 >>$log
}

setting="-ciw -4 -R infinite --max-filesize $m"

if [[ $s == *"none"* ]]; then
    subtitle=""
else
    subtitle="--write-auto-sub --sub-lang $s --embed-subs"
fi

quality="-f bestvideo[ext=mp4]+bestaudio/bestvideo+bestaudio/best"
if [[ $q == *"audio"* ]]; then
    quality="-f bestaudio[ext=m4a] --embed-thumbnail --add-metadata"
elif [[ $q != *"highest"* ]]; then
    quality="-f $q"
fi

videoOutput="-o $p/youtube/other/%(title)s.%(ext)s"
listOutput="-o $p/youtube/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s"
channelOutput="-o $p/youtube/%(uploader)s/(channel)s/(playlist)s/%(playlist_index)s.%(title)s.%(ext)s"
musicOutput="-o $p/soundcoude/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s"
otherOutput="-o $p/other/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s"

video="$quality $setting $subtitle $videoOutput"
playlist="$quality $setting $subtitle $listOutput"
channel="$quality $setting $subtitle $channelOutput"
music="$setting $musicOutput"
other="$quality $otherOutput"

downoadURL() {
    if [[ $1 == *"youtube"* && $1 == *"watch"* ]]; then
        youtube-dl $video --convert-subs 'srt' --external-downloader aria2c --external-downloader-args '-x16 -s16 -j3 -c -k1m -m 60 --retry-wait=6' $1
    elif [[ $1 == *"youtube"* && $1 == *"list"* ]]; then
        youtube-dl $playlist --convert-subs 'srt' --external-downloader aria2c --external-downloader-args '-x16 -s16 -j3 -c -k1m -m 60 --retry-wait=6' $1
    elif [[ $1 == *"youtube"* && ($1 == *"channel"* || $1 == *"user"*) ]]; then
        youtube-dl $channel --convert-subs 'srt' --external-downloader aria2c --external-downloader-args '-x16 -s16 -j3 -c -k1m -m 60 --retry-wait=6' $1
    elif [[ $1 == *"soundcloud"* ]]; then
        youtube-dl $music --external-downloader aria2c --external-downloader-args '-x16 -s16 -j3 -c -k1m -m 60 --retry-wait=6' $1
    elif [[ $1 == *"end"* ]]; then
        printLOG "JUMP"
        return
    else
        youtube-dl $other --external-downloader aria2c --external-downloader-args '-x16 -s16 -j3 -c -k1m -m 60 --retry-wait=6' $1
    fi

    printLOG "DOWNLOADED URL -> $1"
}

exec <$f
while read -r url; do

    if [[ $1 == *"end"* ]]; then
        #say complete download items #macos
        echo "COMPLETE DOWNLOAD ITEMS"
        break
        return
    else
        clear
        downoadURL $url
    fi

done
exec <"$terminal"
