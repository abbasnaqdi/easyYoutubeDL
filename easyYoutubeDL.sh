#!/usr/bin/env bash
terminal=$(tty)
clear

OS=uname
echo "Processing ..."

q="highest"
s="none"
p=$PWD
m="2g"
t="video"

while getopts :t:q:m:p:s:f: option; do
	case "${option}" in
		t) t=${OPTARG} ;;
q) q=${OPTARG} ;;
m) m=${OPTARG} ;;
p) p=${OPTARG} ;;
s) s=${OPTARG} ;;
f) f=${OPTARG} ;;
esac
done

log="$p/log.txt"
rm -rf $log
touch $log
printLOG() {
	echo $1 >>$log
}

setting="--console-title -ciw -4 -R infinite --max-filesize $m"

if [[ $s == *"none"* ]]; then
	subtitle=""
else
	subtitle="--write-sub --write-auto-sub --embed-subs --sub-lang $s --convert-subs srt"
fi

quality="-f bestvideo[ext=mp4]+bestaudio/bestvideo+bestaudio/best"

if [[ $t == *"audio"* ]]; then
	quality="-f bestaudio[ext=m4a]"
elif [[ $q != *"highest"* ]]; then
	quality="-f $q"
fi


videoOutput="-o $p/youtube/other/%(title)s.%(ext)s"
listOutput="-o $p/youtube/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s"
channelOutput="-o $p/youtube/%(uploader)s/(channel)s/(playlist)s/%(playlist_index)s.%(title)s.%(ext)s"
musicOutput="-o $p/soundcloud/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s"
otherOutput="-o $p/other/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s"
hlsOutput="-o $p/hls/%(title)s.%(ext)s"

video="$quality $setting $subtitle $videoOutput"
playlist="$quality $setting $subtitle $listOutput"
channel="$quality $setting $subtitle $channelOutput"
music="$setting $musicOutput"
other="$setting $quality $subtitle $otherOutput"
hlsConfig="$setting $quality $subtitle $hlsOutput"

downoadURL() {
	if [[ $t == *"audio"* ]] && [[ $1 == *"soundcloud"* ]]; then
		youtube-dl  $music -i --external-downloader aria2c --external-downloader-args '--file-allocation=none -k 2M -x 16 -s 16 -c -j 4 -m 60 --retry-wait=6' $1
	elif [[ $t == *"video"* ]]; then
		if [[ $1 == *"youtube"* ]] && [[ $1 == *"watch"* ]]; then
			youtube-dl  $video -i --external-downloader aria2c --external-downloader-args '--file-allocation=none -k 2M -x 16 -s 16 -c -j 4 -m 60 --retry-wait=6' $1
		elif [[ $1 == *"youtube"* ]] && [[ $1 == *"list"* ]]; then
			youtube-dl  $playlist -i --external-downloader aria2c --external-downloader-args '--file-allocation=none -k 2M -x 16 -s 16 -c -j 4 -m 60 --retry-wait=6' $1
		elif [[ $1 == *"youtube"* ]] && [[ $1 == *"channel"* || $1 == *"user"* ]]; then
			youtube-dl  $channel -i --external-downloader aria2c --external-downloader-args '--file-allocation=none -k 2M -x 16 -s 16 -c -j 4 -m 60 --retry-wait=6' $1
		fi
	elif [[ $t == *"hls"* ]]; then
		youtube-dl --hls-use-mpegts $hlsConfig $1
	else 
		youtube-dl $other -i --external-downloader aria2c --external-downloader-args '--file-allocation=none -k 2M -x 16 -s 16 -c -j 4 -m 60 --retry-wait=6' $1
	fi

	printLOG "complete -> $1 & next ..."
}

exec <$f
while read -r url; do
	if [[ $1 == *"end"* ]]; then
		printLOG "jump"
		echo "complete download items"
		if [[ $OS == "Darwin" ]]; then
            say complete download items #macos
        fi
        break
        return
    elif [[ $t == *"hls"* ]]; then
    	downoadURL $url
    else downoadURL $url
    fi
    
done
exec <"$terminal"