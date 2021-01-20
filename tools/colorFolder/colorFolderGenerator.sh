#!/bin/bash

GENERATED_DIR=color-generated-places
TEMPLATES_DIR=places
mkdir -p $GENERATED_DIR


color1='#123'
color2='#456'
color3='#fff'
colors=(     black     blue      brown     cyan      green     grey      magenta   orange    red       teal      violet    yellow  )
color1_new=('#383c4a' '#367bf0' '#aa7a50' '#23bac2' '#17917a' '#737680' '#b8174c' '#fd7d00' '#d41919' '#20a8af' '#8c42ab' '#ffd86e')
color2_new=('#191919' '#2b62c0' '#775e49' '#20a8af' '#12715f' '#4c4c4c' '#93123d' '#b25800' '#b22525' '#198388' '#622e78' '#ffc730')
color3_new=('#ffffff' '#ffffff' '#ffffff' '#ffffff' '#ffffff' '#ffffff' '#ffffff' '#ffffff' '#ffffff' '#ffffff' '#ffffff' '#000000')

for i in $(seq 0 $[${#colors[*]}-1])
do
  find $TEMPLATES_DIR -name "folder*" -printf "%f\n" | while read file
  do
    echo -e " [\e[32m+\e[0m] ${file}"
    sed "s/${color1}/${color1_new[$i]}/g;
         s/${color2}/${color2_new[$i]}/g;
         s/${color3}/${color3_new[$i]}/g;" $TEMPLATES_DIR/$file > $GENERATED_DIR/folder-${colors[$i]}${file##folder}
  done
done
