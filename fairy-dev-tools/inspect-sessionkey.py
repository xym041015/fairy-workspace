import re, pathlib
s = (pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/client.js").read_text()
for m in list(re.finditer(r"sessionKey = ", s))[:8]:
    print("---", s[max(0, m.start()-260): m.start()+200].replace(chr(10), " "))
print("==== kind: 'final' payload ====")
for m in list(re.finditer(r"kind: 'final'", s))[:3]:
    print("---", s[max(0, m.start()-700): m.start()+400].replace(chr(10), " "))