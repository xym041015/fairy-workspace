(() => {
  if (window.__fairyAudioHooked) return JSON.stringify({ already: true });
  window.__fairyAudioHooked = true;
  const Orig = window.AudioContext;
  window.__fairyCtx = [];
  window.__fairyGains = [];
  window.__fairyStarts = [];
  window.AudioContext = class extends Orig {
    constructor(...args) { super(...args); window.__fairyCtx.push(this); }
  };
  const origGain = Orig.prototype.createGain;
  Orig.prototype.createGain = function (...args) { const node = origGain.apply(this, args); window.__fairyGains.push(node); return node; };
  const origStart = (window.AudioBufferSourceNode || {}).prototype?.start;
  if (origStart) {
    window.AudioBufferSourceNode.prototype.start = function (...args) {
      try { window.__fairyStarts.push({ duration: this.buffer ? this.buffer.duration : null, sampleRate: this.buffer ? this.buffer.sampleRate : null, at: Date.now() }); } catch (e) {}
      return origStart.apply(this, args);
    };
  }
  window.__fairyAudioReport = () => ({
    contexts: window.__fairyCtx.map((c) => ({ state: c.state, sampleRate: c.sampleRate })),
    gains: window.__fairyGains.map((g) => Number(g.gain.value)),
    starts: window.__fairyStarts.map((s) => ({ duration: s.duration, sampleRate: s.sampleRate })),
    totalSeconds: window.__fairyStarts.reduce((sum, s) => sum + (s.duration || 0), 0),
    storage: { volume: localStorage.getItem('dsh.fairyVoice.volume'), autoRead: localStorage.getItem('dsh.fairyVoice.autoRead.v4') }
  });
  return JSON.stringify({ hooked: true, hadWebAudio: !!Orig });
})()