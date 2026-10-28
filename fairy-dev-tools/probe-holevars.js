(() => {
  const card = document.querySelector('[data-composer-card="true"]');
  const cs = getComputedStyle(card);
  const after = getComputedStyle(card, '::after');
  const vars = {};
  for (const name of ['--dsh-fairy-composer-hole-contact-left','--dsh-fairy-composer-hole-contact-top','--dsh-fairy-composer-hole-contact-width','--dsh-fairy-composer-hole-contact-height','--dsh-fairy-composer-hole-top','--dsh-fairy-composer-hole-bottom','--dsh-fairy-composer-hole-left','--dsh-fairy-composer-hole-right']) vars[name] = cs.getPropertyValue(name) || '(unset)';
  return JSON.stringify({
    attachmentsActive: card.getAttribute('data-dsh-fairy-composer-attachments-active'),
    vars,
    after: { content: after.content, position: after.position, zIndex: after.zIndex, left: after.left, top: after.top, width: after.width, height: after.height, background: after.backgroundColor, bgImage: after.backgroundImage.slice(0, 60), pointerEvents: after.pointerEvents },
    inlineVarsOnCard: card.getAttribute('style')
  }, null, 1);
})()