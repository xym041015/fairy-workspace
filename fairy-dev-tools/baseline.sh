set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-visual/dsh-fairy-visual" </dev/null
git diff > /tmp/fairy-visual-fix.patch
wc -l /tmp/fairy-visual-fix.patch
git checkout -- src/client/dom-adapter.js src/client/semantic-markers-manager.js src/client/style.js
echo "=== baseline tests ==="
npm test 2>&1 | grep -E "^✖|^# (pass|fail)" | head -12 || true
echo "=== restore fix ==="
git apply /tmp/fairy-visual-fix.patch && echo "fix re-applied"
grep -c modalDialog src/client/dom-adapter.js