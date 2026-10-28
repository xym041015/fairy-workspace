import pathlib
p = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/client.js"
s = p.read_text()
lines = [line for line in s.split("\n") if "__fairyTrace" not in line]
s = "\n".join(lines)
assert "__fairyTrace" not in s
p.write_text(s)
print("trace points removed")