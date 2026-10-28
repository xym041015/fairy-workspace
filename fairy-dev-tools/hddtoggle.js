(() => {
  const t = [...document.querySelectorAll('[data-slot="conversation.session.header.utilities"] button')].find(b => (b.textContent||'').includes('H.D.D'));
  if (t) t.click();
  return JSON.stringify({ clicked: !!t, on: t ? t.dataset.on : null });
})()