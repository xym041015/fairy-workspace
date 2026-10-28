import pathlib, re
s = (pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/client.js").read_text()
for m in list(re.finditer(r"function SessionScopedVoiceController|SessionScopedVoiceController", s))[:3]:
    print("---", s[max(0, m.start()-200): m.start()+700].replace(chr(10), " "))
print()
i = s.find("function VoiceController(")
print("=== VoiceController ===")
print(s[i:i+900])