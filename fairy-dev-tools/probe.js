(() => {
  const toggles = [...document.querySelectorAll('.dsh-fairy-toggle, .dsh-fairy-mark')].map(b => ({ tag: b.tagName, cls: b.className, text: (b.textContent||'').trim().slice(0,30), on: b.dataset.on, disabled: !!b.disabled, rect: b.getBoundingClientRect().toJSON() }));
  const r = document.documentElement;
  return JSON.stringify({
    href: location.href.slice(0, 60),
    flags: { fairy: r.hasAttribute('data-dsh-fairy-visual'), theme: r.getAttribute('data-dsh-fairy-theme'), modal: r.hasAttribute('data-dsh-fairy-modal-open') },
    slots: { root: !!document.querySelector('[data-slot="root"]'), sidebar: !!document.querySelector('[data-slot="sidebar"]'), settings: !!document.querySelector('[data-slot="sidebar.settings"]'), overlay: !!document.querySelector('[data-slot="shell.overlay"]'), conversation: !!document.querySelector('[data-slot="conversation"]') },
    phases: [...document.querySelectorAll('[data-phase]')].map(n => n.getAttribute('data-phase')),
    toggles,
    docks: [...document.querySelectorAll('[data-dsh-fairy-composer-dock]')].length
  });
})()