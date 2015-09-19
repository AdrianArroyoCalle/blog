#!/bin/bash

# With Poptimize only 12min

if [ "$2" = "1"  ]; then
	BASENAME="${1%.png}"
	optipng -o7 "${BASENAME}.png"
else
	find  . -name "*.png" | parallel ./poptimize.sh "{}" 1
fi
