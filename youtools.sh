#!/bin/bash
# youtools.sh by -z-
# ./youtools.sh -y http://www.youtube.com/watch?v=V5bYDhZBFLA 00:17 10 5 160:120
# ./youtools.sh -y http://www.youtube.com/watch?v=V5bYDhZBFLA 00:42 4 4 320:240 mmm.gif 1

youtube_to_gif() {
	if [[ "$1" == "" ]]; then echo "video url required"; exit 0; fi
	url=$1
	start=${2:-0}
	duration=${3:-15}
	framestep=${4:-5}
	scale=${5:-320:240}
	youtube-dl -o "%(id)s.%(ext)s" $url
	video=$(ls ${url##*=}* |grep -v gif| tail -n1)
	gif=${6:-${video%.*}.gif}
	r=${7:-}
	video_to_gif $video $start $duration $framestep $scale $gif $r
}

video_to_gif() {
	if [[ "$1" == "" ]]; then echo "video file required"; exit 0; fi
	video=$1
	start=${2:-0}
	duration=${3:-15}
	framestep=${4:-5}
	scale=",scale="${5:-320:240}
	gif=${6:-${video%.*}.gif}
	echo mplayer $video -ss $start -endpos $duration -vo png:outdir=temp_$video -vf framestep=${framestep}$scale -nosound
	mplayer $video -ss $start -endpos $duration -vo png:outdir=temp_$video -vf framestep=${framestep}$scale -nosound
	cd temp_$video
	if [[ "$7" == "1" ]]; then
		lastfile=$(ls -rtv | head -n1)
		count=${lastfile##*0}
		i=${count%%.png}
		for f in $(ls -rtv); do
			let i++
			fc=${f%%.png}; j=$((10#$fc)); k=$((j+1)); z=${fc/$j/}
			cp $f $z$i.png
		done
	fi
	echo "creating gif"
	convert $(ls -tv) $gif
	mv $gif ..
	cd ..
	rm -r temp_$video
	#eom $gif
}

youtube_to_mp3() {
	if [[ "$1" == "" ]]; then echo "video url required"; exit 0; fi
	youtube-dl -t $1
	mplayer -dumpaudio $1 -dumpfile ${1%.*}.mp3
}
youtube_to_mp3_batch() {
    #mediainfo --Inform="Audio;%BitRate/String%"
    #for f in *.{mp4,flv}; do echo -e $f; mediainfo --Inform="Audio;%BitRate/String%" $f; done
    #youtube-dl -t -f 35 --extract-audio --audio-format=mp3 http://www.youtube.com/watch?v=6g6g2mvItp4
    #youtube-dl -t -f 35 -a videos.txt
    youtube-dl -t -a videos.txt
    #for f in *.mp4; do mplayer -dumpaudio $f -dumpfile ${f%.*}.mp3; done
    for f in *.{flv,mp4}; do
        artist=$(echo $f | awk -F "-" '{ print $1 }' | sed 's/_/ /g;s/^[ \t]*//;s/[ \t]*$//')
        title=$(echo $f | awk -F "-" '{ print $2 }' | sed 's/_/ /g;s/^[ \t]*//;s/[ \t]*$//')
        #echo ffmpeg -i $f -f mp3 -ab 192000 -metadata title="$title" -metadata artist="$artist" ${f%.*}.mp3
        echo ffmpeg -i $f -f mp3 -ab 192000 -metadata title="$title" -metadata artist="$artist" ${f%.*}.mp3
        #ffmpeg -i $f -f mp3 -ab 192000 -metadata title="$title" -metadata artist="$artist" ${f%.*}.mp3
        ffmpeg -i $f -f mp3 -ab 192000 -metadata title="$title" -metadata artist="$artist" ${f/%${f##*.}}mp3
    done
}

video_to_mp3() {
	if [[ "$1" == "" ]]; then echo "video file required"; exit 0; fi
	mplayer -dumpaudio $1 -dumpfile ${1%.*}.mp3
}

h() {
	echo "read the source"
}

select=$1
shift
case $select in
  --youtube_to_gif|-y) youtube_to_gif $@;;
  --video_to_gif|-v) video_to_gif $@;;
  --youtube_to_mp3_batch|-b) youtube_to_mp3_batch;;
  --youtube_to_mp3|-t) youtube_to_mp3 $@;;
  --video_to_mp3|-m) video_to_mp3 $@;;
  --help|-h|*) h;;
esac

