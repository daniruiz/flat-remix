#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

paletteColors=($(cat "$DIR/paletteColors"))

function findNearestColor {
    rgb1=($(grep -o -P '(\d+(.\d+)?)(?=%)' <<< $1))
    r1=${rgb1[0]}
    g1=${rgb1[1]}
    b1=${rgb1[2]}
    
    smallerDistance=173
    bestColor=''
    
    for paletteColor in ${paletteColors[@]}
    do
        rgb2=($(grep -o -P '(\d+(.\d+)?)(?=%)' <<< $paletteColor))
        r2=${rgb2[0]}
        g2=${rgb2[1]}
        b2=${rgb2[2]}
        distance=$(echo "scale=3;sqrt(($r2-$r1)^2 + ($g2-$g1)^2 + ($b2-$b1)^2)" | bc)
        if (( $(echo $distance'<'$smallerDistance | bc) ))
        then
            smallerDistance=$distance
            bestColor=$paletteColor
        fi
    done
    
    echo $bestColor
}


for file in $(find -maxdepth 1 -type f -printf "%f\n")
do
    echo ===================================================
    echo $file
	svg=$(cat $file)
	file_colors=$(grep -o -P 'rgb\((\d+(.\d+)?%,?){3}\)' $file)
	for file_color in $file_colors
	do
	    new_color=$(findNearestColor $file_color)
	    echo $file_color '->' $new_color
	    	    
		svg=$(sed "s/$file_color/$new_color/g" <<< $svg)
	done
	echo $svg > $file
done
