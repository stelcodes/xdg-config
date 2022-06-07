To add a subtitle file to a video file:
```
ffmpeg -i <video> -i <subs> -c copy <outfile>
```
Extract first subtitle track:
```
ffmpeg -i <video> -map 0:s:0 some-subs.srt
```
