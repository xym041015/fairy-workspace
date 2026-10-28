import pathlib
p = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/index.js"
s = p.read_text()
old = "  return { ok: true, upstream: { response: { ...response, body: replay }, release: response.release ?? null } };"
assert old in s, "spread anchor"
new = "  return { ok: true, upstream: { response: { ok: response.ok, status: response.status, headers: response.headers, body: replay }, release: response.release ?? null } };"
s = s.replace(old, new, 1)
p.write_text(s)
print("response wrapper fixed (no prototype-less spread)")
