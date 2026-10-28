import pathlib
p = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/client.js"
s = p.read_text()
old = "      const snapshot = useSession(readVoiceTimeline);"
assert old in s, "snapshot anchor"
new = "\n".join([
  "      // The session snapshot no longer carries the chat projection in this DSH",
  "      // layout; the composer slot injects useChat for it. Merge both so the",
  "      // timeline selector keeps one contract across DSH generations.",
  "      const sessionSnapshot = useSession((state) => state);",
  "      const chatSnapshot = typeof useChat === 'function' ? useChat((state) => state) : null;",
  "      const snapshot = React.useMemo(",
  "        () => readVoiceTimeline({ ...sessionSnapshot, chat: chatSnapshot || undefined }),",
  "        [sessionSnapshot, chatSnapshot],",
  "      );",
])
s = s.replace(old, new, 1)
p.write_text(s)
print("chat projection wired")