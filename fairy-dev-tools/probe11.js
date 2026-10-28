(() => {
  const all = [...document.querySelectorAll('div,span,footer,section')];
  const strip = all.filter((n) => /tok\/s|轮.*步/.test(n.textContent || '') && n.children.length <= 3).pop();
  const chain = [];
  let c = strip;
  while (c && chain.length < 6) { const cs = getComputedStyle(c); chain.push({ tag: c.tagName.toLowerCase(), slot: c.dataset?.slot || null, vis: cs.visibility, display: cs.display, bg: cs.backgroundColor, rect: [Math.round(c.getBoundingClientRect().x), Math.round(c.getBoundingClientRect().y)] }); c = c.parentElement; }
  return JSON.stringify({ modal: document.documentElement.hasAttribute('data-dsh-fairy-modal-open'), stripText: (strip?.textContent || '').trim().slice(0, 30), stripRect: strip ? strip.getBoundingClientRect().toJSON() : null, chain }, null, 1);
})()