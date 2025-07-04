# Private Catalog for TrueNAS SCALE 23.10

This is a TrueNAS SCALE catalog repository containing custom applications.

## Available Applications

### Transcoder
A comprehensive media transcoding and subtitle processing toolkit that includes:
- FFmpeg for video/audio transcoding
- MKVToolNix for Matroska file manipulation
- OCRmyPDF and Tesseract for OCR processing
- Subtitle Edit for subtitle editing

## Installation

### 1. Build and Push Docker Image

First, build and push your Docker image to a registry accessible by TrueNAS:

```bash
cd /home/tmelhiser/transcoder
docker build -t your-registry/transcoder:latest .
docker push your-registry/transcoder:latest
```

### 2. Add the Catalog to TrueNAS

1. In TrueNAS SCALE, navigate to **Apps** → **Manage Catalogs**
2. Click **Add Catalog**
3. Enter the following details:
   - **Name**: `secretzer0` (or your preferred name)
   - **Repository**: `https://github.com/secretzer0/ixcharts`
   - **Branch**: `main`
   - **Preferred Trains**: `community`
4. Click **Save**

### 3. Deploy the Application

1. Navigate to **Apps** → **Available Applications**
2. Find **Transcoder** in the list
3. Click **Install**
4. Configure the following:
   - **Image Repository**: Update to your Docker registry path (e.g., `your-registry/transcoder`)
   - **User/Group ID**: Set appropriate permissions
   - **Storage**: Configure media path and any additional storage
   - **Resources**: Adjust CPU/Memory limits as needed
5. Click **Save** to deploy

## Usage

Once deployed, you can access the container to run various media processing commands:

```bash
# Access the container
kubectl exec -it deployment/transcoder-transcoder -- bash

# Example commands:
ffmpeg -i input.mp4 -c:v libx264 output.mp4  # Video transcoding
mkvmerge -o output.mkv input.mp4 subtitles.srt  # Merge video with subtitles
ocrmypdf input.pdf output.pdf  # Add OCR layer to PDF
mono /opt/subedit/SubtitleEdit.exe  # Run Subtitle Edit
```

## Directory Structure

```
ixcharts/
├── catalog.json
├── README.md
└── community/
    └── transcoder/
        ├── item.yaml
        ├── app_versions.json
        └── 1.0.0/
            ├── Chart.yaml
            ├── app-readme.md
            ├── ix_values.yaml
            ├── metadata.yaml
            ├── questions.yaml
            └── templates/
                ├── common.yaml
                └── _transcoder.tpl
```
