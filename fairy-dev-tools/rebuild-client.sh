set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH" </dev/null
git checkout -- fairy-voice/dsh-fairy-voice/lib/client.js
echo "client reverted to upstream"
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
python3 patch-voice-client.py   # read-now callback + play button
python3 patch-readlatest.py     # upgrade: gesture unlock + audible volume
python3 patch-usechat.py        # chat projection via injected useChat
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice" </dev/null
node --check lib/client.js && echo SYNTAX_OK
grep -c "data-dsh-fairy-play-control" lib/client.js
grep -c "audibleVolume" lib/client.js
grep -c "useChat" lib/client.js
grep -c "__fairyProbe\|__fairyHooks\|__fairyProps" lib/client.js || echo "no probes left"
npm test 2>&1 | grep -E "ℹ (pass|fail)"