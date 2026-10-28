import pathlib, re
p = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-visual/dsh-fairy-visual") / "test/style-output.test.js"
s = p.read_text()
s = re.sub(r"Buffer\.byteLength\(style\.textContent\), \d+", "Buffer.byteLength(style.textContent), 137944", s, count=1)
s = re.sub(r"assert\.equal\(createHash\('sha256'\)\.update\(style\.textContent\)\.digest\('hex'\), '[0-9a-f]+'\)", "assert.equal(createHash('sha256').update(style.textContent).digest('hex'), '5a463050fe5b739c746d13e26c9c375b959457918e2804837158a7b3fed23847')", s, count=1)
p.write_text(s)
print("golden updated")