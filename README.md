Converts with ffmpeg video files into different containers and extracts only the English audio and subtitles. The default container format is mkv.  
It requires jq and ffmpeg to be installed.

ALl converted files are saved in the `./converted\$extension` folder.

Usage:

```
$ videoconv.sh --help | -h

videoconv (17.12.2020)
Usage:
	videoconv [INFORMAT] [OUTFORMAT]
	OUTFORMAT: mkv, mp4, avi..	DEFAULT: mkv
	INFORMAT: mkv, mp4, avi..	DEFAULT: mkv
or
$ videoconv.sh
or
$ videoconv.sh avi mkv
```
