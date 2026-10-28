set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/hook-audio.js" </dev/null
node cdp.mjs eval "localStorage.setItem('dsh.fairyVoice.volume','1'); localStorage.setItem('dsh.fairyVoice.autoRead.v4','true'); JSON.stringify({volume: localStorage.getItem('dsh.fairyVoice.volume')})" </dev/null
node cdp.mjs eval "(() => { const b = document.querySelector('[data-dsh-fairy-play-control]'); if (!b) return JSON.stringify({ missing: true }); const r = b.getBoundingClientRect(); const hit = document.elementFromPoint(r.x + r.width/2, r.y + r.height/2); return JSON.stringify({ exists: true, disabled: b.disabled, label: b.getAttribute('aria-label'), rect: [Math.round(r.x), Math.round(r.y), Math.round(r.width), Math.round(r.height)], hitIsButton: hit === b || b.contains(hit) }); })()" </dev/null
node cdp.mjs crop 690 855 190 60 3 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/110-voice-controls.png" </dev/null
echo "=== dispatch manual final (same contract the button uses) ==="
node cdp.mjs eval "(() => { const sess = document.querySelector('[data-dsh-fairy-voice-control]') ? null : null; const key = window.__fairySessionKey || null; return JSON.stringify({ note: '需要 sessionKey，改由下方脚本注入' }); })()" </dev/null