import re, pathlib
s = (pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/client.js").read_text()
pats = ["const play =", "play(markdown", "function usePlayer", "createAutoReadPolicy(", "autoLabel", "engineAvailable", "markdownFor", "latestAnswer", "timeline"]
for pat in pats:
    hits = list(re.finditer(re.escape(pat), s))
    print("=====", pat, len(hits))
    for m in hits[:2]:
        print("   ", s[max(0, m.start() - 200): m.start() + 320].replace(chr(10), " "))