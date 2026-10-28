(() => {
  const pts = [[1450, 880], [1420, 900], [1480, 860]];
  const seen = [];
  for (const [x, y] of pts) { const el = document.elementFromPoint(x, y); if (!el) continue; const chain = []; let c = el; while (c && chain.length < 5) { chain.push(c.tagName.toLowerCase() + '.' + String(c.className || '').slice(0, 30) + (c.getAttribute && c.getAttribute('data-dsh-skin') ? '[skin]' : '')); c = c.parentElement; } seen.push({ x, y, chain }); }
  return JSON.stringify(seen, null, 1);
})()