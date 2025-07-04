# Private TrueNAS SCALE Catalog - Transcoder

This is a private TrueNAS SCALE catalog containing custom applications.

## Available Applications

### Transcoder
A container with FFmpeg, MKVToolNix, OCRmyPDF, Tesseract, and Subtitle Edit for media processing tasks.

**Features:**
- FFmpeg for video/audio transcoding
- MKVToolNix for Matroska file manipulation
- OCRmyPDF for adding OCR text layers to PDFs
- Tesseract OCR engine
- Subtitle Edit for subtitle manipulation
- Persistent storage support for configuration and media files

## Installation

1. In TrueNAS SCALE, navigate to **Apps** → **Manage Catalogs**
2. Click **Add Catalog**
3. Enter the following details:
   - **Catalog Name**: `Private Catalog` (or your preferred name)
   - **Repository**: `https://github.com/secretzer0/ixcharts`
   - **Preferred Trains**: `community`
   - **Branch**: `main` (or `master` depending on your default branch)
4. Click **Save**

## Usage

After adding the catalog:
1. Go to **Apps** → **Available Applications**
2. Find **Transcoder** in the list
3. Click **Install**
4. Configure storage paths as needed
5. Deploy the application

## Docker Image

The transcoder application uses a custom Docker image hosted at `registry.vyzon.ai/transcoder:1.0.0`.

## Requirements

- TrueNAS SCALE 23.10 or later
- Access to the private Docker registry (`registry.vyzon.ai`)

## Support

This is a private catalog. For issues or questions, please contact the repository maintainer.