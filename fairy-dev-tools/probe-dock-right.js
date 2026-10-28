(() => {
  const sels = [
    '[data-dsh-fairy-composer-dock="true"]',
    '[data-composer-card="true"]',
    '[data-dsh-fairy-composer-trailing="true"]',
    '[data-dsh-fairy-composer-voice-control="true"]',
    '[data-dsh-fairy-mascot-scale-base="true"]',
    '[data-dsh-fairy-mascot-scale-control="true"]',
    '[data-dsh-fairy-mascot-animation-speed-base="true"]',
    '[data-dsh-fairy-mascot-animation-speed-control="true"]',
    '[data-dsh-fairy-composer-output-control="true"]',
    '[data-dsh-fairy-composer-send-control="true"]',
    '[data-dsh-fairy-composer-accessory="true"]'
  ];
  const out = sels.map((s) => {
    const n = document.querySelector(s);
    if (!n) return { s, missing: true };
    const cs = getComputedStyle(n);
    const r = n.getBoundingClientRect();
    return {
      s: s.replace('[data-dsh-fairy-', '').replace('="true"]', ''),
      rect: [Math.round(r.x), Math.round(r.y), Math.round(r.width), Math.round(r.height)],
      pos: cs.position, top: cs.top, right: cs.right, left: cs.left, bottom: cs.bottom,
      z: cs.zIndex, overflow: cs.overflow,
      offsetParent: n.offsetParent ? (n.offsetParent.getAttribute('data-dsh-fairy-composer-dock') ? 'dock' : n.offsetParent.className.toString().slice(0, 24)) : null
    };
  });
  // pairwise overlap among right-column pills
  const pills = out.filter((o) => o && o.rect && o.rect[2] > 60 && o.rect[3] > 12);
  const overlaps = [];
  for (let i = 0; i < pills.length; i++) for (let j = i + 1; j < pills.length; j++) {
    const [ax, ay, aw, ah] = pills[i].rect, [bx, by, bw, bh] = pills[j].rect;
    const ox = Math.min(ax + aw, bx + bw) - Math.max(ax, bx), oy = Math.min(ay + ah, by + bh) - Math.max(ay, by);
    if (ox > 2 && oy > 2) overlaps.push({ a: pills[i].s, b: pills[j].s, overlap: [ox, oy] });
  }
  return JSON.stringify({ items: out, overlaps }, null, 1);
})()