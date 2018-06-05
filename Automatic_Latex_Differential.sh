#!/bin/bash

# Files variables
FILENAME=$1
DIRECTORY=`pwd`
FILE="$DIRECTORY/$FILENAME"

TMPDIRECTORY='/tmp/Latex_Diff'
ORIGINAL="$TMPDIRECTORY/original.tex"
DIFF="$TMPDIRECTORY/diff.tex"

# Executables
LATEXDIFFCMD="/usr/bin/latexdiff"
LATEXCMD="/usr/bin/xelatex -interaction nonstopmode"

# Time between refresh
TIME=1

# Generating temporary directory
mkdir -p $TMPDIRECTORY
cp $FILE $ORIGINAL

# Deleting temporary directory on exit
trap printout SIGINT
printout() {
	rm -Rf $TMPDIRECTORY
	exit
}

# Infinite loop
while :
do

	CHECKNOW=`md5sum $FILE`

	# If the file has changed, change the md5 and create a new diff pdf
	if ! [[ $CHECK = $CHECKNOW ]]
	then
		CHECK=$CHECKNOW

		$LATEXDIFFCMD $ORIGINAL $FILE > $DIFF
		$LATEXCMD $DIFF --output-directory $DIRECTORY
	fi

	sleep $TIME

	# Exit on CTRL-C
	test $? -gt 128
done
