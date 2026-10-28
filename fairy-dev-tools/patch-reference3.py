import pathlib

base = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice")
p = base / "lib/index.js"
s = p.read_text()

old = """/* Read lazily: the reference pair can be installed while the host is running. */
function readReferencePrompt({ warn = false } = {}) {
  try {
    return readFileSync(REFERENCE_PROMPT_PATH, 'utf8').trim() || REFERENCE_PROMPT_FALLBACK;
  } catch (error) {
    if (warn) diagnostics.warn('reference.prompt.load', { file: 'fairy_ref.txt', fallback: true }, error);
    return REFERENCE_PROMPT_FALLBACK;
  }
}

const REFERENCE_PROMPT = readReferencePrompt({ warn: true });"""
assert old in s, "loader"
new = """/* Read lazily: the reference pair can be installed while the host is running.
 * The first miss is reported once; later misses stay silent. */
function readReferencePrompt() {
  try {
    return readFileSync(REFERENCE_PROMPT_PATH, 'utf8').trim() || REFERENCE_PROMPT_FALLBACK;
  } catch (error) {
    if (!readReferencePrompt.warned) {
      readReferencePrompt.warned = true;
      diagnostics.warn('reference.prompt.load', { file: 'fairy_ref.txt', fallback: true }, error);
    }
    return REFERENCE_PROMPT_FALLBACK;
  }
}

const REFERENCE_PROMPT = readReferencePrompt();"""
s = s.replace(old, new, 1)
p.write_text(s)
print("loader restored to the contract shape")
