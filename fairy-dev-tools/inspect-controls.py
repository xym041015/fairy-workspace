import pathlib
s = (pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/client.js").read_text()
i = s.find("\"dsh-fairy-voice-controls\", role: \"group\"")
if i < 0: i = s.find("className: \"dsh-fairy-voice-controls\"")
print(s[max(0, i-400): i+3000])