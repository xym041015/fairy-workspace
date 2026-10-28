set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts" </dev/null
GPT-SoVITS/.venv/bin/yt-dlp --no-warnings -f "bestaudio" -x --audio-format wav -o "fairy_src.%(ext)s" "https://www.bilibili.com/video/BV1KQa3eSE4V/" 2>&1 | tail -4
ls -l fairy_src.wav 2>/dev/null | awk '{printf "size %d bytes\n", $5}'
ffprobe -v error -show_entries format=duration -of default=nw=1 fairy_src.wav
echo "=== 静音分布（判断是否有背景音乐/句子边界）==="
ffmpeg -v info -i fairy_src.wav -af silencedetect=noise=-30dB:d=0.35 -f null - 2>&1 | grep -E "silence_(start|end)" | head -20