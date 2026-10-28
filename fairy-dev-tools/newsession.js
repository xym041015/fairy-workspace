(() => {
  const side = document.querySelector('[data-slot="sidebar"]');
  const btns = [...(side?.querySelectorAll('button') || [])].map(b => ({ label: b.getAttribute('aria-label'), text: (b.textContent||'').trim().slice(0,20), slot: b.closest('[data-slot]')?.getAttribute('data-slot'), rect: b.getBoundingClientRect().toJSON() }));
  const allSlots = [...new Set([...document.querySelectorAll('[data-slot]')].map(n => n.getAttribute('data-slot')))];
  const main = document.querySelector('[data-slot="root"]');
  const newBtn = [...(side?.querySelectorAll('button') || [])].find(b => (b.getAttribute('aria-label')||'').includes('新会话') || (b.textContent||'').includes('新会话'));
  if (newBtn) newBtn.click();
  return JSON.stringify({ sidebarButtons: btns.slice(0, 12), slots: allSlots, clickedNew: !!newBtn, treeItems: document.querySelectorAll('[role="treeitem"]').length });
})()