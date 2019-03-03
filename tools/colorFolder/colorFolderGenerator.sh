#!/bin/bash

colors=(black blue brown cyan green grey magenta orange red teal violet yellow)

color1='rgb(21.176%,48.235%,94.117%)'
color2='rgb(16.862%,38.431%,75.294%)'

color1_new=('#383c4a' '#367bf0' '#aa7a50' '#23bac2' '#17917a' '#737680' '#b8174c' '#fd7d00' '#d41919' '#20a8af' '#8c42ab' '#ffd86e')
color2_new=('#000000' '#2b62c0' '#775e49' '#20a8af' '#12715f' '#4c4c4c' '#93123d' '#b25800' '#b22525' '#198388' '#622e78' '#ffc730')


files=$(find -maxdepth 1 -iname "folder-*"  -printf "%f\n")


for i in $(seq 0 $[${#colors[*]}-1])
do
    for folder in $files
    do
        sed "s/${color1}/${color1_new[$i]}/g" <<< $(sed "s/${color2}/${color2_new[$i]}/g" < $folder) > folder-${colors[$i]}${folder##folder}
    done
    
    sed "s/${color1}/${color1_new[$i]}/g" <<< $(sed "s/${color2}/${color2_new[$i]}/g" < folder.svg) > folder-${colors[$i]}.svg
done
