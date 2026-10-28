import re, pathlib
s = (pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/client.js").read_text()
for pat in ["primeAudio(", "audioReady", "setAudioReady", "onPointerDown", "onClick", "朗读"]:
    hits = list(re.finditer(re.escape(pat), s))
    print("=====", pat, len(hits))
    for m in hits[:3]:
        print("  ...", s[max(0, m.start() - 240): m.start() + 240].replace(chr(10), " "))