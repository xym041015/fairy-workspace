import re, pathlib
s = (pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/client.js").read_text()
for m in list(re.finditer(r"available", s))[:8]:
    print("----", s[max(0,m.start()-160):m.start()+200].replace(chr(10), " "))