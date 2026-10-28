import pathlib
base = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-visual/dsh-fairy-visual")
p = base / "test/contract.test.js"
s = p.read_text()
old = r"'aria-selected', OFFICIAL_ATTRIBUTES\.phase"
assert old in s, "anchor"
s = s.replace(old, r"'aria-selected', 'aria-modal', 'role', OFFICIAL_ATTRIBUTES\.phase", 1)
p.write_text(s)
print("contract golden updated")