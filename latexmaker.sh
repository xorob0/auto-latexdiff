#!/bin/bash

#
# Defining a few variables...
#
TEX_FILE="Latex1"
LATEXCMD="/usr/bin/latexdiff"
LATEXDOC_DIR="/home/xorob0/Documents/LaTeX"
TEX="$LATEXDOC_DIR/$TEX_FILE"
ORIGINAL="$LATEXDOC_DIR/.original"
TEX_DIFF="$LATEXDOC_DIR/diff"

while true
do

	#
	# If original does not exist create one
	#
	if ! [ -a $ORIGINAL.tex ]
	then
		cp $TEX.tex $ORIGINAL.tex
		md5sum $ORIGINAL.tex | awk '{print $1}' > $ORIGINAL.md5
	fi

	#
	# If diff pdf does not exist create it
	#
	if ! [ -a $TEX_DIFF.tex ]
	then
		cp $TEX.tex $TEX_DIFF.tex
		pdflatex $TEX_DIFF.tex
	fi

	#
	# If the current MD5 does not exist, create it
	#
	if ! [ -a $TEX.md5 ]
	then
		md5sum $TEX.tex | awk '{print $1}' > $TEX.md5
	fi

	#
	# Create and assignate md5 variables
	#
	OLD_MD5=$(cat $TEX.md5 | awk '{print $1}')
#	echo "$OLD_MD5"
	NEW_MD5=$(md5sum $TEX.tex | awk '{print $1}')
#	echo "$NEW_MD5"

	#
	# If the file has changed, change the md5 and create a new diff pdf
	#
	if ! [ $OLD_MD5 = $NEW_MD5 ]
	then
		echo $NEW_MD5 > $TEX.md5
		latexdiff $ORIGINAL.tex $TEX.tex > $TEX_DIFF.tex
		pdflatex $TEX_DIFF.tex
	fi
	sleep 1
done
