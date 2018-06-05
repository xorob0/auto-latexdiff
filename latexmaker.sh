#!/bin/bash

#
# Defining a few variables...
#
FILENAME=$1
DIRECTORY=`pwd`
LATEXCMD="/usr/bin/latexdiff"
FILE="$DIRECTORY/$FILENAME"
ORIGINAL="$DIRECTORY/.original"
TEX_DIFF="$DIRECTORY/diff"
EXT="tex"

while true
do

	#
	# If original does not exist create one
	#
	if ! [ -a $ORIGINAL.$EXT ]
	then
		cp $FILE.$EXT $ORIGINAL.$EXT
		md5sum $ORIGINAL.$EXT | awk '{print $1}' > $ORIGINAL.md5
	fi

	#
	# If diff pdf does not exist create it
	#
	if ! [ -a $TEX_DIFF.$EXT ]
	then
		cp $FILE.$EXT $TEX_DIFF.$EXT
		pdflatex $TEX_DIFF.$EXT
	fi

	#
	# If the current MD5 does not exist, create it
	#
	if ! [ -a $FILE.md5 ]
	then
		md5sum $FILE.$EXT | awk '{print $1}' > $FILE.md5
	fi

	#
	# Create and assignate md5 variables
	#
	OLD_MD5=$(cat $FILE.md5 | awk '{print $1}')
#	echo "$OLD_MD5"
	NEW_MD5=$(md5sum $FILE.$EXT | awk '{print $1}')
#	echo "$NEW_MD5"

	#
	# If the file has changed, change the md5 and create a new diff pdf
	#
	if ! [ $OLD_MD5 = $NEW_MD5 ]
	then
		echo $NEW_MD5 > $FILE.md5
		latexdiff $ORIGINAL.$EXT $FILE.$EXT > $TEX_DIFF.$EXT
		pdflatex $TEX_DIFF.$EXT
		pdflatex $FILE.$EXT
	fi
	sleep 1
done
