(() => {
  const el = document.querySelector('[data-composer-input]');
  if (!el) return JSON.stringify({ error: 'no input' });
  el.focus();
  const r = el.getBoundingClientRect();
  const o = { bubbles: true, cancelable: true, composed: true, clientX: r.x + 5, clientY: r.y + 5, button: 0, pointerId: 1, isPrimary: true, pointerType: 'mouse' };
  el.dispatchEvent(new PointerEvent('pointerdown', o));
  el.dispatchEvent(new MouseEvent('mousedown', o));
  el.dispatchEvent(new PointerEvent('pointerup', { ...o, buttons: 0 }));
  el.dispatchEvent(new MouseEvent('mouseup', { ...o, buttons: 0 }));
  el.dispatchEvent(new MouseEvent('click', { ...o, buttons: 0 }));
  return JSON.stringify({ ok: true, ce: el.getAttribute('contenteditable'), ph: el.getAttribute('data-placeholder'), focused: document.activeElement === el });
})()