(() => {
  const card = document.querySelector('[data-composer-card="true"]');
  const cs = card ? getComputedStyle(card) : null;
  const stage = document.querySelector('.dsh-fairy-stage');
  const scs = stage ? getComputedStyle(stage) : null;
  return JSON.stringify({
    modalFlag: document.documentElement.hasAttribute('data-dsh-fairy-modal-open'),
    visual: document.documentElement.hasAttribute('data-dsh-fairy-visual'),
    composerCard: card ? { bg: cs.backgroundColor, bgImage: cs.backgroundImage.slice(0, 40), border: cs.borderTopColor, shadow: cs.boxShadow.slice(0, 30), rect: card.getBoundingClientRect().toJSON() } : null,
    stage: stage ? { display: scs.display, visibility: scs.visibility, opacity: scs.opacity } : null,
    dialogs: [...document.querySelectorAll('[role="dialog"]')].map(d => d.getAttribute('aria-modal'))
  });
})()