import pathlib

base = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice")

p = base / "lib/index.js"
s = p.read_text()
bad = "import { mkdir, stat as statFile, writeFile } from 'node:fs/promises';"
assert bad in s, "bad import"
s = s.replace(bad, "import { stat as statFile } from 'node:fs/promises';", 1)
p.write_text(s)

p2 = base / "lib/server/local-tts-proxy.js"
s2 = p2.read_text()
old = "  const localTtsRequest = (text) => ({"
assert old in s2, "request anchor"
s2 = s2.replace(old, "  const resolvePrompt = () => (typeof referencePrompt === 'function' ? referencePrompt() : referencePrompt);\n" + old, 1)
old2 = "prompt_text: referencePrompt,"
assert old2 in s2, "prompt anchor"
s2 = s2.replace(old2, "prompt_text: resolvePrompt(),", 1)
p2.write_text(s2)
print("imports and prompt resolution fixed")
