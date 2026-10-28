import { readdirSync, readFileSync } from 'node:fs';
import { join } from 'node:path';
const sourceRoot = new URL('/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-visual/dsh-fairy-visual/src/client/', 'file://');
const re = /querySelector(?:All)?\([^\n]*(?:data-slot|data-phase|data-composer|data-conversation-scroll|data-input-scroll|data-chat-flow)/;
const files = readdirSync(sourceRoot, { withFileTypes: true }).filter((e) => e.isFile() && e.name.endsWith('.js') && e.name !== 'dom-adapter.js').map((e) => join(sourceRoot.pathname, e.name));
for (const f of files) { const s = readFileSync(f, 'utf8'); const m = s.match(re); if (m) console.log(f.split('/').pop() + ' :: ' + m[0].slice(0, 120)); }
