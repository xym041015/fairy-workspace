(() => {
  const dlg = [...document.querySelectorAll('[role="dialog"]')].find(d => (d.getAttribute('aria-label')||'').includes('API Key'));
  if (!dlg) return JSON.stringify({ error: 'no key dialog' });
  const input = dlg.querySelector('input');
  const setter = Object.getOwnPropertyDescriptor(HTMLInputElement.prototype, 'value').set;
  setter.call(input, 'sk-1234567890abcdef1234567890abcdef');
  input.dispatchEvent(new Event('input', { bubbles: true }));
  const save = [...dlg.querySelectorAll('button')].find(b => (b.textContent||'').includes('保存并继续'));
  if (save) save.click();
  return JSON.stringify({ ok: true, value: input.value.slice(0, 8) + '…' });
})()