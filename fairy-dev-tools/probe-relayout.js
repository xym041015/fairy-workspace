(() => {
  const pick = {
    dock: '[data-dsh-fairy-composer-dock="true"]',
    input: '[data-input-scroll]',
    send: '[data-dsh-fairy-composer-send-control="true"]',
    voice: '[data-dsh-fairy-composer-voice-control="true"]',
    scale: '[data-dsh-fairy-mascot-scale-base="true"]',
    speed: '[data-dsh-fairy-mascot-animation-speed-base="true"]',
    skin: 'img.dshwv-img',
    chips: '[data-dsh-fairy-composer-workspace="true"]'
  };
  const rects = {};
  for (const [k, sel] of Object.entries(pick)) {
    const n = document.querySelector(sel);
    rects[k] = n ? n.getBoundingClientRect().toJSON() : null;
  }
  const keys = Object.keys(rects).filter((k) => rects[k]);
  const overlaps = [];
  for (let i = 0; i < keys.length; i++) for (let j = i + 1; j < keys.length; j++) {
    const a = rects[keys[i]], b = rects[keys[j]];
    const ox = Math.min(a.right, b.right) - Math.max(a.left, b.left);
    const oy = Math.min(a.bottom, b.bottom) - Math.max(a.top, b.top);
    if (ox > 1 && oy > 1) overlaps.push(keys[i] + '×' + keys[j] + ' ' + Math.round(ox) + 'x' + Math.round(oy));
  }
  const brief = {};
  for (const k of keys) brief[k] = [Math.round(rects[k].x), Math.round(rects[k].y), Math.round(rects[k].width), Math.round(rects[k].height)];
  return JSON.stringify({ rects: brief, overlaps }, null, 1);
})()