set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
grep -o "dsh web: http://127.0.0.1:5599[^ ]*" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/mirror/boot.log" | tail -1
echo "=== status ==="
curl -s -m 15 http://127.0.0.1:5599/fairy-voice/status; echo
echo "=== 安装参考音频（22s 候选 + ASR 文本）==="
python3 - <<'PY'
import base64, json, pathlib, urllib.request
T = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools")
audio = (T / "tts/fairy_ref_candidate.wav").read_bytes()
text = (T / "tts/fairy_ref_candidate.txt").read_text()
payload = json.dumps({ "audioBase64": base64.b64encode(audio).decode(), "text": text }).encode()
req = urllib.request.Request("http://127.0.0.1:5599/fairy-voice/reference", data=payload, headers={"Content-Type": "application/json"})
print(urllib.request.urlopen(req, timeout=60).read().decode()[:200])
PY
echo "=== 参考安装状态 ==="
curl -s -m 15 http://127.0.0.1:5599/fairy-voice/reference; echo