(() => {
  const dlg = [...document.querySelectorAll('[role="dialog"]')].pop();
  const nav = [...dlg.querySelectorAll('button, [role="tab"], li, a')].filter(n => (n.textContent||'').includes('HDD'));
  const target = nav[0];
  if (target) target.click();
  return JSON.stringify({ found: nav.map(n => (n.textContent||'').trim().slice(0, 24)), clicked: !!target });
})()