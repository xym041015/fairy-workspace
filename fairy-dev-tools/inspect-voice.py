import re, pathlib
p = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/client.js"
s = p.read_text()
print("len", len(s))
for pat in ["slots.register", "slots.inject", "FAIRY_VOICE_CONTROL", "data-slot", "fetch(", "/fairy-voice/"]:
    hits = list(re.finditer(re.escape(pat), s))
    print("==", pat, len(hits))
    for m in hits[:3]:
        frag = s[max(0, m.start() - 180): m.start() + 240]
        print("   ", frag.replace(chr(10), " "))