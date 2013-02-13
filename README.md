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
