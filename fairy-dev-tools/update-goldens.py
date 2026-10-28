import pathlib
base = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-visual/dsh-fairy-visual")

p = base / "test/style-output.test.js"
s = p.read_text()
old = "Buffer.byteLength(style.textContent), 133908"
assert old in s
s = s.replace(old, "Buffer.byteLength(style.textContent), 135355", 1)
old = "752af8093045e7ce68fe9099ce6d55869f671fd984fc535a3fdc885834abc979"
assert old in s
s = s.replace(old, "9cf0f47da3c086d8caf53a24dbcf0043e65487434385c3316ee326afab6caa46", 1)
p.write_text(s)

p = base / "test/contract.test.js"
s = p.read_text()
old = "'aria-selected', OFFICIAL_ATTRIBUTES.phase"
assert old in s
s = s.replace(old, "'aria-selected', 'aria-modal', 'role', OFFICIAL_ATTRIBUTES.phase", 1)
p.write_text(s)
print("goldens updated")