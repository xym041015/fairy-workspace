set -e
python3 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/patch-response-wrap.py"
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice" </dev/null
node --check lib/index.js && npm test 2>&1 | grep -E "ℹ (pass|fail)" | head -2
echo "=== 重新加载插件 ==="