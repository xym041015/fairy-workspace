(() => {
  const seat = document.querySelector('[data-composer-seat]');
  const card = document.querySelector('[data-composer-card="true"]');
  const dock = document.querySelector('[data-dsh-fairy-composer-dock="true"]');
  const marked = [...document.querySelectorAll('[data-dsh-fairy-composer-seat],[data-dsh-fairy-composer-dock],[data-dsh-fairy-composer-material],[data-dsh-fairy-composer-row],[data-dsh-fairy-composer-tools]')].map(n => n.getAttributeNames().filter(a => a.startsWith('data-dsh-fairy')).join('+') + '@' + JSON.stringify(n.getBoundingClientRect().toJSON()));
  return JSON.stringify({
    conversationRoots: { legacy: !!document.querySelector('[data-slot="conversation"]'), renamed: !!document.querySelector('[data-slot="main.conversation"]') },
    seatMarked: !!document.querySelector('[data-dsh-fairy-composer-seat="true"]'),
    dockPresent: !!dock,
    dockRect: dock ? dock.getBoundingClientRect().toJSON() : null,
    dockVis: dock ? getComputedStyle(dock).visibility : null,
    cardRect: card ? card.getBoundingClientRect().toJSON() : null,
    marks: marked.slice(0, 8),
    modalFlag: document.documentElement.hasAttribute('data-dsh-fairy-modal-open'),
    scrollbarLayer: !!document.querySelector('.dsh-hdd-scrollbar-layer'),
    markers: ['data-dsh-fairy-header-utilities-cluster', 'data-dsh-fairy-history-surface', 'data-dsh-fairy-sidebar-layer', 'data-dsh-fairy-background-surface'].map((a) => a + '=' + !!document.querySelector('[' + a + ']'))
  });
})()