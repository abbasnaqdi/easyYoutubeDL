#!/usr/bin/env bash
terminal=$(tty)
clear

OS=uname
echo "Processing ..."

q="1080"
s="none"
p=$PWD
m="6g"
t="video"
fps="60"

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

setting="--compat-options all --external-downloader aria2c -N 8 --console-title -ciw -4 -R infinite --max-filesize $m"

if [[ $s == *"none"* ]]; then
	subtitle=""
else
	subtitle="--write-sub --write-auto-sub --embed-subs --sub-lang $s --convert-subs srt"
fi
quality="-f bestvideo[height=$q][fps=$fps]+bestaudio/bestvideo[height<=$q][fps<=$fps]+bestaudio/bestvideo+bestaudio/best --merge-output-format mp4"

if [[ $t == *"audio"* ]]; then
	quality="-f bestaudio/best --merge-output-format m4a"
fi

videoOutput="-o $p/youtube/other/%(title)s.%(ext)s"
listOutput="-o $p/youtube/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s"
channelOutput="-o $p/youtube/%(uploader)s/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s"
musicOutput="-o $p/soundcloud/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s"
otherOutput="-o $p/other/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s"
hlsOutput="-o $p/hls/%(title)s.%(ext)s"

video="$setting $quality $subtitle $videoOutput"
playlist="$setting $quality $subtitle $listOutput"
channel="$setting $quality $subtitle $channelOutput"
music="$setting $musicOutput"
other="$setting $quality $subtitle $otherOutput"
hlsConfig="$setting $quality $subtitle $hlsOutput"

downoadURL() {
	if [[ $t == *"audio"* ]] && [[ $1 == *"soundcloud"* ]]; then
		yt-dlp $music -i $1
	elif [[ $t == *"video"* ]]; then
		if [[ $1 == *"youtube"* ]] && [[ $1 == *"watch"* ]]; then
			yt-dlp $video --no-playlist -i $1
		elif [[ $1 == *"youtube"* ]] && [[ $1 == *"@"* || $1 == *"user"* ]]; then
			yt-dlp $channel -i $1
		elif [[ $1 == *"youtube"* ]] && [[ $1 == *"list"* ]]; then
			yt-dlp $playlist -i $1
		fi
	elif [[ $t == *"hls"* ]]; then
		yt-dlp --hls-use-mpegts $hlsConfig $1 &
	else
		yt-dlp $other -i $1
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
	else
		downoadURL $url
	fi

done
exec <"$terminal"
