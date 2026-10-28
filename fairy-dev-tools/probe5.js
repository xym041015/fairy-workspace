(() => {
  const r = document.documentElement;
  const attrs = {}; for (const a of r.attributes) attrs[a.name] = a.value.slice(0, 60);
  const marked = [...document.querySelectorAll('[data-dsh-fairy-sidebar-layer],[data-dsh-fairy-composer-seat],[data-dsh-fairy-composer-dock],[data-dsh-fairy-overlay-layer],[data-dsh-fairy-history-surface],[data-dsh-fairy-composer-seat]')].map(n => n.getAttributeNames().filter(a => a.startsWith('data-dsh-fairy')).join(','));
  return JSON.stringify({ rootAttrs: attrs, marks: marked, composerCard: !!document.querySelector('[data-composer-card="true"]'), seat: !!document.querySelector('[data-composer-seat]'), inputScroll: !!document.querySelector('[data-input-scroll]'), conversationSlot: !!document.querySelector('[data-slot="conversation"]'), mainConversationSlot: !!document.querySelector('[data-slot="main.conversation"]') });
})()