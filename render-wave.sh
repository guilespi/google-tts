#!/bin/bash
trap 'rm /tmp/agi$$_*; exit' INT TERM HUP
#declare -a array
while read -e ARG && [ "$ARG" ] ; do :; done # variables not needed
#        array=(` echo $ARG | sed -e 's/://' -e 's/"//g'`)
#       varname=${array[0]}
#        unset array[0]
#       export $varname="${array[*]}"
#done
unqarg=` echo $1 | sed -e 's/"//g'`

checkresults() {
        while read line
        do
        case ${line:0:4} in
        "200 " ) echo $line >&2
                 return;;
        "510 " ) echo $line >&2
                 return;;
        "520 " ) echo $line >&2
                 return;;
        *      ) echo $line >&2;;       #keep on reading those Invlid command
                                        #command syntax until "520 End ..."
        esac
        done
}

wavename=`/usr/share/asterisk/agi-bin/text2mp3.sh /tmp "$unqarg"`
sox /tmp/$wavename -r 8000 -t ul /tmp/$wavename.ulaw
echo "EXEC Playback /tmp/$wavename"
checkresults

rm /tmp/$wavename.ulaw
