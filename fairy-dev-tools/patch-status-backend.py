import pathlib

base = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice")
p = base / "lib/index.js"
s = p.read_text()
old = "          sendJson(res, 200, await localTtsTransport.status());"
assert old in s, "status anchor"
s = s.replace(old, "          sendJson(res, 200, { ...(await localTtsTransport.status()), backend: 'gpt-sovits', voice: 'Fairy' });", 1)
p.write_text(s)
print("status now reports the cloned backend")
