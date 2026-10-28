(() => {
  const path = (n) => { const p = []; let c = n; while (c && c !== document.body && p.length < 8) { p.push(c.tagName.toLowerCase() + (c.dataset && c.dataset.slot ? '[slot=' + c.dataset.slot + ']' : '') + (c.className && typeof c.className === 'string' ? '.' + c.className.split(' ')[0].slice(0,24) : '')); c = c.parentElement; } return p.join(' < '); };
  const dlg = [...document.querySelectorAll('[role="dialog"]')];
  const info = dlg.map(d => ({ label: d.getAttribute('aria-label'), modal: d.getAttribute('aria-modal'), inSettingsSlot: !!d.closest('[data-slot="sidebar.settings"]'), rect: d.getBoundingClientRect().toJSON(), z: getComputedStyle(d).zIndex, path: path(d) }));
  const layer = document.querySelector('[data-dsh-fairy-sidebar-layer="true"]');
  const overlayLayer = document.querySelector('[data-dsh-fairy-overlay-layer="true"]');
  return JSON.stringify({
    modalFlag: document.documentElement.hasAttribute('data-dsh-fairy-modal-open'),
    dialogs: info,
    masks: [...document.querySelectorAll('[data-slot="sidebar.settings"] *')].filter(n => getComputedStyle(n).position === 'fixed' || getComputedStyle(n).position === 'absolute').slice(0, 6).map(n => ({ cls: String(n.className).slice(0, 40), rect: n.getBoundingClientRect().toJSON(), z: getComputedStyle(n).zIndex })),
    sidebarLayer: layer ? { z: getComputedStyle(layer).zIndex, isolation: getComputedStyle(layer).isolation, rect: layer.getBoundingClientRect().toJSON() } : null,
    overlayLayer: overlayLayer ? { z: getComputedStyle(overlayLayer).zIndex, rect: overlayLayer.getBoundingClientRect().toJSON() } : null,
    composerCard: (() => { const c = document.querySelector('[data-composer-card="true"]'); return c ? { rect: c.getBoundingClientRect().toJSON(), z: getComputedStyle(c).zIndex, dock: c.closest('[data-dsh-fairy-composer-dock]') ? true : false } : null; })(),
    fairyFlags: { visual: document.documentElement.hasAttribute('data-dsh-fairy-visual'), theme: document.documentElement.getAttribute('data-dsh-fairy-theme') }
  });
})()