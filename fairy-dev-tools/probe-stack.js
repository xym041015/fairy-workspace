(() => {
  const els = document.elementsFromPoint(1450, 900).slice(0, 8).map((el) => ({ tag: el.tagName.toLowerCase(), cls: String(el.className || '').slice(0, 34), pe: getComputedStyle(el).pointerEvents, z: getComputedStyle(el).zIndex, pos: getComputedStyle(el).position }));
  const els2 = document.elementsFromPoint(1400, 860).slice(0, 8).map((el) => ({ tag: el.tagName.toLowerCase(), cls: String(el.className || '').slice(0, 34), pe: getComputedStyle(el).pointerEvents, z: getComputedStyle(el).zIndex }));
  return JSON.stringify({ at_1450_900: els, at_1400_860: els2 }, null, 1);
})()