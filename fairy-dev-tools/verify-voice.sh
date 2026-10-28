set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
URL=$(grep -o "http://127.0.0.1:5599/?token=[A-Za-z0-9_-]*" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mirror/boot.log" | tail -1)
TOKEN=$(echo "$URL" | sed 's/.*token=//')
echo "=== status (with token) ==="
curl -s -m 20 -H "Cookie: dsh-token=$TOKEN" "http://127.0.0.1:5599/fairy-voice/status?token=$TOKEN"; echo
echo "=== status (bare) ==="
curl -s -m 10 -o /dev/null -w "http=%{http_code}\n" "http://127.0.0.1:5599/fairy-voice/status"
echo "=== tts ==="
curl -s -m 120 -X POST -H "Content-Type: application/json" -H "Cookie: dsh-token=$TOKEN" -d '{"text":"主人，系统语音兜底已经生效。"}' "http://127.0.0.1:5599/fairy-voice/tts?token=$TOKEN" -o "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/voice-out.pcm" -w "http=%{http_code} bytes=%{size_download} type=%{content_type}\n"
ls -l "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/voice-out.pcm" | awk '{print "pcm file:", $5, "bytes"}'
ffprobe -v error -f s16le -ar 32000 -ac 1 -i "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/voice-out.pcm" -show_entries format=duration -of default=nw=1 2>&1 | head -3
ffmpeg -v error -f s16le -ar 32000 -ac 1 -i "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/voice-out.pcm" -af "volumedetect" -f null - 2>&1 | tail -4