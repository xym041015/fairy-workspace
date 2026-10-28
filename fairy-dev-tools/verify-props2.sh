set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
URL=$(grep -o "http://127.0.0.1:5599/?token=[A-Za-z0-9_-]*" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mirror/boot.log" | tail -1)
echo "url: ${URL:0:40}..."
node cdp.mjs viewport 1512 945 </dev/null
node cdp.mjs goto "$URL" </dev/null
sleep 8
node cdp.mjs shot "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/120-state.png" </dev/null
node cdp.mjs eval "JSON.stringify({phase: [...document.querySelectorAll('[data-phase]')].map(n=>n.getAttribute('data-phase')), hasComposer: !!document.querySelector('[data-composer-card=\"true\"]'), fairyVisual: document.documentElement.hasAttribute('data-dsh-fairy-visual'), voiceControl: !!document.querySelector('[data-dsh-fairy-voice-control]'), props: window.__fairyProps || null, probe: window.__fairyProbe || null})" </dev/null
tail -3 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mirror/boot.log"