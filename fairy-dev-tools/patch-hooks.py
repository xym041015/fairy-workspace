import pathlib
p = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/client.js"
T = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools")
s = p.read_text()
old_sig = "    function VoiceController({ useSession, sessionId }) {"
assert old_sig in s, "signature anchor"
s = s.replace(old_sig, "    function VoiceController({ useSession, sessionId, useChat, useProjection, useTrajectory, useConversation }) {", 1)
anchor = "      const snapshot = useSession(readVoiceTimeline);"
assert anchor in s, "snapshot anchor"
snippet = (T / "hooks-snippet.js").read_text()
s = s.replace(anchor, anchor + "\n" + snippet, 1)
p.write_text(s)
print("hooks probe inserted")