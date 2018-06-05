#!/bin/bash

# Files variables
FILENAME=$1
DIRECTORY=`pwd`
FILE="$DIRECTORY/$FILENAME"

# Executables
LATEXCMD="/usr/bin/xelatex -interaction nonstopmode"

# Time between refresh
TIME=1

# Infinite loop
while :
do

	CHECKNOW=`md5sum $FILE`

	# If the file has changed, change the md5 and create a new diff pdf
	if ! [[ $CHECK = $CHECKNOW ]]
	then
		CHECK=$CHECKNOW

		$LATEXCMD $FILE --output-directory $DIRECTORY
	fi

	sleep $TIME

	# Exit on CTRL-C
	test $? -gt 128
done
