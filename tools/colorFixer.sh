#!/bin/bash

USAGE="$(basename "$0") [OPTION]... [FILE]
    Replace all colors found in input file with the closest from
    specified palette. Supports HEX RGB and RGBA colors.

    Options:
      -p FILE, --palette FILE \t read palette colors from FILE
      -x, --hex               \t use hex colors as replacement
      -v, --verbose           \t print color modifications
      -c, --color             \t colorize the output
      -h, --help              \t show this help text"



FILES=()
PALETTE_FILE=''
while [[ $# -gt 0 ]]
do
	key="$1"

	case $key in
		-p|--palette)
			PALETTE_FILE="$2"
			shift # past argument
			shift # past value
			;;
		-x|--hex)
			HEX=1
			shift # past argument
			;;
		-v|--verbose)
			VERBOSE=1
			shift # past argument
			;;
		-c|--color)
			COLOR=1
			shift # past argument
			;;
		-h|--help)
			echo -e "$USAGE"
			exit 0
			;;
		*)    # files
			FILES+=("$1")
			shift # past argument
			;;
	esac
done

if [[ ${FILES[@]} == '' || $PALETTE_FILE == '' ]]
then
	echo -e "$USAGE"
	exit 0
fi



function parse_color {
	color="$1"
	if [[ ${color:0:1} = "#" ]]
	then
		if [[ $(wc -c <<< $color) = 5 ]]
		then
			color="#${color:1:1}${color:1:1}${color:2:1}${color:2:1}${color:3:1}${color:3:1}"
		fi
		echo "$((0x${color:1:2})) $((0x${color:3:2})) $((0x${color:5:2}))"
	elif [[ ${color:0:3} = "rgb" ]]
	then
		colors=($(grep -o -P "\d+(\.\d+)?" <<< $color))
		if [[ $(grep -o "%" <<< $color | wc -l) > 0 ]]
		then
			printf "%s %s %s" \
					$(echo "${colors[0]} * 255/100" | bc) \
					$(echo "${colors[1]} * 255/100" | bc) \
					$(echo "${colors[2]} * 255/100" | bc)
		else
			echo "${colors[0]} ${colors[1]} ${colors[2]}"
		fi
	fi
}

palette_colors=$(for color in $(cat "$PALETTE_FILE")
do
	echo $(parse_color $color)
done)

function find_nearest_color {
	r1=$1; g1=$2; b1=$3
	color1=($r $g $b)
	smallest_distance=765

	while read -r palette_color
	do
		color2=($palette_color)
		r2=${color2[0]}; g2=${color2[1]}; b2=${color2[2]}

		if [[ ${color1[@]} == ${color2[@]} ]]
		then
			best_color=$palette_color
			break
		fi

		distance=$(echo "scale=3;sqrt(2*($r2-$r1)^2 + 4*($g2-$g1)^2 + 3*($b2-$b1)^2)" | bc)
		if (( $(echo "$distance < $smallest_distance" | bc) ))
		then
			smallest_distance=$distance
			best_color=$palette_color
		fi
	done <<< $palette_colors
	echo $best_color
}

colors_regex='#([\da-f]{3}){1,2}(?![\d\w])|rgb(a)?\(\s*\d{1,3}(\.\d+)?%?(\s*,\s*\d{1,3}(\.\d+)?%?){2}(\s*,\s*(1|\d?\.\d+))?\s*\)'
for file in ${FILES[@]}
do
	printf "\n  $file\n"
	(( $VERBOSE )) && printf '%*s\n\n' "${COLUMNS:-$(tput cols)}" '' | tr ' ' '_'

	file_colors=$(grep -o -P -i $colors_regex "$file" | sort -u)
	[[ $file_colors = '' ]] && continue
	while read -r file_color
	do
		parsed_color=($(parse_color "$file_color"))
		new_color=($(find_nearest_color ${parsed_color[@]}))
		if [[ ${file_color:0:4} == 'rgba' ]]
		then
			alpha=$(grep -o -P "\d*(\.\d+)?" <<< $file_color | tail -1)
			new_color_formated="rgba(${new_color[0]}, ${new_color[1]}, ${new_color[2]}, $alpha)"
		elif (( HEX ))
		then
			new_color_formated=$(printf '#%02x%02x%02x' \
					${new_color[0]} ${new_color[1]} ${new_color[2]})
		else
			new_color_formated="rgb(${new_color[0]}, ${new_color[1]}, ${new_color[2]})"
		fi

		sed "s/$file_color/$new_color_formated/g" -i "$file"

		if (( $VERBOSE ))
		then
			printf "    %s%-24s %s => %s %24s%s\n" \
					$((( $COLOR )) && printf "\x1b[38;2;${parsed_color[0]};${parsed_color[1]};${parsed_color[2]}m" || printf '') \
					"$file_color" \
					$((( $COLOR )) && printf "\x1b[48;2;${parsed_color[0]};${parsed_color[1]};${parsed_color[2]}m..\x1b[0m" || printf '') \
					$((( $COLOR )) && printf "\x1b[38;2;${new_color[0]};${new_color[1]};${new_color[2]}m\x1b[48;2;${new_color[0]};${new_color[1]};${new_color[2]}m..\x1b[0m\x1b[38;2;${new_color[0]};${new_color[1]};${new_color[2]}m" || printf '') \
					"$new_color_formated" \
					$((( $COLOR )) && printf "\x1b[0m" || printf '')
		fi
	done <<< $file_colors
done
