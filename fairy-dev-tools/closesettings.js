(() => {
  // close the settings dialog first
  const dlg = [...document.querySelectorAll('[role="dialog"]')].pop();
  const closeBtn = dlg ? [...dlg.querySelectorAll('button')].find(b => (b.getAttribute('aria-label')||'').includes('关闭')) : null;
  if (closeBtn) closeBtn.click();
  return JSON.stringify({ closed: !!closeBtn });
})()