(() => {
  const input = document.querySelector('[data-composer-input]');
  const span = input ? input.querySelector('span') : null;
  const ph = document.querySelector('[data-composer-placeholder]');
  const theme = document.documentElement.getAttribute('data-dsh-fairy-theme');
  return JSON.stringify({
    theme,
    rootColor: getComputedStyle(document.documentElement).color,
    bodyColor: getComputedStyle(document.body).color,
    inputColor: input ? getComputedStyle(input).color : null,
    spanColor: span ? getComputedStyle(span).color : null,
    placeholderColor: ph ? getComputedStyle(ph).color : null,
    inputFontSize: input ? getComputedStyle(input).fontSize : null,
    substrateVar: getComputedStyle(document.documentElement).getPropertyValue('--dsh-input-substrate'),
    scrollBg: getComputedStyle(document.querySelector('[data-input-scroll]')).backgroundColor,
    lexical: !!document.querySelector('[data-lexical-text]')
  }, null, 1);
})()