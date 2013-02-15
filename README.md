google-tts
==========

Bash script to create wave files using google text to speech online service.

```bash
./text2mp3.sh /tmp Please convert this text to a wave file for me!
f056e7eb018997c427083320c50a168a.wav
```

The script receives two parameters, the `directory` to be used and the `text` to be translated.

```bash
guilespi$ ./text2mp3.sh 
Usage: ./text2mp3.sh [directory] [text]
```

* Configuration * 

There are three important parameters to configure the script

```bash
LONGEST_TEXT=100 
LANGUAGE="es" 
GOOGLE_URL="http://translate.google.com/translate_tts?tl=$LANGUAGE&q=" 
```

`LONGEST_TEXT` is the maximum number of chars the google service will take before failing with a `404` error.
`LANGUAGE` is the language of your choice
`GOOGLE_URL` is the url used to generate the wave file.

Usually you'll only change the desired language.
