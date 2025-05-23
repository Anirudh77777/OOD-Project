#!/bin/bash
# sh scripts/ad/dsvdd/osr_cifar6_train_dsvdd.sh

GPU=1
CPU=1
node=30
jobname=openood

PYTHONPATH='.':$PYTHONPATH \
srun -p dsta --mpi=pmi2 --gres=gpu:${GPU} -n1 \
--cpus-per-task=${CPU} --ntasks-per-node=${GPU} \
--kill-on-bad-exit=1 --job-name=${jobname} \
python main.py \
--config configs/datasets/osr_cifar6/cifar6_seed1.yml \
configs/datasets/osr_cifar6/cifar6_seed1_ood.yml \
configs/pipelines/train/train_dsvdd.yml \
configs/networks/resnet18_32x32.yml \
configs/preprocessors/base_preprocessor.yml \
configs/postprocessors/dsvdd.yml \
--optimizer.num_epochs 100 \
--network.pretrained True \
--network.checkpoint 'results/checkpoints/osr/cifar6_seed1_acc97.57.ckpt' &
