Converts wihout encoding the video files from the current directory with ffmpeg into different containers and extracts only the English audio and subtitles. The default container format is mkv.  
It requires jq and ffmpeg to be installed.
All converted files are saved to the `./converted$outformat` folder.

Usage:

```
$ videoconv.sh --help | -h
Usage:
	videoconv.sh [INFORMAT] [OUTFORMAT]     Converts files from current dir
	videoconv.sh -h | --help            	Displays this help

Options:
	-h, --help	Show this screen.

Arguments:
	INFORMAT	Input file format [default: mkv]
	OUTFORMAT	Output file format [default: mkv]

Examples:
	videoconv.sh avi
	videoconv.sh avi mp4
```

Do not forget to make the file executable.
