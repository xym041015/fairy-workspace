(() => {
  const out = {};
  const sels = ['[data-slot="conversation.composer"]', '[data-slot="conversation.composer.bar"]', '[data-composer-card="true"]', '[data-composer-seat]', '[data-input-scroll]', '[data-dsh-fairy-composer-dock="true"]'];
  for (const s of sels) {
    const n = document.querySelector(s);
    if (!n) { out[s] = null; continue; }
    const cs = getComputedStyle(n);
    out[s] = { rect: n.getBoundingClientRect().toJSON(), bg: cs.backgroundColor, vis: cs.visibility, overflow: cs.overflow };
  }
  // what paints in the strip right of the modal at composer height?
  const strip = [];
  for (const y of [460, 490, 520, 550]) {
    for (const x of [1180, 1240, 1296]) {
      const el = document.elementFromPoint(x, y);
      if (el) strip.push({ x, y, el: el.tagName.toLowerCase() + '.' + String(el.className || '').split(' ')[0].slice(0, 20), bg: getComputedStyle(el).backgroundColor });
    }
  }
  return JSON.stringify({ rects: out, strip });
})()