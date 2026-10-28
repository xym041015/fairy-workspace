import re, pathlib
s = (pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/client.js").read_text()
i = s.find("EVENT_PLAY =")
print("EVENT_PLAY def:", s[max(0,i-120):i+160].replace(chr(10), " "))
j = s.find("window.addEventListener(EVENT_PLAY")
print("\n--- onPlay handler ---\n", s[max(0,j-900):j+200].replace(chr(10), " "))
k = s.find("dispatchEvent(new CustomEvent(EVENT_PLAY")
print("\n--- dispatch site ---\n", s[max(0,k-1500):k+400].replace(chr(10), " "))