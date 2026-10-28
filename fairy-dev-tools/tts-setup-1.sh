set -e
mkdir -p "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts"
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts" </dev/null
if [ ! -d GPT-SoVITS ]; then
  git clone --depth 1 https://github.com/RVC-Boss/GPT-SoVITS.git 2>&1 | tail -2
fi
cd GPT-SoVITS </dev/null
git log --oneline -1
ls | head -20
echo "=== venv (python 3.10) ==="
if [ ! -x .venv/bin/python ]; then uv venv --python 3.10 .venv 2>&1 | tail -3; fi
.venv/bin/python -V
echo "=== 版本/依赖线索 ==="
head -30 requirements.txt 2>/dev/null || ls *.txt