#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PALETTE_FILE="${DIR}/paletteColors"

function hexToRgb {
    color=$1
    if [ $(echo $color | wc -c) = 5 ]
    then
        color="#${color:1:1}${color:1:1}${color:2:1}${color:2:1}${color:3:1}${color:3:1}"
    fi
    printf "rgb(%s%%,%s%%,%s%%)" \
            $(echo "scale=3;$((0x${color:1:2}))*100/255" | bc) \
            $(echo "scale=3;$((0x${color:3:2}))*100/255" | bc) \
            $(echo "scale=3;$((0x${color:5:2}))*100/255" | bc)
}

function findNearestColor {
    rgb1=($(grep -o -P '(\d+(.\d+)?)(?=%)' <<< $1))
    r1=${rgb1[0]}
    g1=${rgb1[1]}
    b1=${rgb1[2]}
    
    smallestDistance=173
    bestColor=''
    
    while read -r paletteColor
    do
        rgb2=($(grep -o -P '(\d+(.\d+)?)(?=%)' <<< $paletteColor))
        r2=${rgb2[0]}
        g2=${rgb2[1]}
        b2=${rgb2[2]}
        distance=$(echo "scale=3;sqrt(($r2-$r1)^2 + ($g2-$g1)^2 + ($b2-$b1)^2)" | bc)
        if (( $(echo $distance'<'$smallestDistance | bc) ))
        then
            smallestDistance=$distance
            bestColor=$paletteColor
        fi
    done <<< $paletteColors
    
    echo $bestColor
}



paletteColors=$(for color in $(cat "$PALETTE_FILE")
        do
            echo $(hexToRgb $color)
        done)

for file in $(find -name "$1" -maxdepth 1 -type f -printf "%f\n")
do
    echo ===================================================
    echo $file
    svg=$(cat $file)
    file_colors=$(grep -o -P -i 'rgb\((\d+(.\d+)?%,?){3}\)|#((\d|[abcdef]){3}){1,2}' $file | sort -u)
    for file_color in $file_colors
    do
        if [ ${file_color:0:1} = '#' ]
        then
            file_color_rgb=$(hexToRgb $file_color)
        fi
        new_color=$(findNearestColor $file_color_rgb)
        echo $file_color '->' $new_color

        svg=$(sed "s/$file_color/$new_color/g" <<< $svg)
    done
    echo $svg > $file
done
