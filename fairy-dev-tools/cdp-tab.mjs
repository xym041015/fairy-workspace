#!/usr/bin/env node
// cdp-tab.mjs <match-substring-of-url> <goto|eval|evalfile|shot> <args...>
import fs from 'node:fs';
const PORT = process.env.CDP_PORT || '9334';
const BASE = `http://127.0.0.1:${PORT}`;
const [match, cmd, ...args] = process.argv.slice(2);

const list = await (await fetch(`${BASE}/json/list`)).json();
const t = list.find((x) => x.type === 'page' && x.url.includes(match));
if (!t) { console.error('no tab matching ' + match); process.exit(1); }

const sock = new WebSocket(t.webSocketDebuggerUrl);
let id = 0;
const pending = new Map();
const events = [];
const waiters = [];
sock.addEventListener('open', () => run());
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
function on(pred, ms = 30000) {
  return new Promise((res, rej) => {
    const hit = events.find(pred);
    if (hit) return res(hit);
    const w = (m) => { if (pred(m)) { waiters.splice(waiters.indexOf(w), 1); res(m); } };
    waiters.push(w);
    setTimeout(() => rej(new Error('event timeout')), ms);
  });
}
async function evaluate(expression) {
  const res = await send('Runtime.evaluate', { expression, returnByValue: true, awaitPromise: true });
  if (res.exceptionDetails) {
    console.error('EVAL ERROR: ' + JSON.stringify(res.exceptionDetails).slice(0, 800));
    process.exit(1);
  }
  console.log(typeof res.result.value === 'string' ? res.result.value : JSON.stringify(res.result.value, null, 1));
}
async function run() {
  await send('Page.enable');
  await send('Runtime.enable');
  if (cmd === 'goto') {
    await send('Page.navigate', { url: args[0] }).catch(() => {});
    await on((m) => m.method === 'Page.loadEventFired').catch(() => {});
    console.log('loaded ' + args[0]);
  } else if (cmd === 'eval') {
    await evaluate(args.join(' '));
  } else if (cmd === 'evalfile') {
    await evaluate(fs.readFileSync(args[0], 'utf8'));
  } else if (cmd === 'shot') {
    const r = await send('Page.captureScreenshot', { format: 'png' });
    fs.writeFileSync(args[0], Buffer.from(r.data, 'base64'));
    console.log('saved ' + args[0]);
  } else if (cmd === 'crop') {
    const [x, y, w, h, scale] = args.slice(0, 5).map(Number);
    const r = await send('Page.captureScreenshot', { format: 'png', clip: { x, y, width: w, height: h, scale: scale || 2 } });
    fs.writeFileSync(args[5], Buffer.from(r.data, 'base64'));
    console.log('saved ' + args[5]);
  } else if (cmd === 'viewport') {
    await send('Emulation.setDeviceMetricsOverride', { width: Number(args[0]) || 1440, height: Number(args[1]) || 900, deviceScaleFactor: 1, mobile: false });
    console.log('viewport ' + args[0] + 'x' + args[1]);
  } else if (cmd === 'reload') {
    await send('Page.reload', { ignoreCache: true }).catch(() => {});
    await on((m) => m.method === 'Page.loadEventFired', 45000).catch(() => {});
    console.log('reloaded');
  }
  process.exit(0);
}
