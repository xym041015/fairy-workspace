(() => {
  const trigger = [...document.querySelectorAll('[data-slot="sidebar.settings"] button')].find(b => (b.getAttribute('aria-label')||'') === '设置');
  if (trigger) trigger.click();
  return JSON.stringify({ opened: !!trigger });
})()