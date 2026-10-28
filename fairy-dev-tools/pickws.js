(() => {
  const card = document.querySelector('[data-composer-card="true"]');
  const trigger = card?.querySelector('[aria-label="选择工作区"]');
  if (trigger) trigger.click();
  return JSON.stringify({ clicked: !!trigger });
})()