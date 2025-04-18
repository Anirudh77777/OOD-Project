#!/bin/bash
# sh scripts/osr/arpl/cifar10_test_ood_arpl.sh

# GPU=1
# CPU=1
# node=73
# jobname=openood

# PYTHONPATH='.':$PYTHONPATH \
# srun -p dsta --mpi=pmi2 --gres=gpu:${GPU} -n1 \
# --cpus-per-task=${CPU} --ntasks-per-node=${GPU} \
# --kill-on-bad-exit=1 --job-name=${jobname} -w SG-IDC1-10-51-2-${node} \

# this method needs to load multiple networks, please set the checkpoints in test_pipeling config file
# need to manually change the checkpoint path in configs/pipelines/test/test_arpl.yml
python main.py \
    --config configs/datasets/cifar10/cifar10.yml \
    configs/datasets/cifar10/cifar10_ood.yml \
    configs/networks/arpl_net.yml \
    configs/pipelines/test/test_arpl.yml \
    configs/preprocessors/base_preprocessor.yml \
    configs/postprocessors/msp.yml \
    --network.feat_extract_network.name resnet18_32x32 \
    --num_workers 8 \
    --seed 0
