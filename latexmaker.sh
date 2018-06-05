#!/bin/bash

#
# Defining a few variables...
#
FILENAME=$1
DIRECTORY=`pwd`
LATEXDIFFCMD="/usr/bin/latexdiff"
LATEXCMD="/usr/bin/xelatex -interaction nonstopmode"
FILE="$DIRECTORY/$FILENAME"
ORIGINAL="/tmp/Latex_Diff/original.tex"
DIFF="/tmp/Latex_Diff/diff.tex"
TIME=1

mkdir -p /tmp/Latex_Diff/
cp $FILE $ORIGINAL

while true
do

	#
	# If the file has changed, change the md5 and create a new diff pdf
	#
	CHECKNOW=`md5sum $FILE`

	if ! [[ $CHECK = $CHECKNOW ]]
	then
		CHECK=$CHECKNOW

		$LATEXDIFFCMD $ORIGINAL $FILE > $DIFF
		$LATEXCMD $DIFF --output-directory $DIRECTORY
	fi
	sleep $TIME
done
