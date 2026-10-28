(() => {
  const q = (s) => document.querySelector(s);
  const snap = (label) => ({
    state: label,
    suiteAttr: document.documentElement.hasAttribute('data-dsh-fairy-suite'),
    balanceText: document.body.innerText.includes('今日估算'),
    voicePill: !!q('[data-dsh-fairy-voice-control]'),
    hddToggle: !!q('.dsh-fairy-toggle'),
  });
  const wait = (ms) => new Promise((r) => setTimeout(r, ms));
  return (async () => {
    const out = [snap('ON')];
    q('.dsh-fairy-toggle')?.click();
    await wait(900);
    out.push(snap('OFF'));
    q('.dsh-fairy-toggle')?.click();
    await wait(900);
    out.push(snap('ON-back'));
    return out;
  })();
})()
