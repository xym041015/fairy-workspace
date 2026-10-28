import pathlib

base = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice")
p = base / "lib/index.js"
s = p.read_text()

old_paths = """const REFERENCE_AUDIO_PATH = join(homedir(), '.dsh', 'fairy-voice', 'runtime', 'reference', 'fairy_ref.wav');
const REFERENCE_PROMPT_PATH = join(homedir(), '.dsh', 'fairy-voice', 'runtime', 'reference', 'fairy_ref.txt');"""
assert old_paths in s, "paths"
new_paths = """const FAIRY_HOME = process.env.DSH_HOME || join(homedir(), '.dsh');
const REFERENCE_DIR = process.env.DSH_FAIRY_REFERENCE_DIR || join(FAIRY_HOME, 'fairy-voice', 'runtime', 'reference');
const REFERENCE_AUDIO_PATH = join(REFERENCE_DIR, 'fairy_ref.wav');
const REFERENCE_PROMPT_PATH = join(REFERENCE_DIR, 'fairy_ref.txt');"""
s = s.replace(old_paths, new_paths, 1)

old_read = """function readReferencePrompt() {
  try {
    return readFileSync(REFERENCE_PROMPT_PATH, 'utf8').trim();
  } catch (error) {
    diagnostics.warn('reference.prompt.load', { file: 'fairy_ref.txt', fallback: true }, error);
    return REFERENCE_PROMPT_FALLBACK;
  }
}

const REFERENCE_PROMPT = readReferencePrompt();"""
assert old_read in s, "read prompt"
new_read = """/* Read lazily: the reference pair can be installed while the host is running. */
function readReferencePrompt({ warn = false } = {}) {
  try {
    return readFileSync(REFERENCE_PROMPT_PATH, 'utf8').trim() || REFERENCE_PROMPT_FALLBACK;
  } catch (error) {
    if (warn) diagnostics.warn('reference.prompt.load', { file: 'fairy_ref.txt', fallback: true }, error);
    return REFERENCE_PROMPT_FALLBACK;
  }
}

const REFERENCE_PROMPT = readReferencePrompt({ warn: true });"""
s = s.replace(old_read, new_read, 1)

old_transport = """    referenceAudioPath: REFERENCE_AUDIO_PATH,
    referencePrompt: REFERENCE_PROMPT,"""
assert old_transport in s, "transport"
new_transport = """    referenceAudioPath: REFERENCE_AUDIO_PATH,
    referencePrompt: () => readReferencePrompt(),"""
s = s.replace(old_transport, new_transport, 1)

old_routes = """    const unregisterBrainBrief = ws.webServer.register({ kind: 'exact', path: '/fairy-voice/brain/brief', handler: handlers.voiceBrief });"""
assert old_routes in s, "routes"
new_routes = old_routes + """
    const unregisterReference = ws.webServer.register({ kind: 'exact', path: '/fairy-voice/reference', handler: handlers.reference });"""
s = s.replace(old_routes, new_routes, 1)

old_unregister = """      unregisterBrainBrief?.();"""
assert old_unregister in s, "unregister"
s = s.replace(old_unregister, old_unregister + """
      unregisterReference?.();""", 1)

# add the reference handler before the closing of the returned handler object
old_close = """    voiceBrief: async (req, res) => {"""
assert old_close in s, "voiceBrief anchor"
handler = """    reference: async (req, res) => {
      try {
        if (req.method === 'GET') {
          const stat = await statFile(REFERENCE_AUDIO_PATH);
          const text = readReferencePrompt();
          sendJson(res, 200, {
            installed: Boolean(stat),
            audioBytes: stat ? stat.size : 0,
            text: text === REFERENCE_PROMPT_FALLBACK ? '' : text,
            directory: REFERENCE_DIR,
          });
          return;
        }
        const body = await readJson(req, 40_000_000);
        const audio = typeof body?.audioBase64 === 'string' ? Buffer.from(body.audioBase64, 'base64') : null;
        if (!audio || !audio.length) throw Object.assign(new Error('missing audio'), { code: 'invalid-json' });
        await mkdir(dirname(REFERENCE_AUDIO_PATH), { recursive: true });
        await writeFile(REFERENCE_AUDIO_PATH, audio, { mode: 0o600 });
        const text = typeof body?.text === 'string' ? body.text.trim() : '';
        await writeFile(REFERENCE_PROMPT_PATH, text || REFERENCE_PROMPT_FALLBACK, { mode: 0o600 });
        diagnostics.metric('reference.install', Date.now(), { audio_bytes: audio.length, text_chars: text.length });
        sendJson(res, 200, { installed: true, audioBytes: audio.length, text });
      } catch (error) {
        const code = error?.code === 'invalid-json' ? 'invalid-json' : 'reference-install-failed';
        diagnostics.warn('reference.install', { code }, error);
        sendJson(res, statusFor(code), { error: publicError(code) });
      }
    },
    voiceBrief: async (req, res) => {"""
s = s.replace(old_close, handler, 1)

# imports
old_import = "import { readFileSync } from 'node:fs';"
assert old_import in s, "fs import"
s = s.replace(old_import, "import { mkdir, stat as statFile, writeFile } from 'node:fs/promises';\nimport { readFileSync } from 'node:fs';", 1)
old_import2 = "import { dirname, join } from 'node:path';"
assert old_import2 in s, "path import"
p.write_text(s)
print("reference install channel added")
