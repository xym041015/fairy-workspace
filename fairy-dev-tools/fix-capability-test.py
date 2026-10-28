import pathlib
p = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-visual/dsh-fairy-visual") / "test/capability.test.js"
s = p.read_text()
old_import = "import { join } from 'node:path';"
assert old_import in s, "path import"
s = s.replace(old_import, old_import + "\nimport { fileURLToPath } from 'node:url';", 1)
old = "join(sourceRoot.pathname, entry.name)"
assert old in s, "pathname use"
s = s.replace(old, "join(fileURLToPath(sourceRoot), entry.name)", 1)
p.write_text(s)
print("capability test path fix applied")