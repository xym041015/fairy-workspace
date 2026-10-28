import pathlib, re
s = (pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/client.js").read_text()
i = s.find("function readVoiceTimeline")
seg = s[i:i+6000]
j = seg.find("return {")
print("=== return shape ===")
print(seg[j:j+900])
k = s.find("className: \"dsh-fairy-voice-controls\"")
print("\n=== controls JSX ===")
print(s[max(0,k-300):k+1500])