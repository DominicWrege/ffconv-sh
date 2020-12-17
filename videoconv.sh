#!/bin/bash
set -e
set -o errexit          # Exit on most errors (see the manual)
set -o errtrace         # Make sure any error trap is inherited
set -o pipefail         # Use last non-zero exit code in a pipeline


function script_usage() {
    cat << EOF
videoconv (17.12.2020)
Usage:
	videoconv [INFORMAT] [OUTFORMAT] 
	OUTFORMAT: mkv, mp4, avi..	DEFAULT: mkv
	INFORMAT: mkv, mp4, avi..	DEFAULT: mkv
EOF
}


# default extensions
in_extension="mkv"
out_extension="mkv"

function parse_params() {
    	local param
	param="$1"
	
	if [ "${param[0]}" = "-h" ] || [ "${param[0]}" = "--help" ]; then
		script_usage
		exit 0
	fi

	if [ -n "${param[0]}" ]; then
    		in_extension=$1
 	fi

 	if [ -n "${param[1]}" ]; then
    		out_extension=$2
	fi
}



function check_cmd_exits {
	local cmd
	cmds=(jq ffmpeg ffprobe)
	for c in ${cmds[@]}; do
		if ! type $c > /dev/null; then
    			echo "COMMAND $c could not be found in PATH or is not installed"
    			exit 1
		fi
	done

}

function main {
	parse_params "$@"	
	check_cmd_exits
	convert
}


function join_by { local IFS="$1"; shift; echo "$*"; }


function convert {
	# create ourdir
	mkdir -p converted$outextension

	IFS=$'\n'
	for item in *."$in_extension"; do
		item=${item#./}
		maps=("-map 0:0")
		echo item: $item
		### extract eng lang ids
		langs=$(ffprobe -show_streams -show_entries stream_tags=language -of json -v error -i "$item" | jq -c '.streams[] | select(.tags.language == "eng" and .index != 0) | .index')
		
		for lang_i in $langs; do
  			maps+=("-map 0:$lang_i")
		done

		echo found this index: $langs
		lang_opt=$(join_by " " "${maps[@]}")	
		### extract eng lang ids

		eval ffmpeg -i "$item" $lang_opt -vcodec copy -acodec copy converted$out_extension/"${item%.*}.$out_extension"
	done
}


main "$@"
exit 0
