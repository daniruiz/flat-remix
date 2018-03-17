#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

for i in {a..z}
do
    "$DIR"/_colorFixer.sh "${i}*" &
done
