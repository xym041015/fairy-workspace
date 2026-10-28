(() => {
  const el = document.querySelector('[data-composer-card="true"] [data-composer-input]');
  if (!el) return JSON.stringify({ error: 'no trigger' });
  const r = el.getBoundingClientRect();
  const x = r.x + r.width / 2, y = r.y + r.height / 2;
  const opts = { bubbles: true, cancelable: true, composed: true, clientX: x, clientY: y, button: 0, buttons: 1, pointerId: 1, isPrimary: true, pointerType: 'mouse' };
  el.dispatchEvent(new PointerEvent('pointerdown', opts));
  el.dispatchEvent(new MouseEvent('mousedown', opts));
  el.dispatchEvent(new PointerEvent('pointerup', { ...opts, buttons: 0 }));
  el.dispatchEvent(new MouseEvent('mouseup', { ...opts, buttons: 0 }));
  el.dispatchEvent(new MouseEvent('click', { ...opts, buttons: 0 }));
  return JSON.stringify({ ok: true, x, y });
})()