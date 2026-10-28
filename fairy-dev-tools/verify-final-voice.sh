set -e
for i in 1 2 3; do PID=$(lsof -ti tcp:5599 -sTCP:LISTEN 2>/dev/null | head -1 || true); [ -n "$PID" ] && kill "$PID" && sleep 1 || break; done
sleep 2
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
bash "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/make-mirror.sh" < /dev/null | tail -1
bash "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/browser.sh" < /dev/null | head -2
bash "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/scenario3.sh" < /dev/null | tail -1
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/hook-logs.js" </dev/null
node cdp.mjs eval "(() => { const b = document.querySelector('[data-dsh-fairy-play-control]'); const auto = document.querySelector('[data-dsh-fairy-auto-control]'); const vol = document.querySelector('[data-dsh-fairy-volume-input]'); const r = (n) => (n ? [Math.round(n.getBoundingClientRect().x), Math.round(n.getBoundingClientRect().y), Math.round(n.getBoundingClientRect().width), Math.round(n.getBoundingClientRect().height)] : null); return JSON.stringify({ play: r(b), playLabel: b ? b.getAttribute('aria-label') : null, playDisabled: b ? b.disabled : null, autoToggle: r(auto), volume: r(vol), volumeValue: vol ? vol.value : null, hdd: document.documentElement.hasAttribute('data-dsh-fairy-visual') }); })()" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/click-play.js" </dev/null
sleep 3
node cdp.mjs eval "JSON.stringify({ logs: (window.__voiceLog || []).slice(-5) })" </dev/null
node cdp.mjs crop 690 855 200 60 3 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/130-voice-controls-final.png" </dev/null