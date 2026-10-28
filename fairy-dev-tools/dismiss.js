(() => {
  const btns = [...document.querySelectorAll('button')];
  const later = btns.find(b => (b.textContent||'').includes('稍后配置'));
  if (later) later.click();
  return JSON.stringify({
    clicked: !!later,
    dialogs: [...document.querySelectorAll('[role="dialog"]')].map(d => ({ slot: d.closest('[data-slot]')?.getAttribute('data-slot'), label: d.getAttribute('aria-label'), modal: d.getAttribute('aria-modal'), rect: d.getBoundingClientRect().toJSON() })),
    composer: (() => {
      const card = document.querySelector('[data-composer-card="true"]');
      if (!card) return null;
      return { textarea: !!card.querySelector('textarea'), editable: !!card.querySelector('[contenteditable="true"]'), rect: card.getBoundingClientRect().toJSON(), seatPhase: card.closest('[data-phase]')?.getAttribute('data-phase'), dockAttr: card.closest('[data-dsh-fairy-composer-dock]')?.getAttribute('data-dsh-fairy-composer-dock') };
    })()
  });
})()