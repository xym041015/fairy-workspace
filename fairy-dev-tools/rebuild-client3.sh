set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH" </dev/null
git checkout -- fairy-voice/dsh-fairy-voice/lib/client.js
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
python3 apply-voice-client.py
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice" </dev/null
node --check lib/client.js && echo SYNTAX_OK
for pat in "data-dsh-fairy-play-control" "audibleVolume" "reportAudioLifecycleFailure('prime'" "useChat" "useMemo" "__fairy"; do printf "%s = %s\n" "$pat" "$(grep -c "$pat" lib/client.js || true)"; done
npm test 2>&1 | grep -E "ℹ (pass|fail)|^✖" | head -6