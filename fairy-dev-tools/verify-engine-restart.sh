set -e
python3 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/patch-status-ref.py"
chmod +x "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/start-voice-engine.sh" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/stop-voice-engine.sh"
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice" </dev/null
node --check lib/index.js && npm test 2>&1 | grep -E "ℹ (pass|fail)" | head -3
bash "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/stop-voice-engine.sh" >/dev/null 2>&1 || true
sleep 2
bash "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/start-voice-engine.sh" 2>&1 | tail -2