# Transcoder

Transcoder is a container with FFmpeg, MKVToolNix, OCRmyPDF, Tesseract, and Subtitle Edit for media processing.

> When application is installed, a container will be launched with **root** privileges.
> This is required in order to apply the correct permissions to the `Transcoder` directories.
> Afterward, the `Transcoder` container will run as a **non**-root user (Default: `568`).
> All mounted storage(s) will be `chown`ed only if the parent directory does not match the configured user.
