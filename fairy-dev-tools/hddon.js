(() => {
  const t = [...document.querySelectorAll('[data-slot="conversation.session.header.utilities"] button')].find(b => (b.textContent||'').includes('H.D.D'));
  if (!t) return JSON.stringify({ error: 'no hdd toggle' });
  if (t.dataset.on !== 'true') t.click();
  return JSON.stringify({ on: t.dataset.on, clicked: t.dataset.on !== 'true' });
})()