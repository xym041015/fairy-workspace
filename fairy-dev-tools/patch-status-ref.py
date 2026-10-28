import pathlib
p = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/index.js"
s = p.read_text()
old = "          sendJson(res, 200, { ...(await localTtsTransport.status()), backend: 'gpt-sovits', voice: 'Fairy' });"
assert old in s, "status"
new = """          const voiceStatus = await localTtsTransport.status();
          const reference = await statFile(REFERENCE_AUDIO_PATH).catch(() => null);
          sendJson(res, 200, {
            ...voiceStatus,
            backend: 'gpt-sovits',
            voice: 'Fairy',
            referenceInstalled: Boolean(reference),
            reason: reference ? null : '需要 3-10 秒的 Fairy 参考音频（见 /fairy-voice/reference）。',
          });"""
s = s.replace(old, new, 1)
p.write_text(s)
print("status now reports the reference state")
