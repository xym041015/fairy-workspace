import fs from 'node:fs';
const buf = fs.readFileSync(process.argv[2]);
let peak = 0, sum = 0, n = 0;
for (let i = 0; i + 1 < buf.length; i += 2) { const v = buf.readInt16LE(i) / 32768; peak = Math.max(peak, Math.abs(v)); sum += v * v; n++; }
console.log(JSON.stringify({ bytes: buf.length, samples: n, seconds: +(n / 32000).toFixed(2), peak: +peak.toFixed(3), rms: +Math.sqrt(sum / n).toFixed(4), silent: peak < 0.01 }));
