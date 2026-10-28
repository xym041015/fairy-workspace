import re, pathlib
s = (pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/client.js").read_text()
for pat in ["gain.gain", "volume", "localStorage", "unlockAudio", "pcm"]:
    hits = list(re.finditer(pat, s, re.I))
    print("=====", pat, len(hits))
    for m in hits[:4]:
        print("  ...", s[max(0, m.start() - 200): m.start() + 200].replace(chr(10), " "))