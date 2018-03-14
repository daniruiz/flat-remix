#!/bin/bash

colors=(black blue brown cyan green grey magenta orange red teal violet yellow)


color1='rgb(21.176471%,48.235294%,94.117647%)'
color2='rgb(14.117647%,36.470588%,76.862745%)'

color1_new=('#404347' '#367BF0' '#cc9c6b' '#23bac2' '#0ca15e' '#a6a6a6' '#b8174c' '#fd7d00' '#D41A1A' '#19ba9c' '#8c42ab' '#f8de68')


color2_new=('#000000' '#245DC4' '#684c35' '#1fa7ae' '#0b9154' '#8a8a8a' '#94123c' '#b25800' '#bf3828' '#213554' '#69357f' '#ffc730')


files=$(find -maxdepth 1 -iname "folder-*"  -printf "%f\n")


for i in $(seq 0 $[${#colors[*]}-1])
do
for folder in $files
    do

        sed "s/${color1}/${color1_new[$i]}/g" <<< $(sed "s/${color2}/${color2_new[$i]}/g" < $folder) > folder-${colors[$i]}${folder##folder}
    done
done
