import pathlib, re
p = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-visual/dsh-fairy-visual") / "test/style-output.test.js"
s = p.read_text()
s = re.sub(r"Buffer\.byteLength\(style\.textContent\), \d+", "Buffer.byteLength(style.textContent), 136958", s, count=1)
s = re.sub(r"assert\.equal\(createHash\('sha256'\)\.update\(style\.textContent\)\.digest\('hex'\), '[0-9a-f]+'\)", "assert.equal(createHash('sha256').update(style.textContent).digest('hex'), 'bc1c1a5a24fa2227cb643bf8f44f5c4ec43d53a2ae7b5a7a43808b54bdfd0e53')", s, count=1)
p.write_text(s)
print("golden ->", "136958", "bc1c1a5a24fa2227cb643bf8f44f5c4ec43d53a2ae7b5a7a43808b54bdfd0e53")