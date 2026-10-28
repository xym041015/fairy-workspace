(() => {
  const b = document.querySelector('[data-dsh-fairy-play-control]');
  if (!b) return JSON.stringify({ missing: true });
  const r = b.getBoundingClientRect();
  const hit = document.elementFromPoint(r.x + r.width / 2, r.y + r.height / 2);
  b.click();
  return JSON.stringify({ rect: [Math.round(r.x), Math.round(r.y), Math.round(r.width), Math.round(r.height)], hitTag: hit ? hit.tagName : null, hitSame: hit === b || b.contains(hit), activeNow: document.activeElement ? document.activeElement.tagName + '.' + String(document.activeElement.className).slice(0, 20) : null });
})()