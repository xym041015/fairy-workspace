import pathlib
p = pathlib.Path("/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/Fairy-DSH/fairy-voice/dsh-fairy-voice") / "lib/client.js"
s = p.read_text()
trace = "window.__fairyTrace = window.__fairyTrace || []; window.__fairyTrace.push('a:enter');"
old = "      const readLatest = React.useCallback(() => {\n        if (!engineAvailable) return;"
assert old in s, "anchor"
new = ("      const readLatest = React.useCallback(() => {\n"
       "        window.__fairyTrace = window.__fairyTrace || []; window.__fairyTrace.push('a:enter', 'engine=' + engineAvailable, 'status=' + state.status, 'msgs=' + (snapshot.messagesById ? snapshot.messagesById.size : -1));\n"
       "        if (!engineAvailable) return;")
s = s.replace(old, new, 1)
old2 = "        primeAudio(audibleVolume).catch((error) => reportAudioLifecycleFailure('prime', error));"
assert old2 in s
s = s.replace(old2, "        window.__fairyTrace.push('b:prime', 'vol=' + audibleVolume);\n" + old2 + "\n        window.__fairyTrace.push('c:primed');", 1)
old3 = "        if (!latest || !latest.markdown) return;"
assert old3 in s
s = s.replace(old3, "        window.__fairyTrace.push('d:latest=' + (latest ? latest.id : 'none'));\n" + old3, 1)
p.write_text(s)
print("trace points added")