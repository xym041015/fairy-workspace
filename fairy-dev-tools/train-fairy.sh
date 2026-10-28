#!/usr/bin/env bash
# Fairy 音色微调驱动(无头复刻 GPT-SoVITS webui 的开放数据集管线)。
# 用法: bash train-fairy.sh <epochs_sovits> <epochs_gpt> [batch]
# 依赖: dataset/clips/*.wav + dataset/clips/*.txt(SenseVoice 转写)+ dataset/fairy.list
set -euo pipefail
L="$HOME/Library/Application Support/fairy-tts"
G="$L/GPT-SoVITS"
EXP=fairy-zh
EPOCHS_S2=${1:-8}
EPOCHS_S1=${2:-6}
BATCH=${3:-2}
cd "$G"
export HOME="$L/home" MODELSCOPE_CACHE="$L/ms-cache" PYTHONPATH="$G:$G/GPT_SoVITS"
export exp_name=$EXP opt_dir="logs/$EXP" i_part=0 all_parts=1 _CUDA_VISIBLE_DEVICES="" is_half=False version=v2 hz=25hz
export bert_pretrained_dir="$G/GPT_SoVITS/pretrained_models/chinese-roberta-wwm-ext-large"
export cnhubert_base_dir="$G/GPT_SoVITS/pretrained_models/chinese-hubert-base"
export pretrained_s2G="$G/GPT_SoVITS/pretrained_models/gsv-v2final-pretrained/s2G2333k.pth"
export pretrained_s2D="$G/GPT_SoVITS/pretrained_models/gsv-v2final-pretrained/s2D2333k.pth"
export pretrained_s1="$G/GPT_SoVITS/pretrained_models/gsv-v2final-pretrained/s1bert25hz-5kh-longer-epoch=12-step=369668.ckpt"
export s2config_path="$G/GPT_SoVITS/configs/s2.json" s1config_path="$G/GPT_SoVITS/configs/s1longer-v2.yaml"
export inp_wav_dir=""
export inp_text="$L/dataset/fairy.list"
PY=".venv/bin/python"
INP_TEXT="$L/dataset/fairy.list"

echo "== [1/6] 文本分词与特征提取 (1-get-text) =="
$PY GPT_SoVITS/prepare_datasets/1-get-text.py 2>&1 | tail -2
cat logs/$EXP/2-name2text-*.txt > logs/$EXP/2-name2text.txt
[ -s "logs/$EXP/2-name2text.txt" ] && echo "OK 2-name2text.txt"

echo "== [2/6] Hubert 特征 + 32k wav (2-get-hubert-wav32k) =="
$PY GPT_SoVITS/prepare_datasets/2-get-hubert-wav32k.py 2>&1 | tail -2
[ -d "logs/$EXP/5-wav32k" ] && echo "OK 5-wav32k"

echo "== [3/6] 语义 token (3-get-semantic) =="
$PY GPT_SoVITS/prepare_datasets/3-get-semantic.py 2>&1 | tail -2
cat logs/$EXP/6-name2semantic-*.tsv > logs/$EXP/6-name2semantic.tsv
[ -s "logs/$EXP/6-name2semantic.tsv" ] && echo "OK 6-name2semantic.tsv"

mkdir -p "logs/$EXP/logs_s2_v2" "logs/$EXP/logs_s1_v2"
echo "== [4/6] SoVITS 微调 ($EPOCHS_S2 epochs, batch $BATCH) =="
$PY - "$BATCH" "$EPOCHS_S2" << 'PY'
import json, sys
batch, epochs = int(sys.argv[1]), int(sys.argv[2])
data = json.load(open('GPT_SoVITS/configs/s2.json'))
data['train'].update({'fp16_run': False, 'batch_size': batch, 'epochs': epochs,
    'if_save_latest': True, 'if_save_every_weights': True, 'save_every_epoch': 1,
    'gpu_numbers': '0', 'grad_ckpt': True, 'text_low_lr_rate': 0.4,
    'pretrained_s2G': __import__('os').environ['pretrained_s2G'],
    'pretrained_s2D': __import__('os').environ['pretrained_s2D']})
data['model']['version'] = 'v2'
data['data']['exp_dir'] = data['s2_ckpt_dir'] = 'logs/fairy-zh'
data['save_weight_dir'] = 'SoVITS_weights_v2'
data['name'] = 'fairy-zh'
data['version'] = 'v2'
json.dump(data, open('tmp_s2.json', 'w'))
print('tmp_s2.json written')
PY
$PY -s GPT_SoVITS/s2_train.py --config tmp_s2.json 2>&1 | tail -4

echo "== [5/6] GPT(AR) 微调 ($EPOCHS_S1 epochs) =="
$PY - "$EPOCHS_S1" << 'PY'
import yaml, sys, os
epochs = int(sys.argv[1])
data = yaml.safe_load(open('GPT_SoVITS/configs/s1longer-v2.yaml'))
data['train'].update({'precision': '32', 'batch_size': max(1, int(os.environ.get('BATCH_S1', 1))), 'epochs': epochs,
    'if_save_latest': True, 'if_save_every_weights': True, 'save_every_epoch': 1,
    'if_dpo': False, 'exp_name': 'fairy-zh'})
data['pretrained_s1'] = os.environ['pretrained_s1']
data['train_semantic_path'] = 'logs/fairy-zh/6-name2semantic.tsv'
data['train_phoneme_path'] = 'logs/fairy-zh/2-name2text.txt'
data['output_dir'] = 'logs/fairy-zh/logs_s1_v2'
data['half_weights_save_dir'] = 'GPT_weights_v2'
open('tmp_s1.yaml', 'w').write(yaml.dump(data, default_flow_style=False, allow_unicode=True))
print('tmp_s1.yaml written')
PY
$PY -s GPT_SoVITS/s1_train.py --config_file tmp_s1.yaml 2>&1 | tail -4

echo "== [6/6] 产物 =="
ls -la SoVITS_weights_v2/*.pth GPT_weights_v2/*.ckpt 2>/dev/null | tail -4
echo "DONE"
