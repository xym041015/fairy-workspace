set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/click-voice.js" </dev/null
sleep 10
node cdp.mjs eval "JSON.stringify({controlState: (() => { const c = document.querySelector('[data-dsh-fairy-voice-control]'); return c ? { aria: c.getAttribute('aria-label'), pressed: c.getAttribute('aria-pressed'), disabled: c.disabled } : null; })(), dock: !!document.querySelector('[data-dsh-fairy-composer-dock=\"true\"]')})" </dev/null
echo "=== host log: voice traffic ==="
grep -o '"module":"dsh-fairy-voice","operation":"[a-z.]*","event":"[a-z]*"' "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mirror/boot.log" | sort | uniq -c | tail -10