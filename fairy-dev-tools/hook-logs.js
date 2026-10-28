(() => {
  window.__voiceLog = [];
  if (!window.__voiceLogHooked) {
    window.__voiceLogHooked = true;
    window.addEventListener('error', (e) => window.__voiceLog.push({ kind: 'error', message: String(e.message).slice(0, 300) }));
    window.addEventListener('unhandledrejection', (e) => window.__voiceLog.push({ kind: 'rejection', message: String(e.reason && e.reason.message || e.reason).slice(0, 300) }));
    for (const level of ['warn', 'error', 'info']) {
      const original = console[level];
      console[level] = (...args) => { try { window.__voiceLog.push({ kind: 'console.' + level, message: args.map((a) => (typeof a === 'string' ? a : (() => { try { return JSON.stringify(a); } catch { return String(a); } })())).join(' ').slice(0, 400) }); } catch {} return original.apply(console, args); };
    }
  }
  return JSON.stringify({ hooked: true });
})()