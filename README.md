# videosconv
Converts wihout encoding the video files from the current directory with ffmpeg into different containers and extracts only the English audio and subtitles. The default container format is mkv.  
It requires jq and ffmpeg to be installed.
All converted files are saved to the `./converted$outformat` folder.

Usage:

```
$ videosconv.sh --help | -h
Usage:
	videosconv.sh [INFORMAT] [OUTFORMAT]     Converts files from current dir
	videosconv.sh -h | --help            	 Displays this help

Options:
	-h, --help	Show this screen.

Arguments:
	INFORMAT	Input file format [default: mkv]
	OUTFORMAT	Output file format [default: mkv]

Examples:
	videosconv.sh avi
	videosconv.sh avi mp4
```

# ffconv

If you wanne just convert a single file.
Output is `convert-$filename`
```
dominic@wallstreet /tmp> ffconv.sh --help
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
```
