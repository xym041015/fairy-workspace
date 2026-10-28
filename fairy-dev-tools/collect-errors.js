(() => {
  const errs = [];
  const orig = console.error;
  // just read performance + any error overlay
  return JSON.stringify({
    dshErrors: (window.__dshErrors || []).length || null,
    overlays: [...document.querySelectorAll('[class*="error-overlay"],[class*="ErrorOverlay"]')].length,
  });
})()
