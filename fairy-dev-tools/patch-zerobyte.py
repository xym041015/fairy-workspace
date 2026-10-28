import pathlib

# 1) revert the engine to CPU
p = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/GPT-SoVITS/GPT_SoVITS/configs/tts_infer.yaml")
s = p.read_text()
s = s.replace("  device: mps" + chr(10) + "  is_half: false", "  device: cpu" + chr(10) + "  is_half: false")
p.write_text(s)

# 2) zero-byte local synthesis falls back to the host system voice
p = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/index.js"
s = p.read_text()
old = """        let upstream = null;
        try {
          upstream = await localTtsTransport.stream(text, controller.signal);
        } catch (localError) {
          if (!SYSTEM_TTS_FALLBACK_CODES.has(localError?.code)) throw localError;
          diagnostics.metric('tts.stream.fallback', startedAt, { code: localError.code });
          upstream = await systemTtsTransport.stream(text, controller.signal);
        }"""
assert old in s, "upstream block"
new = """        let upstream = null;
        let usedSystemVoice = false;
        try {
          upstream = await localTtsTransport.stream(text, controller.signal);
          // A 200 response can still yield no audio (device/library failures far
          // inside the local engine). Probe the first chunk so the request can
          // still be served audibly by the host system voice instead of silence.
          const probe = await readFirstChunk(upstream.response || upstream);
          if (!probe.ok) throw Object.assign(new Error('local synthesis produced no audio'), { code: 'local-service-failed' });
          upstream = probe.upstream;
        } catch (localError) {
          if (!SYSTEM_TTS_FALLBACK_CODES.has(localError?.code)) throw localError;
          diagnostics.metric('tts.stream.fallback', startedAt, { code: localError.code });
          upstream = await systemTtsTransport.stream(text, controller.signal);
          usedSystemVoice = true;
        }"""
s = s.replace(old, new, 1)

old2 = """        res.setHeader('Content-Type', response.headers.get('content-type') || 'audio/raw');"""
assert old2 in s, "header anchor"
s = s.replace(old2, """        res.setHeader('Content-Type', response.headers.get('content-type') || 'audio/raw');
        res.setHeader('X-Fairy-Voice', usedSystemVoice ? 'system' : 'fairy');""", 1)

# helper: read the first chunk, rebuild a stream that replays it
old3 = "export function createFairyVoiceHandlers({"
assert old3 in s, "handler anchor"
helper = """/* Preserve a probed first chunk: the failure mode we guard against (a 200 with an
 * empty body) must be distinguishable without losing the buffered audio. */
async function readFirstChunk(response) {
  const body = response?.body;
  if (!body) return { ok: false, upstream: { response, release: null } };
  const iterator = body[Symbol.asyncIterator]();
  const first = await iterator.next();
  if (first.done || !first.value || !first.value.length) {
    return { ok: false, upstream: { response, release: null } };
  }
  const replay = (async function* replayBody() {
    yield first.value;
    for (;;) {
      const next = await iterator.next();
      if (next.done) return;
      yield next.value;
    }
  })();
  return { ok: true, upstream: { response: { ...response, body: replay }, release: response.release ?? null } };
}

export function createFairyVoiceHandlers({"""
s = s.replace(old3, helper, 1)
p.write_text(s)
print("cpu restored + zero-byte fallback added")
