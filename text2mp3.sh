#!/bin/bash
set -e

LONGEST_TEXT=100
LANGUAGE="es"
GOOGLE_URL="http://translate.google.com/translate_tts?tl=$LANGUAGE&q="
USERAGENT="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.31 (KHTML, like Gecko) Chrome/26.0.1410.65 Safari/537.31"
LOGFILE=log_`whoami`.txt

if [ "$1" == "" -o "$2" == "" ]; then
   echo "Usage: ./text2mp3.sh [directory] [text]"
   exit 1
fi

basedir=$1
exec 6>&1           # Link file descriptor #6 with stdout.
exec &> $basedir/$LOGFILE    # stdout replaced with file "logfile.txt".

checksum=`echo ${*:2} | openssl md5 | sed 's/^.* //'`

echo "Checksum [$checksum] for text [${*:2}]"

#filename needs to be wav is sox has no
#mp3 mixing support
filename="$checksum.wav"
if [ -f $basedir/$filename ]; then
    exec 1>&6 6>&-      # Restore stdout and close file descriptor #6.
    echo $filename
    exit
fi

text=""
#number starts in 1000 to avoid lexical rearrangements
slice=1000
files=()
for word in ${*:2}; do
    length=`expr ${#text} + ${#word} + 1`
    if [ $length -gt $LONGEST_TEXT ]; then
        slice+=1
        echo "Splitting text [$text] for slice $slice"
        splitfile="$basedir/$checksum$slice.mp3"
        files=("${files[@]}" $splitfile)
        wget -U "$USERAGENT" -O $splitfile "$GOOGLE_URL$text"
        text=$word
    else
      text+=" "$word
    fi
done;

if [ ${#text} -gt 0 ]; then
  slice+=1
  splitfile="$basedir/$checksum$slice.mp3"
  wget  -U "$USERAGENT" -O $splitfile "$GOOGLE_URL$text"
  files=("${files[@]}" $splitfile)
fi

IFS=" "
sox --combine sequence ${files[*]} $basedir/$filename
#TODO: output format consideration
#lame -v -m m -B 48 -s 44.1 input.wav output.mp3
exec 1>&6 6>&-      # Restore stdout and close file descriptor #6.
echo $filename
for f in $files; do
  rm $f
done;
