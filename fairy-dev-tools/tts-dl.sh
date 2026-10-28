set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/GPT-SoVITS/GPT_SoVITS/pretrained_models" </dev/null
cat > "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/dl-models.sh" <<'EOS'
set -e
cd "$(dirname "$0")/GPT-SoVITS/GPT_SoVITS/pretrained_models"
BASE="https://www.modelscope.cn/models/AI-ModelScope/GPT-SoVITS/resolve/master"
mkdir -p "$(dirname 'chinese-roberta-wwm-ext-large/config.json')"; curl -sL -o 'chinese-roberta-wwm-ext-large/config.json' "$BASE/chinese-roberta-wwm-ext-large/config.json" &
mkdir -p "$(dirname 'chinese-roberta-wwm-ext-large/tokenizer.json')"; curl -sL -o 'chinese-roberta-wwm-ext-large/tokenizer.json' "$BASE/chinese-roberta-wwm-ext-large/tokenizer.json" &
mkdir -p "$(dirname 'chinese-roberta-wwm-ext-large/pytorch_model.bin')"; curl -sL -o 'chinese-roberta-wwm-ext-large/pytorch_model.bin' "$BASE/chinese-roberta-wwm-ext-large/pytorch_model.bin" &
mkdir -p "$(dirname 'chinese-hubert-base/config.json')"; curl -sL -o 'chinese-hubert-base/config.json' "$BASE/chinese-hubert-base/config.json" &
mkdir -p "$(dirname 'chinese-hubert-base/preprocessor_config.json')"; curl -sL -o 'chinese-hubert-base/preprocessor_config.json' "$BASE/chinese-hubert-base/preprocessor_config.json" &
mkdir -p "$(dirname 'chinese-hubert-base/pytorch_model.bin')"; curl -sL -o 'chinese-hubert-base/pytorch_model.bin' "$BASE/chinese-hubert-base/pytorch_model.bin" &
mkdir -p "$(dirname 'gsv-v2final-pretrained/s1bert25hz-5kh-longer-epoch=12-step=369668.ckpt')"; curl -sL -o 'gsv-v2final-pretrained/s1bert25hz-5kh-longer-epoch=12-step=369668.ckpt' "$BASE/gsv-v2final-pretrained/s1bert25hz-5kh-longer-epoch=12-step=369668.ckpt" &
mkdir -p "$(dirname 'gsv-v2final-pretrained/s2D2333k.pth')"; curl -sL -o 'gsv-v2final-pretrained/s2D2333k.pth' "$BASE/gsv-v2final-pretrained/s2D2333k.pth" &
mkdir -p "$(dirname 'gsv-v2final-pretrained/s2G2333k.pth')"; curl -sL -o 'gsv-v2final-pretrained/s2G2333k.pth' "$BASE/gsv-v2final-pretrained/s2G2333k.pth" &
wait
echo done
EOS
bash "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/dl-models.sh" > "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/dl.log" 2>&1 &
echo "download started"
sleep 40
du -sh . ; tail -2 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/dl.log"