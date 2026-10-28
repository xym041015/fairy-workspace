import fs from 'node:fs';
import { createRequire } from 'node:module';
const require = createRequire(import.meta.url);
const { PNG } = require('/Users/xuzhouping/.dsh/profiles/web/node_modules/pngjs');
function mean(file, x0, y0, x1, y1) {
  const png = PNG.sync.read(fs.readFileSync(file));
  let r = 0, g = 0, b = 0, n = 0;
  for (let y = y0; y < y1; y += 2) for (let x = x0; x < x1; x += 2) { const i = (png.width * y + x) << 2; r += png.data[i]; g += png.data[i+1]; b += png.data[i+2]; n++; }
  return [Math.round(r/n), Math.round(g/n), Math.round(b/n)].join(',');
}
const f = process.argv[2];
console.log('composer-tail   ', mean(f, 1170, 450, 1300, 555));
console.log('substrate-below ', mean(f, 1170, 620, 1300, 700));
console.log('composer-strip-b', mean(f, 500, 880, 1100, 905));
