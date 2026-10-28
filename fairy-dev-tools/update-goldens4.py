import pathlib
p = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-visual/dsh-fairy-visual") / "test/style-output.test.js"
s = p.read_text()
s = s.replace("Buffer.byteLength(style.textContent), 135559", "Buffer.byteLength(style.textContent), 136049", 1)
s = s.replace("aa3c59d0843ae3b1ee193d0a3688b4815baaa5983116410c66eb832122ac2529", "6a7f6022c651aafb986ebecb34d24228ef545852bb0ed97a363bc2b4528e0531", 1)
p.write_text(s)
print("golden updated")