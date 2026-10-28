import re, pathlib
s = (pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/client.js").read_text()
i = s.find("function useVoiceBrain")
print(s[i:i+2600].replace(chr(10), "\\n")[:2600])
print("\n\n===== speak/play call sites =====")
for m in re.finditer(r"(speak|play)\((?![^)]*useCallback)", s):
    seg = s[max(0, m.start()-120): m.start()+200].replace(chr(10), " ")
    if "play" in m.group(1) or "speak" in m.group(1): print("   ", seg)