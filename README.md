Converts video files from the current directory with ffmpeg into different containers and extracts only the English audio and subtitles. The default container format is mkv.  
It requires jq and ffmpeg to be installed.
Al converted files are saved in the `./converted\$outformat` folder.

Usage:

```
$ videoconv.sh --help | -h
Usage:
	videoconv.sh [INFORMAT] [OUTFORMAT]		Converts files from currentdirectory
	videoconv.sh -h | --help				Displays this help

Options:
	-h, --help	Show this screen.

Arguments:
	INFORMAT	Input file format [default: mkv]
	OUTFORMAT	Output file format [default: mkv]

Examples:
	videoconv.sh avi
	videoconv.sh avi mp4
or
$ videoconv.sh
or
$ videoconv.sh avi mkv
```

Do not forget to make the file executable.
