(() => {
  const dlg = [...document.querySelectorAll('[role="dialog"][aria-modal="true"]')].pop();
  const inside = (n) => !!(dlg && dlg.contains(n));
  const info = (n, label) => {
    if (!n) return { label, missing: true };
    const cs = getComputedStyle(n);
    const r = n.getBoundingClientRect();
    return { label, insideModal: inside(n), rect: [Math.round(r.x), Math.round(r.y), Math.round(r.width), Math.round(r.height)], vis: cs.visibility, opacity: cs.opacity, bg: cs.backgroundColor, z: cs.zIndex, txt: (n.textContent || '').trim().slice(0, 26) };
  };
  const q = (s) => document.querySelector(s);
  const out = [];
  out.push(info(q('[data-composer-card="true"]'), 'composer-card'));
  out.push(info(q('[data-dsh-fairy-composer-seat="true"]'), 'fairy-composer-seat'));
  out.push(info(q('[data-dsh-fairy-composer-dock="true"]'), 'fairy-composer-dock'));
  out.push(info(q('[data-slot="conversation.composer"]'), 'slot:conversation.composer'));
  out.push(info(q('[data-slot="conversation.composer.bar"]'), 'slot:composer.bar'));
  out.push(info(q('[data-input-scroll]'), 'input-scroll'));
  out.push(info(q('[data-slot="conversation.session.header"]'), 'session-header'));
  out.push(info(q('[data-slot="conversation.session.header.utilities"]'), 'header-utilities'));
  out.push(info(q('[data-dsh-fairy-toggle]'), 'fairy-toggle'));
  out.push(info(q('.dsh-fairy-stage'), 'stage'));
  out.push(info(q('[data-dsh-fairy-sidebar-layer="true"]'), 'sidebar-layer'));
  out.push(info(q('[data-dsh-fairy-overlay-layer="true"]'), 'overlay-layer'));
  // the status strip: find deepest element whose text matches the counters
  const all = [...document.querySelectorAll('div,span,footer,section')];
  const strip = all.filter((n) => /tok\/s|tok\b|轮.*步/.test(n.textContent || '') && n.children.length <= 3).pop();
  out.push(info(strip, 'status-strip(byText)'));
  out.push(info(strip ? strip.closest('[data-slot]') : null, 'status-strip-slot'));
  return JSON.stringify({ modalOpen: document.documentElement.hasAttribute('data-dsh-fairy-modal-open'), dialogRect: dlg ? dlg.getBoundingClientRect().toJSON() : null, items: out }, null, 1);
})()