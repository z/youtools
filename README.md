youtools.sh
====================
Version: 0.5
Author: Tyler Mulligan (www.interwebninja.com)

## Introduction

youtools.sh is a collection of functions that I wrote to assist in modifying popular culture found on youtube.

## Dependencies

bash, youtube-dl, mplayer, imagemagick

Ubuntu / Debian users:

    sudo apt-get install youtube-dl mplayer imagemagick

youtube-dl will give you instructions on how to update it. You'll need the latest version through their upgrade mechanism to make sure it works.

## Installation

Clone to a script directory. Don't run out of $HOME, you'll make problems for yourself.

## Usage

Beyond the use case below, you're required to read and understand the functions in their simplicity.

    ./youtools.sh -y http://www.youtube.com/watch?v=V5bYDhZBFLA 00:17 10 5 160:120

There are a lot of potential uses here.

## Birthing the Idea

My progression in developing this concept started as a one-liner based on the idea that I could write a bash script that wraps youtube-dl and creates a gif where I specify the duration, start point and frame rate.

    url=http://www.youtube.com/watch?v=V5bYDhZBFLA; youtube-dl -b $url; mplayer $(ls ${url##*=}*| tail -n1) -ss 00:57 -endpos 10 -vo gif89a:fps=5:output=output.gif -vf scale=400:300 -nosound

This works but the quality is sub par.

I reworked it to use imagemagick 

    mplayer f4vRdgdj75I.mp4 -ss 0:45 -endpos 6 -vo png:outdir=animated4 -vf framestep=5 -nosound
    convert *.png out.gif

The imagemagick one-liner:

    url=http://www.youtube.com/watch?v=V5bYDhZBFLA; youtube-dl -b $url; video=$(ls ${url##*=}*| tail -n1); mplayer $video -ss 00:57 -endpos 5 -vo png:outdir=animated_$video -vf scale=400:300,framestep=5 -nosound; cd animated_$video; convert *.png $video.gif

The other functions assist in audio separation ;)

## Additional tricks

I was playing around with generating "random" gifs from videos, here are a few bash commands I created to generate them, I won't explain them before the comments above them, they are what they are:

    # sequential gifs every 10 seconds, 3 second duration
    i=0; for t in {0..3}:{01..60..10}; do ./youtools.sh -v kfVsfOSbJY0.mp4 $t 3 4 320:180 friday-$i.gif; i=$(($i+1)); done

    # 3 gifs at random timesteamps per minute, aspect ratio 16:9, $m is a multiplier for size based on aspect ratio, $d is duration, $fr is framerate, $ar calculates the size based on the aspect ratio, it will random loop back from the last pimage if it was't to.
    rn(){ printf "%02d" $(($RANDOM%30)); }; nt() { echo {0..2}:$(rn); }; name="icecreamy"; video="g6Z0zyM6Auc.mp4" aw=16; ah=9; i=0; for t in $(nt); do m=$(shuf -i 20-40 -n1); d=$(shuf -i 2-6 -n1); fr=$(shuf -i 3-8 -n1); ar=$(($aw*$m)):$(($ah*$m)); r=$(($RANDOM%2)); ./youtools.sh -v $video $t $d $fr $ar $name-${ar/:/x}-${t/:/_}-$d-$fr-$r-$i.gif $r; i=$(($i+1)); done

    # Wadsworth Constant... Creates an 8 second gif starting at 30% of the video
    ww(){ name=$1; video=$2 aw=16; ah=9; $m=20; ./youtools.sh -v $video $(dur=$(mplayer -vo null -ao null -identify -frames 0 $video | grep ID_LENGTH | awk -F "=" '{ print $2 }'); scale=2; echo $dur*.30 | bc) 8 6 $(($aw*$m)):$(($ah*$m)) $name.gif }; 

good luck, have fun
