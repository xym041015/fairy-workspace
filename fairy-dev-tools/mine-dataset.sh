#!/usr/bin/env bash
# 密集切片:按静音边界把 fairy_src.wav 切成 3-10s 训练片段,响度归一。
set -euo pipefail
cd "$HOME/Library/Application Support/fairy-tts"
SRC="GPT_SoVITS/../../../fairy_src.wav"
mkdir -p dataset/clips
# 1) 完整静音图
ffmpeg -v info -y -i fairy_src.wav -af silencedetect=noise=-32dB:d=0.30 -f null - 2> /tmp/silence.txt
# 2) 解析出语音区间,合并到 3-10s
python3 - << 'PY'
import re, subprocess, os
log = open('/tmp/silence.txt', encoding='utf-8', errors='replace').read()
starts = [float(x) for x in re.findall(r'silence_start: ([\d.]+)', log)]
ends   = [float(x) for x in re.findall(r'silence_end: ([\d.]+)', log)]
total = float(subprocess.check_output(['ffprobe','-v','error','-show_entries','format=duration','-of','default=nw=1:nk=1','fairy_src.wav']).decode().strip())
# 语音区间 = 相邻静音之间
speech = []
prev = 0.0
for s in starts:
    if s - prev > 0.25: speech.append((prev, s))
    prev = (ends[starts.index(s)] if starts.index(s) < len(ends) else s)
if total - prev > 0.25: speech.append((prev, total))
# 合并相邻短间隙(<0.6s)直到 3-10s
clips = []
cur = None
for a, b in speech:
    if cur is None: cur = [a, b]; continue
    if a - cur[1] < 0.6 and (b - cur[0]) <= 10.0: cur[1] = b
    else:
        clips.append(cur); cur = [a, b]
if cur: clips.append(cur)
clips = [(a, b) for a, b in clips if 2.5 <= b - a <= 10.5]
os.makedirs('dataset/clips', exist_ok=True)
for i, (a, b) in enumerate(clips):
    out = f'dataset/clips/clip_{i:02d}.wav'
    subprocess.run(['ffmpeg','-v','error','-y','-ss',f'{a:.2f}','-t',f'{b-a:.2f}','-i','fairy_src.wav',
                    '-ac','1','-ar','32000','-af','loudnorm=I=-18:TP=-2',out], check=True)
    print(f'clip_{i:02d}: {a:.2f}s -> {b:.2f}s ({b-a:.2f}s)')
print(f'TOTAL: {len(clips)} clips, {sum(b-a for a,b in clips):.1f}s speech')
PY
