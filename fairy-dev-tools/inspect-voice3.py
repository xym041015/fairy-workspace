import re, pathlib
s = (pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/client.js").read_text()
for pat in ["AudioContext", "sampleRate", "decodeAudioData", "audioWorklet", "createBuffer", "chunk", "pcm", "wav", "Playback", "playback"]:
    hits = [m.start() for m in re.finditer(pat, s, re.I)]
    print(pat, len(hits))
for m in list(re.finditer(r"AudioContext|decodeAudioData|sampleRate", s))[:6]:
    print("----", m.group(0)); print(s[max(0,m.start()-260):m.start()+260].replace(chr(10), " "))