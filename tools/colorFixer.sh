#!/bin/bash

paletteColors=(
    'rgb(0%,0%,0%)'
    'rgb(100%,100%,100%)'
	'rgb(97.647059%,87.058824%,41.176471%)'
	'rgb(100%,78.431373%,19.215686%)'
	'rgb(100%,78.431373%,19.215686%)'
	'rgb(5.882353%,63.137255%,37.254902%)'
	'rgb(10.588235%,63.921569%,53.72549%)'
	'rgb(90.196078%,90.196078%,90.196078%)'
	'rgb(27.058824%,27.058824%,27.058824%)'
	'rgb(32.156863%,70.196078%,85.098039%)'
	'rgb(21.176471%,48.235294%,94.117647%)'
	'rgb(72.941176%,9.019608%,30.588235%)'
)

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
