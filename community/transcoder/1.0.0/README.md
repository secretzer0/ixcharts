# Transcoder for TrueNAS SCALE

## Description

This chart deploys a comprehensive media transcoding and subtitle processing toolkit that includes:
- FFmpeg for video/audio transcoding
- MKVToolNix for Matroska file manipulation
- OCRmyPDF and Tesseract for OCR processing
- Subtitle Edit for subtitle editing

## Configuration

### Storage
- **Config Storage**: Stores application configuration (ixVolume or Host Path)
- **Media Storage**: Mount point for media files (defaults to `/mnt/media`)
- **Additional Storage**: Add as many additional mount points as needed

### User Configuration
- Configure the user and group ID the container runs as
- Default is 1000:1000

### Resources
- CPU Limit: Default 4000m (4 CPU cores)
- Memory Limit: Default 8Gi

## Usage Examples

After deployment, exec into the container:
```bash
kubectl exec -it deployment/transcoder-transcoder -- bash
```

### Video Transcoding
```bash
# Convert to H.264
ffmpeg -i /mnt/media/input.mp4 -c:v libx264 -preset slow -crf 22 /mnt/media/output.mp4

# Extract audio
ffmpeg -i /mnt/media/video.mp4 -vn -acodec copy /mnt/media/audio.aac
```

### MKV Operations
```bash
# Merge video with subtitles
mkvmerge -o /mnt/media/output.mkv /mnt/media/video.mp4 /mnt/media/subtitles.srt

# Extract subtitles
mkvextract tracks /mnt/media/input.mkv 3:/mnt/media/subtitles.srt
```

### OCR Processing
```bash
# Add OCR layer to PDF
ocrmypdf /mnt/media/scan.pdf /mnt/media/searchable.pdf

# With language specification
ocrmypdf -l eng+spa /mnt/media/input.pdf /mnt/media/output.pdf
```

### Subtitle Editing
```bash
# Run Subtitle Edit GUI (requires X11 forwarding)
mono /opt/subedit/SubtitleEdit.exe
```

## Notes

- The container runs with a simple sleep command to keep it alive
- All tools are available via command line
- Mount your media directories as needed through the TrueNAS UI
- For batch processing, consider creating scripts inside the config volume