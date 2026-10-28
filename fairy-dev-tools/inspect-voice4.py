import re, pathlib
s = (pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/client.js").read_text()
for m in re.finditer(r"PCM_[A-Z_]+ *= *[^;,]{0,40}", s):
    print(m.group(0))
for m in list(re.finditer(r"tts", s, re.I))[:0]: pass
for m in list(re.finditer(r"/fairy-voice|LOCAL_TTS_ENDPOINT", s))[:6]:
    print("----", m.group(0)); print(s[max(0,m.start()-200):m.start()+260].replace(chr(10), " "))
print("=== streaming fetch ===")
for m in list(re.finditer(r"format: *.(pcm|PCM)|content-type|Content-Type|arrayBuffer\(|getReader\(", s))[:6]:
    print("----", m.group(0)); print(s[max(0,m.start()-220):m.start()+240].replace(chr(10), " "))