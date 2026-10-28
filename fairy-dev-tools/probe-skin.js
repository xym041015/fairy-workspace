(() => {
  const out = [];
  for (const el of document.querySelectorAll('body *')) {
    const r = el.getBoundingClientRect();
    if (r.width < 80 || r.height < 80) continue;
    if (r.x > 1300 && r.y > 700) {
      const cs = getComputedStyle(el);
      out.push({ tag: el.tagName.toLowerCase(), cls: String(el.className || '').slice(0, 36), rect: [Math.round(r.x), Math.round(r.y), Math.round(r.width), Math.round(r.height)], pos: cs.position, z: cs.zIndex, pe: cs.pointerEvents, bg: cs.backgroundImage.slice(0, 40) });
    }
  }
  return JSON.stringify(out.slice(0, 12), null, 1);
})()