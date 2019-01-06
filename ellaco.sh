#!/usr/bin/env bash
terminal=`tty`

echo "LOADING ..."

log="log.txt"
aria="-x6 -s6 -j1 -c -m 1000 --retry-wait=15 -d aria/"
setting="-ciw -4 -R infinite"
quality="-f best"
subtitle="--write-auto-sub --sub-lang fa --embed-subs"
videoOutput="-o youtube/%youtube/%(title)s.%(ext)s"
listOutput="-o youtube/%(playlist)s/%(playlist_index)s.%(title)s.%(ext)s -i --yes-playlist"
channelOutput="-o youtube/%(uploader)s/(channel)s/(playlist)s/%(playlist_index)s.%(title)s.%(ext)s"

while getopts l: option 
do 
 case "${option}" 
 in 
 l) list=${OPTARG};;
 esac 
done 

rm -rf $log
touch $log
printLOG(){
	echo $1 >> $log
}

downoadURL(){
	if [[ $1 == *"&list="* ]]; then
		youtube-dl $quality $setting $subtitle $listOutput $1
	elif [[ $1 == *"watch"* ]]; then
		youtube-dl $quality $setting $subtitle $videoOutput $1
	elif [[ $1 == *"channel"* ]]; then
		youtube-dl $quality $setting $subtitle $channelOutput $1
	elif [[ $1 == *"http"* && $1 != *"youtube"* ]]; then
		aria2c $aria $1
	else 
		printLOG "JUMP"
		return
	fi

	printLOG "DOWNLOADED URL -> $url"
}

exec < $list
 while read -r url
  do

   if [[ $1 == *"end"* ]]; then
		printLOG "END DOWNLOAD"
		say complete download items #macos
		break
		return
	else downoadURL $url
	fi
	
  done
exec < "$terminal"
