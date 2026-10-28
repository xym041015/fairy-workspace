(() => {
  const detail = (sel) => {
    const n = document.querySelector(sel);
    if (!n) return { sel, missing: true };
    const cs = getComputedStyle(n);
    return {
      sel,
      rect: [Math.round(n.getBoundingClientRect().x), Math.round(n.getBoundingClientRect().y), Math.round(n.getBoundingClientRect().width), Math.round(n.getBoundingClientRect().height)],
      position: cs.position, inset: [cs.top, cs.right, cs.bottom, cs.left].join(' '),
      margin: cs.margin, padding: cs.padding, transform: cs.transform,
      gridRow: cs.gridRow, gridColumn: cs.gridColumn, alignSelf: cs.alignSelf, justifySelf: cs.justifySelf,
      display: cs.display, height: cs.height, boxSizing: cs.boxSizing,
      parent: n.parentElement ? { cls: String(n.parentElement.className).slice(0, 30), rect: [Math.round(n.parentElement.getBoundingClientRect().x), Math.round(n.parentElement.getBoundingClientRect().y), Math.round(n.parentElement.getBoundingClientRect().width), Math.round(n.parentElement.getBoundingClientRect().height)], pos: getComputedStyle(n.parentElement).position, display: getComputedStyle(n.parentElement).display, padding: getComputedStyle(n.parentElement).padding } : null
    };
  };
  return JSON.stringify([detail('[data-dsh-fairy-composer-voice-control="true"]'), detail('[data-dsh-fairy-mascot-scale-base="true"]'), detail('[data-dsh-fairy-mascot-scale-control="true"]'), detail('[data-dsh-fairy-mascot-animation-speed-base="true"]')], null, 1);
})()