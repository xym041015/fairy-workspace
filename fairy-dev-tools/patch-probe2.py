import pathlib
T = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools")
base = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice")
p = base / "lib/client.js"
s = p.read_text()
anchor = "function readVoiceTimeline(snapshot) {\n      const found = [];"
assert anchor in s, "anchor"
snippet = (T / "probe-snippet.js").read_text()
replacement = "function readVoiceTimeline(snapshot) {\n" + snippet + "      const found = [];"
s = s.replace(anchor, replacement, 1)
p.write_text(s)
print("probe inserted")