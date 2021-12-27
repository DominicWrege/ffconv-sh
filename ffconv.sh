#!/usr/bin/env bash
set -e
set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o pipefail         # Use last non-zero exit code in a pipeline


# default extensions
out_extension="mkv"

function script_usage() {
	cat << EOF
ffconv (17.12.2020)

Converts a single video using FFmpeg into a different container and extracts only the English audio and subtitles.
The default container format is mkv.

Usage:
	ffconv.sh [INPUTFILE] [OUTFORMAT]   Converts a single file
	ffconv.sh -h | --help               Displays this help

Options:
	-h, --help	Show this screen

Arguments:
	INPUT_FILE	Input file
	OUTFORMAT	Output file format [default: mkv]

Examples:
	ffconv.sh movie.mkv mp4
EOF
}

function parse_params () {
    
    if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
        script_usage
        exit 0
    fi
    
    if [ -z "$1" ]; then
		echo "Please provide a input file"
		exit 1
	else
		input_file=$1
	fi
    
    if [ -n "$2" ]; then
        out_extension=$2
    fi
}

function check_cmd_exits() {
    local cmd
    cmds=(jq ffmpeg ffprobe)
    for c in ${cmds[@]}; do
        if ! type $c > /dev/null; then
            echo "COMMAND $c could not be found in your PATH or is not installed"
            exit 1
        fi
    done
    
}

function main() {
    parse_params "$@"
    check_cmd_exits
    files_exist
    convert
}

function files_exist() {
    if [ ! -f "$input_file" ]; then
        echo "file was not found: $input_file"
        exit 1
    fi
}

function join_by() { local IFS="$1"; shift; echo "$*"; }


function convert() {
    # create ourdir
    local output_file
    output_file="convert-${input_file%.*}.$out_extension"
    maps=("-map 0:0")
    
    echo converting: "\"$input_file\""
    ### extract eng lang ids
    langs=$(ffprobe -show_entries stream=index:stream_tags=language -print_format json -v quiet -i "$input_file" | jq -c '.streams[] | select(.tags.language == "eng" and .index != 0) | .index')
    if [ ${#langs[@]} -gt 0 ]; then
        echo found these 'en' indexes: $(join_by " " "${langs[@]}")
        for lang_i in $langs; do
            maps+=("-map 0:$lang_i")
        done
    else
        echo none 'en' lang id found, using id 1
        maps+=("-map 0:1")
    fi
    
    lang_opt=$(join_by " " "${maps[@]}")
    eval ffmpeg -nostdin -i "\"$input_file\"" "$lang_opt" -vcodec copy -acodec copy -stats -v fatal "\"$output_file\""
}


main "$@"
exit 0
