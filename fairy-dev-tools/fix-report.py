import pathlib
p = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/client.js"
s = p.read_text()
old = "        primeAudio(audibleVolume).catch(() => {});"
assert old in s
new = "        primeAudio(audibleVolume).catch((error) => reportAudioLifecycleFailure('prime', error));"
s = s.replace(old, new, 1)
p.write_text(s)
print("silent catch replaced with a classified report")