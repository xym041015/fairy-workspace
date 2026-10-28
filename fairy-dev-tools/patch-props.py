import pathlib
p = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/client.js"
s = p.read_text()
anchor = "    function SessionScopedVoiceController(props) {\n      const hddVisualMode = useHddVisualMode();"
assert anchor in s, "scoped anchor"
probe = anchor + "\n      window.__fairyProps = { keys: Object.keys(props), types: Object.fromEntries(Object.entries(props).map(([k, v]) => [k, typeof v])) };"
s = s.replace(anchor, probe, 1)
p.write_text(s)
print("props probe added")