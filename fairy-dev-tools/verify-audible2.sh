set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/click-play.js" </dev/null
sleep 2
node cdp.mjs eval "JSON.stringify(window.__fairyAudioReport())" </dev/null
sleep 1
node cdp.mjs eval "(() => { window.dispatchEvent(new CustomEvent('fairy-voice-play', { detail: { messageId: 'probe-final-3', markdown: '语音探针。', sessionKey: 'session-9b5e6fd5-a2fb-45f1-994c-cf83498133d8' } })); return 'dispatched'; })()" </dev/null
sleep 10
node cdp.mjs eval "JSON.stringify(window.__fairyAudioReport())" </dev/null