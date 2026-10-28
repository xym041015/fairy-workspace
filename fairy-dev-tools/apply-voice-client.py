import pathlib

base = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice")
p = base / "lib/client.js"
s = p.read_text()

signature_old = "    function VoiceController({ useSession, sessionId }) {"
assert signature_old in s, "signature"
s = s.replace(signature_old, "    function VoiceController({ useSession, sessionId, useChat }) {", 1)

anchor = "      const engineAvailable = engine === 'system' || availability.available;"
assert s.count(anchor) == 1, "engineAvailable"
read_latest = r'''      // Manual read-now: one click unlocks the audio device inside the user
      // gesture, guarantees an audible volume, and replays the newest settled
      // answer instead of only arming automatic playback for later turns.
      const readLatest = React.useCallback(() => {
        if (!engineAvailable) return;
        if (state.status === 'playing') { stop(); return; }
        if (!autoRead) setAutoRead(true);
        const audibleVolume = volume > 0.05 ? volume : 1;
        if (audibleVolume !== volume) { setVolume(audibleVolume); setOutputVolume(audibleVolume); }
        primeAudio(audibleVolume).catch((error) => reportAudioLifecycleFailure('prime', error));
        const settled = snapshot.messagesById ? [...snapshot.messagesById.values()] : [];
        const latest = settled.length ? settled[settled.length - 1] : null;
        if (!latest || !latest.markdown) return;
        window.dispatchEvent(new CustomEvent(EVENT_PLAY, { detail: { messageId: latest.id, markdown: latest.markdown, sessionKey } }));
      }, [autoRead, engineAvailable, primeAudio, sessionKey, setOutputVolume, snapshot, state.status, stop, volume]);'''
s = s.replace(anchor, anchor + "\n" + read_latest, 1)

group = "      return jsx.jsxs('span', { className: 'dsh-fairy-voice-controls', role: 'group', 'aria-label': 'Fairy 朗读控制', [FAIRY_VOICE_CONTROL_ATTRIBUTE]: 'true', children: ["
assert group in s, "group"
play_button = r'''        jsx.jsx(Tooltip, { label: state.status === 'playing' ? '停止朗读' : '朗读当前回答', children: jsx.jsx('button', { type: 'button', className: 'dsh-fairy-voice-auto', 'data-dsh-fairy-play-control': 'true', 'data-on': state.status === 'playing' ? 'true' : 'false', disabled: !engineAvailable, onClick: readLatest, 'aria-label': state.status === 'playing' ? '停止朗读' : '朗读当前回答', children: state.status === 'playing' ? jsx.jsx(IconStopFill16, {}) : jsx.jsx(IconPlayOutline16, {}) }) }),'''
s = s.replace(group, group + "\n" + play_button, 1)

snapshot_old = "      const snapshot = useSession(readVoiceTimeline);"
assert snapshot_old in s, "snapshot"
snapshot_new = r'''      // The session snapshot no longer carries the chat projection in this DSH
      // layout; the composer slot injects useChat for it. Merge both so the
      // timeline selector keeps one contract across DSH generations.
      const sessionSnapshot = useSession((state) => state);
      const chatSnapshot = typeof useChat === 'function' ? useChat((state) => state) : null;
      const snapshot = readVoiceTimeline({ ...sessionSnapshot, chat: chatSnapshot || undefined });'''
s = s.replace(snapshot_old, snapshot_new, 1)

p.write_text(s)
print("client rebuilt with the three intended changes")
