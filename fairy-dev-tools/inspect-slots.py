import re, pathlib
s = (pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/client.js").read_text()
names = sorted(set(re.findall(r"[\'\"]([a-z][a-z0-9]*(?:\.[a-z0-9]+)+)[\'\"]", s)))
print("slot-like names:", names)
for m in re.finditer(r"publish\(|register\(|inject\(", s):
    seg = s[max(0, m.start()-160): m.start()+160].replace(chr(10), " ")
    if "slots." in seg or "name" in seg:
        print("   ...", seg)