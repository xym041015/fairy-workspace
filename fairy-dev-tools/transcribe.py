import sys
from funasr import AutoModel
wav = sys.argv[1]
model = AutoModel(model='iic/SenseVoiceSmall', device='cpu', disable_update=True, hub='ms')
res = model.generate(input=wav, cache={}, language='zh', use_itn=True, batch_size_s=60)
text = res[0]['text'] if res else ''
import re
clean = re.sub(r'<\|[^|]+\|>', '', text).strip()
print('TRANSCRIPT:', clean)
open(sys.argv[2], 'w').write(clean)