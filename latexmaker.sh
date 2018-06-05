#!/bin/bash

# Defining a few variables...

FILENAME=$1
DIRECTORY=`pwd`
FILE="$DIRECTORY/$FILENAME"
TMPDIRECTORY='/tmp/Latex_Diff'

ORIGINAL="$TMPDIRECTORY/original.tex"
DIFF="$TMPDIRECTORY/diff.tex"

LATEXDIFFCMD="/usr/bin/latexdiff"
LATEXCMD="/usr/bin/xelatex -interaction nonstopmode"

TIME=1

mkdir -p $TMPDIRECTORY
cp $FILE $ORIGINAL

while true
do

	# If the file has changed, change the md5 and create a new diff pdf

	CHECKNOW=`md5sum $FILE`

	if ! [[ $CHECK = $CHECKNOW ]]
	then
		CHECK=$CHECKNOW

		$LATEXDIFFCMD $ORIGINAL $FILE > $DIFF
		$LATEXCMD $DIFF --output-directory $DIRECTORY
	fi
	sleep $TIME
	test $? -gt 128 && break
done

rm -rf $TMPDIRECTORY
