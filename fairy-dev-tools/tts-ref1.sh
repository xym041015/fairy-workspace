set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/GPT-SoVITS/GPT_SoVITS/pretrained_models/chinese-roberta-wwm-ext-large" </dev/null
nohup curl -L -o pytorch_model.bin "https://www.modelscope.cn/models/AI-ModelScope/GPT-SoVITS/resolve/master/chinese-roberta-wwm-ext-large/pytorch_model.bin" > "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/roberta.log" 2>&1 &
echo "roberta re-download started"
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts" </dev/null
echo "=== 参考音频信息 ==="
ffprobe -v error -show_entries format=duration -of default=nw=1 fairy_raw.wav
echo "=== 静音分布（每行一段静音结束时间）==="
ffmpeg -v error -i fairy_raw.wav -af silencedetect=noise=-32dB:d=0.45 -f null - 2>&1 | grep -E "silence_end" | tail -12