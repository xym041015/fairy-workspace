set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts" </dev/null
for spec in "a 8.18 5.16" "b 24.21 5.30" "c 32.12 6.23"; do
  set -- $spec
  ffmpeg -v error -y -ss $2 -t $3 -i fairy_src.wav -ac 1 -ar 32000 -af "loudnorm=I=-18:TP=-2" "ref_$1.wav"
  printf "%s: " "$1"; ffprobe -v error -show_entries format=duration -of default=nw=1:nk=1 "ref_$1.wav"
done
cd GPT-SoVITS </dev/null
export HOME="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/home"; export MODELSCOPE_CACHE="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/ms-cache"
for c in a b c; do
  echo "=== 转写 ref_$c ==="
  .venv/bin/python "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/transcribe.py" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/ref_$c.wav" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/ref_$c.txt" 2>/dev/null | grep "^TRANSCRIPT:"
done