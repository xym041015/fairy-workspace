import pathlib
p = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/client.js"
s = p.read_text()
start = s.index("      // Manual read-now: the composer control guarantees audible feedback for")
end = s.index("      }, [autoRead, engineAvailable, sessionKey, snapshot, state.status, stop]);")
end = s.index("\n", end) + 1
replacement = "\n".join([
  "      // Manual read-now: one click unlocks the audio device inside the user",
  "      // gesture, guarantees an audible volume, and replays the newest settled",
  "      // answer instead of only arming automatic playback for later turns.",
  "      const readLatest = React.useCallback(() => {",
  "        if (!engineAvailable) return;",
  "        if (state.status === 'playing') { stop(); return; }",
  "        if (!autoRead) setAutoRead(true);",
  "        const audibleVolume = volume > 0.05 ? volume : 1;",
  "        if (audibleVolume !== volume) { setVolume(audibleVolume); setOutputVolume(audibleVolume); }",
  "        primeAudio(audibleVolume).catch(() => {});",
  "        const settled = snapshot.messagesById ? [...snapshot.messagesById.values()] : [];",
  "        const latest = settled.length ? settled[settled.length - 1] : null;",
  "        if (!latest || !latest.markdown) return;",
  "        window.dispatchEvent(new CustomEvent(EVENT_PLAY, { detail: { messageId: latest.id, markdown: latest.markdown, sessionKey } }));",
  "      }, [autoRead, engineAvailable, primeAudio, sessionKey, setOutputVolume, snapshot, state.status, stop, volume]);",
]) + "\n"
s = s[:start] + replacement + s[end:]
p.write_text(s)
print("readLatest upgraded")