(() => {
  const dlg = [...document.querySelectorAll('[role="dialog"]')].pop();
  const labels = [...dlg.querySelectorAll('label')];
  const enable = labels.find(l => (l.textContent||'').includes('启用 HDD'));
  const box = enable?.querySelector('input[type="checkbox"]');
  const before = box ? box.checked : null;
  if (box && !box.checked) box.click();
  return JSON.stringify({ labels: labels.map(l => (l.textContent||'').trim().slice(0, 20)), before, after: box ? box.checked : null });
})()