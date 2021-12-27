#!/usr/bin/env bash
set -e
set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o pipefail         # Use last non-zero exit code in a pipeline


# default extensions
in_extension="mkv"
out_extension="mkv"

function script_usage() {
	cat << EOF
videoconvs (26.12.2021)

Converts video files from the current directory using FFmpeg into different containers and extracts only the English audio and subtitles.
The default container format is mkv.
All converted files are saved to the "./converted\$outformat" folder.

Usage:
	videoconvs.sh [INFORMAT] [OUTFORMAT]	Converts files from current dir
	videoconvs.sh -h | --help		Displays this help

Options:
	-h, --help	Show this screen

Arguments:
	INFORMAT	Input file format [default: mkv]
	OUTFORMAT	Output file format [default: mkv]

Examples:
	videoconvs.sh avi
	videoconvs.sh avi mp4
EOF
}

function parse_params () {
	
	if [ "$1" = "-h" ] || [ "$1" = "--help" ]; then
		script_usage
		exit 0
	fi

	if [ -n "$1" ]; then
		in_extension=$1
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
			echo "COMMAND $c could not be found in PATH or is not installed"
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
	files=$(find . -maxdepth 1 -type f -name "*.$in_extension" -print -quit)
	if [[ -z $files ]];
	then
		echo "files not found: *.$in_extension"
		exit 1
	fi
}

function join_by() { local IFS="$1"; shift; echo "$*"; }


function convert() {
	# create ourdir
	local out_dir
	out_dir="./converted$out_extension"
	mkdir -p $out_dir
	IFS=$'\n'
	for item in *."$in_extension"; do
		item=${item#./}
		maps=("-map 0:0")

		### extract eng lang ids
		langs=$(ffprobe -show_entries stream=index:stream_tags=language -print_format json -v quiet -i "$item" | jq -c '.streams[] | select(.tags.language == "eng" and .index != 0) | .index')
		echo converting: "\"$item\""

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
		eval ffmpeg -nostdin -i "\"$item\"" "$lang_opt" -vcodec copy -acodec copy -stats -v fatal "\"$out_dir/${item%.*}.$out_extension\""
	done
}


main "$@"
exit 0