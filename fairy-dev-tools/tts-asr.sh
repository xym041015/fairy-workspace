set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/GPT-SoVITS" </dev/null
export HOME="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/home"; export MODELSCOPE_CACHE="/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/ms-cache"
ls -l GPT_SoVITS/pretrained_models/chinese-roberta-wwm-ext-large/pytorch_model.bin | awk '{printf "roberta bytes: %d\n", $5}'
curl -s -m 5 -o /dev/null -w "api http=%{http_code}\n" http://127.0.0.1:9880/docs
echo "=== SenseVoice 转写（首次会下模型）==="
nohup .venv/bin/python "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/transcribe.py" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/fairy_ref_candidate.wav" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/fairy_ref_candidate.txt" > "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/asr.log" 2>&1 &
sleep 90
tail -4 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/asr.log"