(() => {
  const info = (sel) => { const n = document.querySelector(sel); if (!n) return null; const cs = getComputedStyle(n); const chain = []; let c = n; while (c && c !== document.body && chain.length < 6) { const s = getComputedStyle(c); chain.push({ tag: c.tagName.toLowerCase(), slot: c.dataset?.slot || null, cls: String(c.className).slice(0, 26), z: s.zIndex, pos: s.position, iso: s.isolation, tr: s.transform !== 'none' || s.filter !== 'none' }); c = c.parentElement; } return { rect: n.getBoundingClientRect().toJSON(), z: cs.zIndex, pos: cs.position, chain }; };
  return JSON.stringify({
    stage: info('.dsh-fairy-stage'),
    backgroundHost: info('.dsh-hdd-background-host'),
    overlayLayer: info('[data-dsh-fairy-overlay-layer="true"]'),
    sidebarLayer: info('[data-dsh-fairy-sidebar-layer="true"]'),
    maskRect: (() => { const m = document.querySelector('[data-slot="sidebar.settings"] .VOzbGW_mask') || document.querySelector('[data-slot="sidebar.settings"] [class*="mask"]'); return m ? { rect: m.getBoundingClientRect().toJSON(), z: getComputedStyle(m).zIndex, pos: getComputedStyle(m).position, bg: getComputedStyle(m).backgroundColor, opacity: getComputedStyle(m).opacity, parentIsSidebarCtx: !!m.closest('[data-dsh-fairy-sidebar-layer="true"]') } : null; })(),
    rootZ: (() => { const r = document.querySelector('body > #root'); return r ? { z: getComputedStyle(r).zIndex, pos: getComputedStyle(r).position } : null; })(),
    modalPanelZ: (() => { const p = document.querySelector('[data-slot="sidebar.settings"] [role="dialog"]'); return p ? { z: getComputedStyle(p).zIndex, parentOverlayZ: getComputedStyle(p.parentElement).zIndex, parentOverlayPos: getComputedStyle(p.parentElement).position } : null; })()
  });
})()