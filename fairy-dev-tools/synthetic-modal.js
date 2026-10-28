(async () => {
  const before = document.documentElement.hasAttribute('data-dsh-fairy-modal-open');
  const fake = document.createElement('div');
  fake.setAttribute('role', 'dialog');
  fake.setAttribute('aria-modal', 'true');
  fake.setAttribute('aria-label', 'synthetic probe modal');
  document.body.appendChild(fake);
  await new Promise((r) => setTimeout(r, 400));
  const during = document.documentElement.hasAttribute('data-dsh-fairy-modal-open');
  const cardDuring = getComputedStyle(document.querySelector('[data-composer-card="true"]')).visibility;
  fake.remove();
  await new Promise((r) => setTimeout(r, 400));
  const after = document.documentElement.hasAttribute('data-dsh-fairy-modal-open');
  const cardAfter = getComputedStyle(document.querySelector('[data-composer-card="true"]')).visibility;
  return JSON.stringify({ before, during, after, cardDuring, cardAfter, pass: !before && during && !after && cardDuring === 'hidden' && cardAfter === 'visible' });
})()