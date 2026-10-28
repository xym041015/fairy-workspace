#!/usr/bin/env node
// Minimal CDP driver (no dependencies): goto / eval / evalfile / shot / viewport
import fs from 'node:fs';
const PORT = process.env.CDP_PORT || '9334';
const BASE = `http://127.0.0.1:${PORT}`;

async function pageTarget() {
  const list = await (await fetch(`${BASE}/json/list`)).json();
  let t = list.find((x) => x.type === 'page');
  if (!t) t = await (await fetch(`${BASE}/json/new?url=about:blank`, { method: 'PUT' })).json();
  return t;
}

function connect(wsUrl) {
  return new Promise((resolve, reject) => {
    const sock = new WebSocket(wsUrl);
    let id = 0;
    const pending = new Map();
    const events = [];
    const waiters = [];
    sock.addEventListener('open', () => resolve({ send, on }));
    sock.addEventListener('error', () => reject(new Error('ws error')));
    sock.addEventListener('message', (ev) => {
      const msg = JSON.parse(ev.data);
      if (msg.id && pending.has(msg.id)) {
        const { res, rej } = pending.get(msg.id);
        pending.delete(msg.id);
        msg.error ? rej(new Error(JSON.stringify(msg.error))) : res(msg.result);
      } else if (msg.method) {
        events.push(msg);
        waiters.slice().forEach((w) => w(msg));
      }
    });
    function send(method, params = {}) {
      const mid = ++id;
      return new Promise((res, rej) => {
        pending.set(mid, { res, rej });
        sock.send(JSON.stringify({ id: mid, method, params }));
        setTimeout(() => { if (pending.has(mid)) { pending.delete(mid); rej(new Error('timeout ' + method)); } }, 60000);
      });
    }
    function on(pred, ms = 20000) {
      return new Promise((res, rej) => {
        const hit = events.find(pred);
        if (hit) return res(hit);
        const w = (m) => { if (pred(m)) { waiters.splice(waiters.indexOf(w), 1); res(m); } };
        waiters.push(w);
        setTimeout(() => { const i = waiters.indexOf(w); if (i >= 0) waiters.splice(i, 1); rej(new Error('event timeout')); }, ms);
      });
    }
  });
}

const [cmd, ...args] = process.argv.slice(2);
const t = await pageTarget();
const cdp = await connect(t.webSocketDebuggerUrl);
await cdp.send('Page.enable');
await cdp.send('Runtime.enable');

async function evaluate(expression) {
  const res = await cdp.send('Runtime.evaluate', { expression, returnByValue: true, awaitPromise: true });
  if (res.exceptionDetails) {
    console.error('EVAL ERROR: ' + JSON.stringify(res.exceptionDetails).slice(0, 1000));
    process.exit(1);
  }
  console.log(typeof res.result.value === 'string' ? res.result.value : JSON.stringify(res.result.value, null, 1));
}

if (cmd === 'goto') {
  cdp.send('Page.navigate', { url: args[0] }).catch(() => {});
  await cdp.on((m) => m.method === 'Page.loadEventFired', 30000).catch(() => {});
  console.log('loaded ' + args[0]);
} else if (cmd === 'eval') {
  await evaluate(args.join(' '));
} else if (cmd === 'evalfile') {
  await evaluate(fs.readFileSync(args[0], 'utf8'));
} else if (cmd === 'call') {
  const out = await cdp.send(args[0], args[1] ? JSON.parse(args[1]) : {});
  console.log(JSON.stringify(out).slice(0, 800));
} else if (cmd === 'shot') {
  const r = await cdp.send('Page.captureScreenshot', { format: 'png', captureBeyondViewport: args[1] === 'full' });
  fs.writeFileSync(args[0], Buffer.from(r.data, 'base64'));
  console.log('saved ' + args[0]);
} else if (cmd === 'crop') {
  const [x, y, w, h, scale] = args.slice(0, 5).map(Number);
  const r = await cdp.send('Page.captureScreenshot', { format: 'png', clip: { x, y, width: w, height: h, scale: scale || 2 } });
  fs.writeFileSync(args[5], Buffer.from(r.data, 'base64'));
  console.log('saved ' + args[5]);
} else if (cmd === 'viewport') {
  await cdp.send('Emulation.setDeviceMetricsOverride', { width: Number(args[0]) || 1440, height: Number(args[1]) || 900, deviceScaleFactor: 1, mobile: false });
  console.log('viewport ' + args[0] + 'x' + args[1]);
} else {
  console.error('usage: cdp.mjs goto|eval|evalfile|shot|viewport');
  process.exit(2);
}
process.exit(0);