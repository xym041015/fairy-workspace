(() => {
  const q = (s) => document.querySelector(s);
  const qa = (s) => [...document.querySelectorAll(s)];
  const rect = (el) => { if (!el) return null; const r = el.getBoundingClientRect(); return { x: Math.round(r.x), y: Math.round(r.y), w: Math.round(r.width), h: Math.round(r.height) }; };
  const vis = (el) => { if (!el) return null; const cs = getComputedStyle(el); return { display: cs.display, visibility: cs.visibility, opacity: cs.opacity, zIndex: cs.zIndex, position: cs.position }; };

  const out = {
    // HDD core surfaces
    hdd: {
      stage: rect(q('[data-dsh-fairy-stage]')) || rect(q('.dsh-fairy-stage')),
      materialLayers: qa('[data-dsh-fairy-material]').length,
      materialLayerRects: qa('[data-dsh-fairy-material]').slice(0, 6).map(rect),
      scrollbarLayer: rect(q('.dsh-hdd-scrollbar-layer')),
      historySurface: rect(q('[data-dsh-fairy-history-surface]')),
      headerCluster: rect(q('[data-dsh-fairy-header-utilities-cluster]')),
      brandMark: rect(q('[data-dsh-fairy-brand]')),
      sidebarPlates: qa('[data-dsh-fairy-sidebar-plate]').length,
      composerDock: rect(q('[data-dsh-fairy-composer-dock]')),
      voiceControls: rect(q('[data-dsh-fairy-voice-controls]')),
      anyFairyAttr: qa('[data-dsh-fairy]').map((e) => e.getAttribute('data-dsh-fairy')).slice(0, 20),
    },
    // official composer (should be native since dock off)
    composer: {
      inputCard: rect(q('[data-composer-input]')) || rect(q('[data-slot$="composer"] textarea')?.closest('[class*="card"]')),
      inputScroll: rect(q('[data-input-scroll]')),
      composerSlot: rect(q('[data-composer-seat]')),
    },
    // conversation roots
    roots: {
      oldConversation: !!q('[data-slot="conversation"]'),
      newConversation: !!q('[data-slot="main.conversation"]'),
      settingsDialog: !!q('[data-slot="sidebar.settings"] [role="dialog"]'),
      anyModal: !!q('[role="dialog"][aria-modal="true"]'),
    },
    // skin / other plugins that may fight with HDD
    eco: {
      skinImg: qa('img.dshwv-img').map(rect),
      pet: rect(q('[data-slot="pet"]')) || rect(q('#dsh-pet')),
      betterSidebar: !!q('[data-better-sidebar]'),
    },
    body: { bg: getComputedStyle(document.body).background.slice(0, 160) },
    fairyGlobals: Object.keys(window).filter((k) => k.toLowerCase().includes('fairy')).slice(0, 10),
  };
  return out;
})()
