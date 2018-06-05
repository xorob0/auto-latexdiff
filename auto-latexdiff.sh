#!/bin/sh
#
# This script compiles your LaTeX file as you are typing and creates a
# differential PDF.
#
# NOTE: it can be used to easily spot what you changed in your file.

# Main variables.
DIFF_MODE=1
DIRECTORY=$(pwd)
FILENAME=
REFRESH=1

# Temporary files.
TMP_DIRECTORY="/tmp/auto-latexdiff"
DIFF_FILE="$TMP_DIRECTORY/diff.tex"
ORIGINAL_FILE="$TMP_DIRECTORY/original.tex"

# Executables.
LATEX_CMD="/usr/bin/xelatex -interaction nonstopmode"
LATEXDIFF_CMD="/usr/bin/latexdiff"

# Checks if the LaTeX file changed. If so, then it updates the MD5 and creates
# a new differential PDF.
compile() {
    while :; do
		CHECKNOW=$(md5sum "$DIRECTORY/$FILENAME")

		if ! [ "$CHECK" = "$CHECKNOW" ]; then
			CHECK=$CHECKNOW

			if [ "$DIFF_MODE" = "1" ]; then
				$LATEXDIFF_CMD $ORIGINAL_FILE $FILENAME > $DIFF_FILE
			fi
			$LATEX_CMD $FILENAME --output-directory "$DIRECTORY"
		fi

		sleep $REFRESH

		# Exit on CTRL-C
		test $? -gt 128
	done
}

# Kills the program.
die() {
    printf '%s\n' "$1" >&2
    exit 1
}

# Generates temporary directory.
gen_tmp() {
	mkdir -p $TMP_DIRECTORY
	cp $FILENAME $ORIGINAL_FILE
}

# Deletes temporary directory on exit.
printout() {
	rm -rf $TMP_DIRECTORY
	exit 1
}

# Usage info.
show_help() {
cat << EOF
Usage: ${0##*/} [-h] [-d OUTFILE] [DIR] [-f OUTFILE] [FILE] [-r INTEGER] [REFESH]...
Compiles your LaTeX file as you are typing and creates a differential PDF.

    -d OUTFILE  specify the output directory (default to current)
    -f OUTFILE  specify the output file
    -h          display this help and exit
    -r INTEGER  specify the refresh time
    -t OUTFILE  specify the output temporary file
    -w          compile without differential indications
EOF
}

while :; do
    case $1 in
        -h|-\?|--help)
            show_help
            exit
            ;;
		-d|--dir)
            if [ "$2" ]; then
                DIRECTORY=$2
                shift
            else
                die 'ERROR: "--dir" requires a non-empty option argument.'
            fi
            ;;
		--dir=?*)
            DIRECTORY=${1#*=}
            ;;
        --dir=)
            die 'ERROR: "--dir" requires a non-empty option argument.'
            ;;
        -f|--file)
            if [ "$2" ]; then
                FILENAME=$2
                shift
            else
                die 'ERROR: "--file" requires a non-empty option argument.'
            fi
            ;;
        --file=?*)
            FILENAME=${1#*=}
            ;;
        --file=)
            die 'ERROR: "--file" requires a non-empty option argument.'
            ;;
		-r|--refresh)
            if [ "$2" ]; then
				case "$2" in
					'' | *[!0-9]*)
						echo "$0: $REFRESH: invalid digit" >&2; exit 1;;
				esac
                REFRESH=$2
                shift
            else
                die 'ERROR: "--refresh" requires a non-empty option argument.'
            fi
            ;;
        --refresh=?*)
            REFRESH=${1#*=}
            ;;
        --refresh=)
            die 'ERROR: "--refresh" requires a non-empty option argument.'
            ;;
		-w|--without-diff)
            DIFF_MODE=0
			shift
            ;;
        --)
            shift
            break
            ;;
        -?*)
            printf 'WARN: Unknown option (ignored): %s\n' "$1" >&2
            ;;
        *)
            break
    esac

    shift
done

if [ "$FILENAME" ] && [ "$DIRECTORY" ]; then
	gen_tmp
	trap printout INT
	compile
fi
