(() => {
  window.dispatchEvent(new CustomEvent('fairy-voice-play', { detail: { messageId: 'probe-final-1', markdown: '这是一次语音播放探针，用来确认朗读链路是否出声。', sessionKey: 'session-9b5e6fd5-a2fb-45f1-994c-cf83498133d8' } }));
  return JSON.stringify({ dispatched: true });
})()