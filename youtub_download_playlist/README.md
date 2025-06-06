# YouTube Playlist Downloader

A powerful bash script to download entire YouTube playlists with customizable options for quality, format, and range selection.

## Features

- 📹 Download entire playlists or specific video ranges
- 🎵 Audio-only downloads (MP3 format)
- 📱 Multiple quality options (144p to 4K)
- 📝 Automatic subtitle downloads
- 📊 Metadata preservation (thumbnails, descriptions, video info)
- 🔄 Resume interrupted downloads
- ⚡ Parallel processing support

## Prerequisites

- **yt-dlp** - The core download engine
- **bash** - Script interpreter (available on Linux/macOS/WSL)

## Installation

1. **Install yt-dlp:**

   ```bash
   # Using pip
   pip install yt-dlp

   # Ubuntu/Debian
   sudo apt install yt-dlp

   # macOS with Homebrew
   brew install yt-dlp
   ```

2. **Download and setup the script:**
   ```bash
   chmod +x download_playlist.sh
   ```

## Usage

### Basic Usage

```bash
./download_playlist.sh "https://www.youtube.com/playlist?list=PLxxxxxx"
```

### Advanced Usage

```bash
# High quality with subtitles
./download_playlist.sh -q 1080 -s -o ~/Videos "PLAYLIST_URL"

# Audio-only download
./download_playlist.sh --audio-only "PLAYLIST_URL"

# Download specific range (videos 5-10)
./download_playlist.sh --start 5 --end 10 "PLAYLIST_URL"
```

## Options

| Option              | Description                                               | Default       |
| ------------------- | --------------------------------------------------------- | ------------- |
| `-o, --output DIR`  | Output directory                                          | `./downloads` |
| `-q, --quality NUM` | Video quality (144, 240, 360, 480, 720, 1080, 1440, 2160) | `720`         |
| `-a, --audio-only`  | Download audio only (MP3 format)                          | `false`       |
| `-s, --subtitles`   | Download subtitles                                        | `false`       |
| `--start NUM`       | Start from video number                                   | `1`           |
| `--end NUM`         | End at video number                                       | `all`         |
| `-h, --help`        | Show help message                                         | -             |

## Examples

```bash
# Download playlist in 720p to default folder
./download_playlist.sh "https://youtube.com/playlist?list=PLxxxxxx"

# Download in 4K with subtitles to custom folder
./download_playlist.sh -q 2160 -s -o ~/Documents/Videos "PLAYLIST_URL"

# Download only audio from videos 10-20
./download_playlist.sh --audio-only --start 10 --end 20 "PLAYLIST_URL"

# Download the best quality available
./download_playlist.sh -q best "PLAYLIST_URL"
```

## Output Structure

Downloaded files are organized as:

```
downloads/
├── 001 - Video Title.mp4
├── 001 - Video Title.info.json
├── 001 - Video Title.description
├── 001 - Video Title.jpg
├── 002 - Another Video.mp4
└── ...
```

## Troubleshooting

**Script fails with "command not found":**

- Ensure yt-dlp is installed and in your PATH
- Try reinstalling: `pip install --upgrade yt-dlp`

**Downloads are slow:**

- YouTube may throttle downloads; this is normal
- Consider downloading during off-peak hours

**Some videos fail to download:**

- The script continues with other videos
- Check if videos are private, deleted, or geo-restricted

## Notes

- The script automatically skips already downloaded files
- Metadata files (.info.json, .description, thumbnails) are saved alongside videos
- Large playlists may take significant time and disk space
- Keep yt-dlp updated for best compatibility

## License

This script is provided as-is for educational and personal use. Respect YouTube's Terms of Service and copyright laws.
