import pathlib
s = (pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/client.js").read_text()
i = s.find("FINAL_PLAYBACK_SETTLE_MS)")
print("=== final playback effect ===")
print(s[max(0, i-2200): i+300])
j = s.find("const onPlay = ")
print("\n=== play orchestrator ===")
print(s[max(0, j-200): j+1800])