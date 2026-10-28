(() => {
  const dlg = [...document.querySelectorAll('[role="dialog"]')].pop();
  const dr = dlg.getBoundingClientRect();
  const modalFlag = document.documentElement.hasAttribute('data-dsh-fairy-modal-open');
  const pts = [];
  const samples = [[dr.right + 40, dr.bottom - 30], [dr.right + 40, dr.bottom - 120], [700, dr.bottom + 20], [760, 900], [1250, 545], [1290, 545]];
  for (const [x, y] of samples) {
    const el = document.elementFromPoint(x, y);
    const chain = [];
    let c = el;
    while (c && chain.length < 5) { chain.push(c.tagName.toLowerCase() + (c.dataset?.composerCard ? '[card]' : '') + (c.dataset?.slot ? '[slot=' + c.dataset.slot + ']' : '') + '.' + String(c.className || '').split(' ')[0].slice(0, 22)); c = c.parentElement; }
    pts.push({ x, y, chain, bg: el ? getComputedStyle(el).backgroundColor : null });
  }
  const card = document.querySelector('[data-composer-card="true"]');
  return JSON.stringify({ modalFlag, dialogRect: dr.toJSON(), viewport: [innerWidth, innerHeight], pts, cardComputed: card ? { bg: getComputedStyle(card).backgroundColor, vis: getComputedStyle(card).visibility, rect: card.getBoundingClientRect().toJSON() } : null, myRulesPresent: !!document.getElementById('dsh-fairy-visual-style') && document.getElementById('dsh-fairy-visual-style').textContent.includes('dsh-fairy-modal-open] [data-composer-card') });
})()