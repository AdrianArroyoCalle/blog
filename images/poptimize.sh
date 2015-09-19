#!/bin/bash

# With Poptimize only 12min

if [ "$2" = "1"  ]; then
	BASENAME="${1%.png}"
	optipng -o7 "${BASENAME}.png"
elif [ "$2" = "2"  ]; then
	BASENAME="${1%.jpg}"
	jpegoptim "${BASENAME}.jpg"
else 
	find  . -name "*.png" | parallel ./poptimize.sh "{}" 1
	find  . -name "*.jpg" | parallel ./poptimize.sh "{}" 2
fi
