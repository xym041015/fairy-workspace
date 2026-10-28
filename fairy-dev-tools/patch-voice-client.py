import pathlib, re
p = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/client.js"
s = p.read_text()

# 1) insert the read-now callback after engineAvailable
anchor = "      const engineAvailable = engine === 'system' || availability.available;"
assert s.count(anchor) == 1, ("engineAvailable anchor", s.count(anchor))
callback = (anchor + "\n" + "\n".join([
  "      // Manual read-now: the composer control guarantees audible feedback for",
  "      // the newest settled answer instead of only arming automatic playback.",
  "      const readLatest = React.useCallback(() => {",
  "        if (!engineAvailable) return;",
  "        if (state.status === 'playing') { stop(); return; }",
  "        if (!autoRead) setAutoRead(true);",
  "        const settled = snapshot.messagesById ? [...snapshot.messagesById.values()] : [];",
  "        const latest = settled.length ? settled[settled.length - 1] : null;",
  "        if (!latest || !latest.markdown) return;",
  "        window.dispatchEvent(new CustomEvent(EVENT_PLAY, { detail: { messageId: latest.id, markdown: latest.markdown, sessionKey } }));",
  "      }, [autoRead, engineAvailable, sessionKey, snapshot, state.status, stop]);",
]))
s = s.replace(anchor, callback, 1)

# 2) insert the play button into the control group
group = "      return jsx.jsxs('span', { className: 'dsh-fairy-voice-controls', role: 'group', 'aria-label': 'Fairy 朗读控制', [FAIRY_VOICE_CONTROL_ATTRIBUTE]: 'true', children: ["
assert group in s, "group anchor"
button = (group + "\n"
  "        jsx.jsx(Tooltip, { label: state.status === 'playing' ? '停止朗读' : '朗读当前回答', children: jsx.jsx('button', { type: 'button', className: 'dsh-fairy-voice-auto', 'data-dsh-fairy-play-control': 'true', 'data-on': state.status === 'playing' ? 'true' : 'false', disabled: !engineAvailable, onClick: readLatest, 'aria-label': state.status === 'playing' ? '停止朗读' : '朗读当前回答', children: state.status === 'playing' ? jsx.jsx(IconStopFill16, {}) : jsx.jsx(IconPlayOutline16, {}) }) }),")
s = s.replace(group, button, 1)
p.write_text(s)
print("client patched: read-now control added")