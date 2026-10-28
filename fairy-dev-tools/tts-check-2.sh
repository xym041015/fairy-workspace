set -e
cd "/Users/xuzhouping/Desktop/开发者/fairy deepseek开发/fairy-dev-tools/tts/GPT-SoVITS" </dev/null
echo "=== scipy.signal 完整报错 ==="
.venv/bin/python -c "import scipy.signal" 2>&1 | tail -8
echo "=== scipy 版本/文件 ==="
.venv/bin/python -c "import scipy, os; print(scipy.__version__, os.path.dirname(scipy.__file__))" 2>&1 | tail -3
echo "=== 架构检查 ==="
file .venv/bin/python | head -2
.venv/bin/python -c "import platform; print(platform.machine(), platform.python_version())"
echo "=== torch 能否导入 ==="
.venv/bin/python -c "import torch; print('torch', torch.__version__, 'mps', torch.backends.mps.is_available())" 2>&1 | tail -3