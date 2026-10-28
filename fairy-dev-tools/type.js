(() => {
  const ta = document.querySelector('[data-composer-card="true"] textarea');
  if (!ta) return JSON.stringify({ error: 'no textarea', composer: !!document.querySelector('[data-composer-card="true"]') });
  const setter = Object.getOwnPropertyDescriptor(HTMLTextAreaElement.prototype, 'value').set;
  setter.call(ta, '布局探针 layout probe');
  ta.dispatchEvent(new Event('input', { bubbles: true }));
  ta.focus();
  return JSON.stringify({ ok: true, value: ta.value, buttons: [...document.querySelectorAll('[data-composer-card="true"] button')].map(b => ({ label: b.getAttribute('aria-label'), cls: b.className.slice(0,40), dis: b.disabled })) });
})()