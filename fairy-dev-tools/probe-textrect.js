(() => {
  const span = document.querySelector('[data-lexical-text]');
  const out = { spanFound: !!span };
  if (span) {
    const range = document.createRange();
    range.selectNodeContents(span);
    const r = range.getBoundingClientRect();
    const cs = getComputedStyle(span);
    const p = span.closest('p');
    out.textRect = [Math.round(r.x), Math.round(r.y), Math.round(r.width), Math.round(r.height)];
    out.spanStyle = { color: cs.color, fill: cs.webkitTextFillColor, fontSize: cs.fontSize, opacity: cs.opacity, visibility: cs.visibility, display: cs.display, textIndent: cs.textIndent };
    out.pStyle = p ? { color: getComputedStyle(p).color, fill: getComputedStyle(p).webkitTextFillColor, margin: getComputedStyle(p).margin, lineHeight: getComputedStyle(p).lineHeight } : null;
    out.inputRect = document.querySelector('[data-composer-input]').getBoundingClientRect().toJSON();
    out.scrollRect = document.querySelector('[data-input-scroll]').getBoundingClientRect().toJSON();
  }
  return JSON.stringify(out, null, 1);
})()