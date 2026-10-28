(() => {
  const control = document.querySelector('[data-dsh-fairy-voice-control]');
  const r = control ? control.getBoundingClientRect().toJSON() : null;
  return JSON.stringify({
    voiceControl: control ? { rect: [Math.round(r.x), Math.round(r.y), Math.round(r.width), Math.round(r.height)], label: control.getAttribute('aria-label'), disabled: control.disabled ?? null, title: control.getAttribute('title') } : null,
    voiceControlsAll: document.querySelectorAll('[data-dsh-fairy-voice-control]').length,
    statusProbe: 'see server log'
  });
})()