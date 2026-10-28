(() => {
  const dlg = [...document.querySelectorAll('[role="dialog"]')].find(d => d.getAttribute('aria-modal') === 'true');
  if (!dlg) return JSON.stringify({ error: 'no modal' });
  const input = dlg.querySelector('input');
  if (!input) return JSON.stringify({ error: 'no input', html: dlg.outerHTML.slice(0, 300) });
  const setter = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value').set;
  setter.call(input, 'sk-0000000000000000000000000000000000000000');
  input.dispatchEvent(new Event('input', { bubbles: true }));
  const save = [...dlg.querySelectorAll('button')].find(b => (b.textContent||'').includes('保存并继续'));
  if (save) save.click();
  return JSON.stringify({ ok: true, hasSave: !!save, type: input.type });
})()