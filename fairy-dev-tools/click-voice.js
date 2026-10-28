(() => {
  const el = document.querySelector('[data-dsh-fairy-voice-control]');
  if (!el) return JSON.stringify({ error: 'no control' });
  const r = el.getBoundingClientRect();
  const o = { bubbles: true, cancelable: true, composed: true, clientX: r.x + r.width / 2, clientY: r.y + r.height / 2, button: 0, buttons: 1, pointerId: 1, isPrimary: true, pointerType: 'mouse' };
  el.dispatchEvent(new PointerEvent('pointerdown', o));
  el.dispatchEvent(new MouseEvent('mousedown', o));
  el.dispatchEvent(new PointerEvent('pointerup', { ...o, buttons: 0 }));
  el.dispatchEvent(new MouseEvent('mouseup', { ...o, buttons: 0 }));
  el.dispatchEvent(new MouseEvent('click', { ...o, buttons: 0 }));
  return JSON.stringify({ clicked: true, label: el.getAttribute('aria-label'), rect: [Math.round(r.x), Math.round(r.y), Math.round(r.width), Math.round(r.height)] });
})()