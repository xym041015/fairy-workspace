set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/probe3.js" </dev/null
node cdp.mjs evalfile "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/probe2.js" > "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/probe2.json" </dev/null
cat > "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/pixel.mjs" <<'EOF'
import fs from 'node:fs';
import { createRequire } from 'node:module';
const require = createRequire(import.meta.url);
const { PNG } = require('/Users/xuzhouping/.dsh/profiles/web/node_modules/pngjs');
function mean(file, x0, y0, x1, y1) {
  const png = PNG.sync.read(fs.readFileSync(file));
  let r = 0, g = 0, b = 0, n = 0;
  for (let y = y0; y < y1; y += 2) for (let x = x0; x < x1; x += 2) { const i = (png.width * y + x) << 2; r += png.data[i]; g += png.data[i+1]; b += png.data[i+2]; n++; }
  return [Math.round(r/n), Math.round(g/n), Math.round(b/n)];
}
const file = process.argv[2];
const regions = {
  'sidebar-bg': [30, 420, 200, 520],
  'main-bg-right': [1180, 560, 1400, 700],
  'main-bg-top': [1250, 120, 1450, 200],
  'composer-right-tail': [1170, 460, 1300, 550],
  'mascot': [1380, 780, 1500, 930],
  'modal-panel': [420, 150, 700, 250],
};
for (const [k, v] of Object.entries(regions)) console.log(k.padEnd(22), mean(file, ...v).join(','));
EOF
echo "=== pixels with settings OPEN ==="
node "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/pixel.mjs" "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/06-settings.png" </dev/null