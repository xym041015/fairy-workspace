import pathlib
p = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-visual/dsh-fairy-visual") / "test/style-output.test.js"
s = p.read_text()
s = s.replace("Buffer.byteLength(style.textContent), 135355", "Buffer.byteLength(style.textContent), 135559", 1)
s = s.replace("9cf0f47da3c086d8caf53a24dbcf0043e65487434385c3316ee326afab6caa46", "aa3c59d0843ae3b1ee193d0a3688b4815baaa5983116410c66eb832122ac2529", 1)
p.write_text(s)
print("css golden updated")