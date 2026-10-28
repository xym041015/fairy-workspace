(() => {
  const btns = [...document.querySelectorAll('button')];
  const close = btns.find(b => (b.getAttribute('aria-label')||'').includes('关闭') || (b.textContent||'').trim() === '关闭');
  const esc = new KeyboardEvent('keydown', { key: 'Escape', code: 'Escape', keyCode: 27, bubbles: true });
  document.dispatchEvent(esc);
  const toggle = btns.find(b => (b.textContent||'').trim().includes('H.D.D') && b.closest('[data-slot="conversation.session.header.utilities"]'));
  return JSON.stringify({ closeLabel: close ? close.getAttribute('aria-label') : null, hddToggle: !!toggle, hddOn: toggle ? toggle.dataset.on : null });
})()