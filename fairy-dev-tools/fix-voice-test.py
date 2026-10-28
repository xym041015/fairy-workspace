import pathlib
p = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "test/system-tts.test.js"
s = p.read_text()
old = "    const target = args[args.indexOf('-o') + 1];"
assert old in s
new = "    const target = args.indexOf('-o') >= 0 ? args[args.indexOf('-o') + 1] : args[args.length - 1];"
s = s.replace(old, new, 1)
p.write_text(s)
print("fake command target fixed")