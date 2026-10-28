import pathlib
p = pathlib.Path('/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/GPT-SoVITS/GPT_SoVITS/configs/tts_infer.yaml')
s = p.read_text()
s = s.replace('  device: cpu' + chr(10) + '  is_half: false', '  device: mps' + chr(10) + '  is_half: false')
p.write_text(s)
print([l for l in s.splitlines() if 'device' in l or 'is_half' in l][:4])