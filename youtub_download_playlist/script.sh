#!/bin/bash

# Advanced YouTube Playlist Downloader
# Supports video quality selection, audio-only downloads, and more options

set -e  # Exit on any error

# Default values
OUTPUT_DIR="./downloads"
QUALITY="720"
AUDIO_ONLY=false
SUBTITLE=false
START_INDEX=1
END_INDEX=""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_usage() {
    echo "Usage: $0 [OPTIONS] PLAYLIST_URL"
    echo ""
    echo "Options:"
    echo "  -o, --output DIR     Output directory (default: ./downloads)"
    echo "  -q, --quality NUM    Video quality: 144, 240, 360, 480, 720, 1080, 1440, 2160"
    echo "                       or 'best'/'worst' (default: 720)"
    echo "  -a, --audio-only     Download audio only (mp3 format)"
    echo "  -s, --subtitles      Download subtitles"
    echo "  --start NUM          Start from video number (default: 1)"
    echo "  --end NUM            End at video number"
    echo "  -h, --help           Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 \"https://www.youtube.com/playlist?list=PLxxxxxx\""
    echo "  $0 -q 1080 -s -o ~/Videos \"https://youtube.com/playlist?list=PLxxxxxx\""
    echo "  $0 --audio-only --start 5 --end 10 \"PLAYLIST_URL\""
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -o|--output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -q|--quality)
            QUALITY="$2"
            shift 2
            ;;
        -a|--audio-only)
            AUDIO_ONLY=true
            shift
            ;;
        -s|--subtitles)
            SUBTITLE=true
            shift
            ;;
        --start)
            START_INDEX="$2"
            shift 2
            ;;
        --end)
            END_INDEX="$2"
            shift 2
            ;;
        -h|--help)
            print_usage
            exit 0
            ;;
        -*)
            echo -e "${RED}Unknown option: $1${NC}"
            print_usage
            exit 1
            ;;
        *)
            PLAYLIST_URL="$1"
            shift
            ;;
    esac
done

# Check if playlist URL is provided
if [ -z "$PLAYLIST_URL" ]; then
    echo -e "${RED}Error: Playlist URL is required${NC}"
    print_usage
    exit 1
fi

# Check if yt-dlp is installed
if ! command -v yt-dlp &> /dev/null; then
    echo -e "${RED}Error: yt-dlp is not installed.${NC}"
    echo "Install it with:"
    echo "  pip install yt-dlp"
    echo "  or sudo apt install yt-dlp (Ubuntu/Debian)"
    echo "  or brew install yt-dlp (macOS)"
    exit 1
fi

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Build yt-dlp command
YT_DLP_CMD="yt-dlp"

# Output filename template
YT_DLP_CMD="$YT_DLP_CMD --output \"$OUTPUT_DIR/%(playlist_index)s - %(title)s.%(ext)s\""

# Format selection
if [ "$AUDIO_ONLY" = true ]; then
    YT_DLP_CMD="$YT_DLP_CMD --extract-audio --audio-format mp3 --audio-quality 0"
    echo -e "${BLUE}Mode: Audio-only download${NC}"
else
    if [ "$QUALITY" = "best" ] || [ "$QUALITY" = "worst" ]; then
        YT_DLP_CMD="$YT_DLP_CMD --format \"$QUALITY\""
    else
        YT_DLP_CMD="$YT_DLP_CMD --format \"best[height<=${QUALITY}]\""
    fi
    echo -e "${BLUE}Mode: Video download (${QUALITY}p)${NC}"
fi

# Playlist selection
if [ -n "$END_INDEX" ]; then
    YT_DLP_CMD="$YT_DLP_CMD --playlist-start $START_INDEX --playlist-end $END_INDEX"
    echo -e "${BLUE}Range: Videos $START_INDEX to $END_INDEX${NC}"
elif [ "$START_INDEX" != "1" ]; then
    YT_DLP_CMD="$YT_DLP_CMD --playlist-start $START_INDEX"
    echo -e "${BLUE}Range: From video $START_INDEX to end${NC}"
fi

# Additional options
YT_DLP_CMD="$YT_DLP_CMD --write-info-json --write-description --write-thumbnail"
YT_DLP_CMD="$YT_DLP_CMD --embed-chapters --embed-metadata"
YT_DLP_CMD="$YT_DLP_CMD --ignore-errors --no-overwrites"

# Subtitles
if [ "$SUBTITLE" = true ]; then
    YT_DLP_CMD="$YT_DLP_CMD --write-subs --write-auto-subs --sub-langs en"
    echo -e "${BLUE}Subtitles: Enabled${NC}"
fi

# Add playlist URL
YT_DLP_CMD="$YT_DLP_CMD \"$PLAYLIST_URL\""

echo -e "${GREEN}Starting download...${NC}"
echo -e "${BLUE}Output directory: $OUTPUT_DIR${NC}"
echo -e "${BLUE}Playlist URL: $PLAYLIST_URL${NC}"
echo ""

# Execute the command
eval $YT_DLP_CMD

echo ""
echo -e "${GREEN}Download completed!${NC}"
echo -e "${GREEN}Files saved to: $OUTPUT_DIR${NC}"

# Show summary
VIDEO_COUNT=$(find "$OUTPUT_DIR" -name "*.mp4" -o -name "*.mkv" -o -name "*.webm" -o -name "*.mp3" | wc -l)
echo -e "${YELLOW}Total files downloaded: $VIDEO_COUNT${NC}"



