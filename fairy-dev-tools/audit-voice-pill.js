(() => {
  const qa = (s) => [...document.querySelectorAll(s)];
  const describe = (el) => {
    if (!el) return null;
    const cs = getComputedStyle(el);
    const r = el.getBoundingClientRect();
    return {
      tag: el.tagName.toLowerCase(),
      id: el.id || undefined,
      cls: (el.className && String(el.className)).slice(0, 120),
      attrs: [...el.attributes].map((a) => `${a.name}=${a.value.slice(0, 40)}`).slice(0, 12),
      rect: { x: Math.round(r.x), y: Math.round(r.y), w: Math.round(r.width), h: Math.round(r.height) },
      bg: cs.backgroundColor, color: cs.color, radius: cs.borderRadius, border: cs.border,
      title: el.title || undefined, ariaLabel: el.getAttribute('aria-label') || undefined,
      text: (el.textContent || '').trim().slice(0, 60) || undefined,
    };
  };
  const voiceEls = qa('[data-dsh-fairy-voice-auto], [data-dsh-fairy-play-control], [class*="fairy-voice"], [id*="fairy-voice"]');
  const playBtn = qa('[data-dsh-fairy-play-control]')[0];
  const container = playBtn ? playBtn.parentElement.parentElement : null;
  return {
    voiceEls: voiceEls.map(describe),
    container: describe(container),
    containerChildren: container ? [...container.children].map(describe) : null,
    // the pill: find the bordered parent of voice controls
    pill: describe(container?.parentElement),
  };
})()
