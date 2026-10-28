import pathlib
s = (pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/client.js").read_text()
i = s.find("Manual read-now")
print("=== readLatest region ===")
print(s[max(0, i-260): i+1500])
j = s.find("data-dsh-fairy-play-control")
print("\n=== button JSX region ===")
print(s[max(0, j-300): j+400])