#!/bin/bash

colors=(black blue brown cyan green grey magenta orange red teal violet yellow)

color1='rgb(21.176%,48.235%,94.117%)'
color2='rgb(16.862%,38.431%,75.294%)'

color1_new=('rgb(21.960%,23.529%,29.019%)' 'rgb(21.176%,48.235%,94.117%)' 'rgb(74.117%,59.215%,46.666%)' 'rgb(13.725%,72.941%,76.078%)' 'rgb(4.705%,63.137%,36.862%)' 'rgb(45.098%,46.274%,50.196%)' 'rgb(72.156%,9.019%,29.803%)' 'rgb(99.215%,49.019%,0%)' 'rgb(83.137%,9.803%,9.803%)' 'rgb(12.549%,65.882%,68.627%)' 'rgb(54.901%,25.882%,67.058%)' 'rgb(97.254%,87.058%,40.784%)')
color2_new=('rgb(0%,0%,0%)' 'rgb(16.862%,38.431%,75.294%)' 'rgb(40.784%,29.803%,20.784%)' 'rgb(12.549%,65.882%,68.627%)' 'rgb(4.313%,56.862%,33.333%)' 'rgb(29.803%,29.803%,29.803%)' 'rgb(57.647%,7.058%,23.921%)' 'rgb(69.803%,34.509%,0%)' 'rgb(79.215%,16.470%,16.470%)' 'rgb(6.666%,17.647%,36.078%)' 'rgb(38.431%,18.039%,47.058%)' 'rgb(100.000%,78.039%,18.823%)')


files=$(find -maxdepth 1 -iname "folder-*"  -printf "%f\n")


for i in $(seq 0 $[${#colors[*]}-1])
do
    for folder in $files
    do
        sed "s/${color1}/${color1_new[$i]}/g" <<< $(sed "s/${color2}/${color2_new[$i]}/g" < $folder) > folder-${colors[$i]}${folder##folder}
    done
    
    sed "s/${color1}/${color1_new[$i]}/g" <<< $(sed "s/${color2}/${color2_new[$i]}/g" < folder.svg) > folder-${colors[$i]}.svg
done
