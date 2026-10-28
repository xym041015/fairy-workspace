(() => {
  const input = document.querySelector('[data-composer-input]');
  const scroll = document.querySelector('[data-input-scroll]');
  const card = document.querySelector('[data-composer-card="true"]');
  const info = (n) => { if (!n) return null; const cs = getComputedStyle(n); const r = n.getBoundingClientRect(); return { rect: [Math.round(r.x), Math.round(r.y), Math.round(r.width), Math.round(r.height)], color: cs.color, opacity: cs.opacity, visibility: cs.visibility, overflow: cs.overflow, z: cs.zIndex, pos: cs.position, display: cs.display, transform: cs.transform, clip: cs.clipPath, clientH: n.clientHeight, scrollH: n.scrollHeight, scrollTop: n.scrollTop }; };
  const pts = [[500, 866], [600, 866], [700, 850]];
  return JSON.stringify({
    input: info(input), scroll: info(scroll), card: info(card),
    inputHTML: input ? input.innerHTML.slice(0, 200) : null,
    hits: pts.map(([x, y]) => { const el = document.elementFromPoint(x, y); return { x, y, el: el ? el.tagName.toLowerCase() + '.' + String(el.className || '').slice(0, 26) : null, fairy: el ? el.getAttributeNames().filter((a) => a.startsWith('data-dsh-fairy')).join('+') : null }; }),
    attachmentsActive: card ? card.getAttribute('data-dsh-fairy-composer-attachments-active') : null,
    railRect: (() => { const r = document.querySelector('[data-dsh-fairy-composer-attachments="true"]'); return r ? r.getBoundingClientRect().toJSON() : null; })(),
    afterRect: (() => { const c = card; return c ? getComputedStyle(c, '::after').content : null; })()
  }, null, 1);
})()