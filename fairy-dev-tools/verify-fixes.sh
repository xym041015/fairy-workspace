set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
URL=$(grep -o "http://127.0.0.1:5599/?token=[A-Za-z0-9_-]*" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mirror/boot.log" | tail -1)
node cdp.mjs viewport 1512 945 </dev/null
node cdp.mjs goto "$URL" </dev/null
sleep 6
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/keyset2.js" </dev/null || true
sleep 3
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/focusinput.js" </dev/null
node cdp.mjs call Input.insertText '{"text":"布局修正验证 text"}' </dev/null
node cdp.mjs call Input.dispatchKeyEvent '{"type":"keyDown","key":"Enter","code":"Enter","windowsVirtualKeyCode":13,"nativeVirtualKeyCode":13}' </dev/null
node cdp.mjs call Input.dispatchKeyEvent '{"type":"keyUp","key":"Enter","code":"Enter","windowsVirtualKeyCode":13,"nativeVirtualKeyCode":13}' </dev/null
sleep 9
echo "=== right column geometry (after fix) ==="
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/probe-dock-right.js" </dev/null | python3 -c "import json,sys; d=json.load(sys.stdin); [print(i['s'], i['rect']) for i in d['items'] if i.get('rect') and i['rect'][2]>60 and i['rect'][3]>12]; print('OVERLAPS:', json.dumps(d['overlaps']))"
# attachments check
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/focusinput.js" </dev/null
node cdp.mjs call Input.insertText '{"text":"贴图后文字应可见 XYZ"}' </dev/null
sleep 1
node "${T}/attach.mjs" "${T}/probe-image.png" </dev/null
sleep 3
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/probe-holevars.js" </dev/null | python3 -c "import json,sys; d=json.load(sys.stdin); print('after z:', d['after']['zIndex'], d['after']['left'], d['after']['top'], d['after']['width'], d['after']['height'])"
node cdp.mjs eval "JSON.stringify({scrollZ: getComputedStyle(document.querySelector('[data-input-scroll]')).zIndex, textRect: (() => { const s = document.querySelector('[data-lexical-text]'); if (!s) return null; const r = document.createRange(); r.selectNodeContents(s); const b = r.getBoundingClientRect(); return [Math.round(b.x), Math.round(b.y), Math.round(b.width), Math.round(b.height)]; })()})" </dev/null
node cdp.mjs crop 440 805 800 55 3 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/90-inputline-after-fix.png" </dev/null
node cdp.mjs crop 1180 810 332 135 3 "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/91-rightcolumn-after-fix.png" </dev/null