import pathlib
p = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/index.js"
s = p.read_text()

# import
old_import = "import { createVoiceBriefFallback, createVoiceBrainServerBoundary } from './server/voice-brief-fallback.js';"
assert old_import in s, "import anchor"
s = s.replace(old_import, old_import + "\nimport { createSystemTtsTransport } from './server/system-tts.js';", 1)

# fallback code set
old_const = "const VOICE_BRAIN_CONFIG_PATH = join(homedir(), '.dsh', 'fairy-voice', 'voice-brain.json');"
assert old_const in s, "const anchor"
s = s.replace(old_const, old_const + "\nconst SYSTEM_TTS_FALLBACK_CODES = new Set(['local-service-unavailable', 'local-service-failed', 'timeout']);", 1)

# transport instance
old_tr = "  const voiceBrainBoundary = createVoiceBrainServerBoundary({"
assert old_tr in s, "boundary anchor"
s = s.replace(old_tr, "  const systemTtsTransport = createSystemTtsTransport();\n" + old_tr, 1)

# status fallback
old_status = """      try {
        sendJson(res, 200, await localTtsTransport.status());
      } catch (error) {
        diagnostics.warn('status.request', {}, error);
        sendJson(res, 200, { available: false, reason: '本地 Fairy 服务未启动。' });
      } finally {"""
assert old_status in s, "status anchor"
new_status = """      try {
        try {
          sendJson(res, 200, await localTtsTransport.status());
        } catch (localError) {
          // Without the local GPT-SoVITS service the host system voice keeps
          // the voice surface usable instead of reporting a dead service.
          sendJson(res, 200, await systemTtsTransport.status());
        }
      } catch (error) {
        diagnostics.warn('status.request', {}, error);
        sendJson(res, 200, { available: false, reason: '本地 Fairy 服务未启动。' });
      } finally {"""
s = s.replace(old_status, new_status, 1)

# tts fallback
old_stream = "        const upstream = await localTtsTransport.stream(text, controller.signal);"
assert old_stream in s, "stream anchor"
new_stream = """        let upstream = null;
        try {
          upstream = await localTtsTransport.stream(text, controller.signal);
        } catch (localError) {
          if (!SYSTEM_TTS_FALLBACK_CODES.has(localError?.code)) throw localError;
          diagnostics.metric('tts.stream.fallback', startedAt, { code: localError.code });
          upstream = await systemTtsTransport.stream(text, controller.signal);
        }"""
s = s.replace(old_stream, new_stream, 1)
p.write_text(s)
print("index.js wired to the system voice fallback")