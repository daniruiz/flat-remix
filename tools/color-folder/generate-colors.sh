#!/bin/bash
TEMPLATES_DIR=places

color1='#123'
color2='#456'
color3='#fff'
colors=(     black     blue      brown     cyan      green     grey      magenta   orange    red       teal      violet    yellow  )
color1_new=('#383c4a' '#367bf0' '#aa7a50' '#23bac2' '#17917a' '#737680' '#b8174c' '#fd7d00' '#d41919' '#20a8af' '#8c42ab' '#ffd86e')
color2_new=('#191919' '#2b62c0' '#775e49' '#20a8af' '#12715f' '#4c4c4c' '#93123d' '#b25800' '#b22525' '#198388' '#622e78' '#ffc730')
color3_new=('#ffffff' '#ffffff' '#ffffff' '#ffffff' '#ffffff' '#ffffff' '#ffffff' '#ffffff' '#ffffff' '#ffffff' '#ffffff' '#000000')


# ******************************
# * GENERATE ALL COLORS
# ******************************
for i in $(seq 0 $[${#colors[*]}-1])
do
  color=${colors[$i]}
  dir=$TEMPLATES_DIR-$color
  rm -rf $dir
  mkdir $dir
  cp $TEMPLATES_DIR/* $TEMPLATES_DIR-$color/
  echo -e " [\e[32m+\e[0m] $color"
  sed -i "s/${color1}/${color1_new[$i]}/g;
          s/${color2}/${color2_new[$i]}/g;
          s/${color3}/${color3_new[$i]}/g;" $dir/TEMPLATE_*
  (cd $dir \
    && find * -name 'TEMPLATE_*' -exec sh -c 'mv $1 ${1#TEMPLATE_}' _ {} \;)
done



# ******************************
# * MERGE FOLDER-* VARIANTS
# ******************************
folder_files=$(echo $TEMPLATES_DIR-*/folder*)
for color in ${colors[@]}
do
  dir=$TEMPLATES_DIR-$color

  desktop_icon=$dir/user-$color-desktop.svg
  [ -f $desktop_icon ] \
    && cp -v $desktop_icon $dir/folder-desktop.svg

  for file in $folder_files
  do
    file_color=$(dirname $file | sed 's/places-//')
    new_file_name=folder-$file_color$(basename $file | sed 's/folder//')
    cp $file $dir/$new_file_name
  done &
done
wait
