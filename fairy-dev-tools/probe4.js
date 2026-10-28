(() => {
  const card = document.querySelector('[data-composer-card="true"]');
  if (!card) return JSON.stringify({ error: 'no composer card' });
  const ed = [...card.querySelectorAll('textarea, input, [contenteditable]')].map(n => ({ tag: n.tagName, type: n.type || null, ce: n.getAttribute('contenteditable'), dis: n.disabled, ph: n.getAttribute('placeholder') }));
  return JSON.stringify({
    html: card.outerHTML.slice(0, 1500),
    editors: ed,
    keyConfiguredHint: document.body.innerText.includes('API Key')
  });
})()