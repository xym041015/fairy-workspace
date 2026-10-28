(() => {
  const card = document.querySelector('[data-composer-card="true"]');
  const dock = document.querySelector('[data-dsh-fairy-composer-dock="true"]');
  const material = document.querySelector('[data-dsh-fairy-composer-material="true"]');
  const scroll = document.querySelector('[data-input-scroll]');
  const r = (n) => (n ? [Math.round(n.getBoundingClientRect().x), Math.round(n.getBoundingClientRect().y), Math.round(n.getBoundingClientRect().width), Math.round(n.getBoundingClientRect().height)] : null);
  return JSON.stringify({
    dockAttr: !!dock,
    materialLayer: !!material,
    heroHardware: { voice: !!document.querySelector('[data-dsh-fairy-composer-voice-control="true"]'), scale: !!document.querySelector('[data-dsh-fairy-mascot-scale-base="true"]'), speed: !!document.querySelector('[data-dsh-fairy-mascot-animation-speed-base="true"]') },
    card: r(card), scroll: r(scroll),
    cardStyle: card ? { pos: getComputedStyle(card).position, display: getComputedStyle(card).display, gridCols: getComputedStyle(card).gridTemplateColumns, bg: getComputedStyle(card).backgroundColor, radius: getComputedStyle(card).borderRadius } : null,
    keptFeatures: { hddScrollbarLayer: !!document.querySelector('.dsh-hdd-scrollbar-layer'), historySurface: !!document.querySelector('[data-dsh-fairy-history-surface="true"]'), headerUtilities: !!document.querySelector('[data-dsh-fairy-header-utilities-cluster="true"]'), sidebarLayer: !!document.querySelector('[data-dsh-fairy-sidebar-layer="true"]'), brandMark: !!document.querySelector('.dsh-fairy-mark') },
    chevron: getComputedStyle(document.documentElement).getPropertyValue('--dsh-composer-height')
  }, null, 1);
})()