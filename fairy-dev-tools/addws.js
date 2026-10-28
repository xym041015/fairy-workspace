(() => {
  const btn = [...document.querySelectorAll('[data-slot="sidebar"] button')].find(b => (b.getAttribute('aria-label')||'') === '添加工作区');
  if (btn) btn.click();
  return JSON.stringify({ clicked: !!btn });
})()