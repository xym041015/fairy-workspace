import pathlib, re
p = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-visual/dsh-fairy-visual") / "test/style-output.test.js"
s = p.read_text()
s = re.sub(r"Buffer\.byteLength\(style\.textContent\), \d+", "Buffer.byteLength(style.textContent), 138046", s, count=1)
s = re.sub(r"assert\.equal\(createHash\('sha256'\)\.update\(style\.textContent\)\.digest\('hex'\), '[0-9a-f]+'\)", "assert.equal(createHash('sha256').update(style.textContent).digest('hex'), '290585acf949c759500fef05ba80c328ddc3b3f1fc17d698b4bfbdeeb0400f33')", s, count=1)
p.write_text(s)
print("golden updated")