import re, pathlib
s = (pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/client.js").read_text()
names = sorted(set(re.findall(r"[\'\"]([a-z][a-z0-9]*\.[a-z0-9.]+)[\'\"]", s)))
print("slot-like names:", [n for n in names if "." in n][:40])
print("register/inject calls:")
for m in re.finditer(r"(slots\.(?:register|inject)\()", s):
    print("   ", s[m.start():m.start()+200].replace(chr(10), " "))
print("settings namespaces:", sorted(set(re.findall(r"namespace: \'([^\']+)\'", s))))