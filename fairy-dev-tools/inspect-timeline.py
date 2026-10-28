import pathlib
s = (pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/client.js").read_text()
i = s.find("function readVoiceTimeline")
print("=== readVoiceTimeline ===")
print(s[i:i+1800])
j = s.find("const VoiceController")
print("\n=== VoiceController head ===")
print(s[j:j+1200])