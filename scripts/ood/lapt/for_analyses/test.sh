#!/bin/bash
# sh scripts/ood/coop/imagenet_train_coop.sh


################################### ablate ood prompt number and ood entropy loss.
# mix_strategy=mixup
# mix_strategy=cutmix
# mix_strategy=manimix
# mix_strategy=geomix
# mix_strategy=manimix_wccm
# mix_strategy=geomix_wccm
# mix_strategy=mixup_manimix_wccm
# mix_strategy=mixup_geomix_wccm
mix_strategy=wccm

depth=5
alpha=1
beta=0 ## beta==0 --> vanilla mixup; beta > 0, mixed data are given partial ood labels. 
total_gs_num=1000
loss_components=multice
gs_loss_weight=1-1-1-1
OOD_NUM=1000
shot_num=16
weight_decay=0.00001
optimizer=sgd
N_CTX=4
weight_decay=0.0001
# N_CTX  要和 CTX_INIT 对应数量，否则会出问题!!!
# ./data/benchmark_imglist/imagenet/train_imagenet.txt///./data/benchmark_imglist/imagenet/train_imagenet_idood_last1k_syn2.txt \
############ learning rate 比较大的时候需要比较多的
for seed in 0 
do
    for lr in 0.01 
    do
        for gs_loss_weight in 1-1-1-1 
        do
            python main.py \
            --config configs/datasets/imagenet/imagenet_train_fsood.yml \
            configs/networks/coop.yml \
            configs/pipelines/train/train_coop.yml \
            configs/preprocessors/base_preprocessor.yml \
            configs/postprocessors/mcm.yml \
            --network.name coop_negoodprompt \
            --network.backbone.OOD_NUM ${OOD_NUM} \
            --network.backbone.text_prompt tip \
            --network.pretrained False \
            --network.backbone.CSC False \
            --network.backbone.N_CTX ${N_CTX} \
            --network.checkpoint ./results/pretrained_weights/resnet50_imagenet1k_v1.pth \
            --trainer.trainer_args.alpha ${alpha} \
            --trainer.trainer_args.beta ${beta} \
            --trainer.trainer_args.mix_strategy ${mix_strategy} \
            --trainer.trainer_args.total_gs_num ${total_gs_num} \
            --trainer.trainer_args.gs_loss_weight ${gs_loss_weight} \
            --trainer.trainer_args.loss_components ${loss_components} \
            --trainer.trainer_args.gs_flag False \
            --trainer.trainer_args.queue_capacity 500 \
            --trainer.trainer_args.pre_queue True \
            --trainer.trainer_args.iter_recompuration 10 \
            --trainer.trainer_args.soft_split True \
            --evaluator.name ood_clip \
            --trainer.name oodmixup_idood \
            --postprocessor.name oneoodprompt \
            --postprocessor.APS_mode True \
            --postprocessor.postprocessor_args.tau 1 \
            --postprocessor.postprocessor_args.in_score oodscore \
            --dataset.train.imglist_pth ./data/benchmark_imglist/imagenet/train_imagenet_idood_last1k_syn2_dedup.txt \
            --dataset.interpolation bilinear \
            --dataset.train.batch_size 32 \
            --dataset.num_classes 2000 \
            --dataset.train.few_shot 0 \
            --seed ${seed} \
            --optimizer.name ${optimizer} \
            --optimizer.num_epochs 10 \
            --optimizer.lr ${lr} \
            --optimizer.weight_decay ${weight_decay} \
            --num_gpus 1 --num_workers 4 \
            --merge_option merge \
            --output_dir ./debug__notused/ \
            --mark alpha${alpha}_beta${beta}_${mix_strategy}_ood${OOD_NUM}_w${gs_loss_weight}_${loss_components}_${optimizer}lr${lr}_wd${weight_decay}
        done
    done
done

        #    --output_dir ./debug_oodval_dedup_scratch_nctx${N_CTX}/ \

# ################################### ablate ood prompt number and ood entropy loss.
# # mix_strategy=mixup
# # mix_strategy=cutmix
# # mix_strategy=manimix
# # mix_strategy=geomix
# # mix_strategy=manimix_wccm
# # mix_strategy=geomix_wccm
# # mix_strategy=mixup_manimix_wccm
# # mix_strategy=mixup_geomix_wccm
# mix_strategy=manimix

# depth=5
# alpha=1
# beta=1
# total_gs_num=1000
# loss_components=classify
# gs_loss_weight=1-1-1-1
# OOD_NUM=1000
# shot_num=16

# # N_CTX  要和 CTX_INIT 对应数量，否则会出问题!!!
# for seed in 0 1 2024
# do
#     for lr in 0.1
#     do
#         python main.py \
#             --config configs/datasets/imagenet/imagenet_train_fsood.yml \
#             configs/networks/coop.yml \
#             configs/pipelines/train/train_coop.yml \
#             configs/preprocessors/base_preprocessor.yml \
#             configs/postprocessors/mcm.yml \
#             # --dataset.train.imglist_pth ./data/benchmark_imglist/imagenet/train_imagenet_idood11k_syn2_filtered_acc_pred.txt \
#             --network.name coop_negoodprompt \
#             --network.backbone.OOD_NUM ${OOD_NUM} \
#             --network.backbone.text_prompt tip \
#             --network.pretrained False \
#             --network.backbone.CSC False \
#             --network.backbone.N_CTX 4 \
#             --network.backbone.CTX_INIT 'a photo of a' \
#             --network.checkpoint ./results/pretrained_weights/resnet50_imagenet1k_v1.pth \
#             --trainer.name oodmixup_syn \
#             --trainer.trainer_args.alpha ${alpha} \
#             --trainer.trainer_args.beta ${beta} \
#             --trainer.trainer_args.mix_strategy ${mix_strategy} \
#             --trainer.trainer_args.total_gs_num ${total_gs_num} \
#             --trainer.trainer_args.gs_loss_weight ${gs_loss_weight} \
#             --trainer.trainer_args.loss_components ${loss_components} \
#             --trainer.trainer_args.gs_flag False \
#             --trainer.trainer_args.queue_capacity 500 \
#             --trainer.trainer_args.pre_queue True \
#             --trainer.trainer_args.iter_recompuration 10 \
#             --trainer.trainer_args.soft_split True \
#             --evaluator.name ood_clip \
#             --postprocessor.name oneoodprompt \
#             --postprocessor.postprocessor_args.tau 1 \
#             --postprocessor.postprocessor_args.in_score sum \
#             --dataset.interpolation bilinear \
#             --dataset.train.batch_size 128 \
#             --dataset.train.few_shot ${shot_num} \
#             --seed ${seed} \
#             --optimizer.num_epochs 60 \
#             --optimizer.lr ${lr} \
#             --num_gpus 1 --num_workers 4 \
#             --merge_option merge \
#             --output_dir ./debug/ \
#             --mark alpha${alpha}_beta${beta}_${mix_strategy}_ood${OOD_NUM}_lr${lr}
#     done
# done


# tau=5.0
# beta=1.0
# ######################### clip + negood +  MCM.
# prompt=tip
# for tau in 1 
# do
#     python main.py \
#     --config configs/datasets/imagenet/imagenet_train_fsood.yml \
#     configs/networks/fixed_clip.yml \
#     configs/pipelines/test/test_fsood.yml \
#     configs/preprocessors/base_preprocessor.yml \
#     configs/postprocessors/mcm.yml \
#     --dataset.train.imglist_pth ./data/benchmark_imglist/imagenet/train_imagenet_idood11k_syn2.txt \
#     --dataset.train.batch_size 128 \
#     --dataset.train.few_shot 0 \
#     --dataset.num_classes 11000 \
#     --evaluator.name fsood_clip \
#     --network.name fixedclip_negoodprompt \
#     --network.backbone.text_prompt ${prompt} \
#     --network.backbone.text_center True \
#     --network.pretrained False \
#     --postprocessor.name oneoodpromptdevelop \
#     --postprocessor.postprocessor_args.tau ${tau}  \
#     --postprocessor.postprocessor_args.beta ${beta}  \
#     --postprocessor.postprocessor_args.in_score oodscore_fisher  \
#     --num_gpus 1 --num_workers 6 \
#     --merge_option merge \
#     --output_dir ./debug/ \
#     --mark tau${tau}
# done

# #################################### ablate ood prompt number and ood entropy loss.
# mix_strategy=manimix_wccm
# depth=5
# alpha=1
# beta=1
# total_gs_num=1000
# loss_components=classify
# gs_loss_weight=1-1-1-1
# OOD_NUM=10

# for seed in 10
# do
#     for shot_num in 16
#     do
#         python main.py \
#             --config configs/datasets/imagenet200/imagenet200_train_fsood.yml \
#             configs/networks/maple.yml \
#             configs/pipelines/train/train_coop.yml \
#             configs/preprocessors/base_preprocessor.yml \
#             configs/postprocessors/mcm.yml \
#             --network.name maple_oneoodprompt \
#             --network.backbone.OOD_NUM ${OOD_NUM} \
#             --network.backbone.text_prompt tip \
#             --network.pretrained False \
#             --network.backbone.CSC False \
#             --network.checkpoint ./results/pretrained_weights/resnet50_imagenet1k_v1.pth \
#             --trainer.trainer_args.alpha ${alpha} \
#             --trainer.trainer_args.beta ${beta} \
#             --trainer.trainer_args.mix_strategy ${mix_strategy} \
#             --trainer.trainer_args.total_gs_num ${total_gs_num} \
#             --trainer.trainer_args.gs_loss_weight ${gs_loss_weight} \
#             --trainer.trainer_args.loss_components ${loss_components} \
#             --trainer.trainer_args.gs_flag False \
#             --trainer.trainer_args.queue_capacity 500 \
#             --trainer.trainer_args.pre_queue True \
#             --trainer.trainer_args.iter_recompuration 10 \
#              --trainer.trainer_args.soft_split True \
#             --trainer.name oodmixup \
#             --postprocessor.name oneoodprompt \
#             --postprocessor.postprocessor_args.tau 1  \
#             --postprocessor.postprocessor_args.in_score sum  \
#             --dataset.interpolation bilinear \
#             --dataset.train.batch_size 128 \
#             --dataset.train.few_shot ${shot_num} \
#             --seed ${seed} \
#             --optimizer.num_epochs 100 \
#             --optimizer.lr 0.1 \
#             --num_gpus 1 --num_workers 4 \
#             --merge_option merge \
#             --output_dir ./debug/ \
#             --mark alpha${alpha}_beta${beta}_${mix_strategy}_pdepth${depth}_oodnum${OOD_NUM}_shot${shot_num}_seed${seed}
#     done
# done
# ## tip: 80/50
# ## full: 80/53.5


# mix_strategy=manimix_wccm
# mix_strategy=mani_cccm
# mix_strategy=manimix_wccm
# alpha=1
# beta=1
# total_gs_num=1000
# gs_loss_weight=1-1-1-1
# loss_components=classify

# python main.py \
#     --config configs/datasets/imagenet/imagenet_train_fsood.yml \
#     configs/networks/coop.yml \
#     configs/pipelines/train/train_coop.yml \
#     configs/preprocessors/augmix_preprocessor.yml \
#     configs/postprocessors/mcm.yml \
#     --network.name coop_oneoodprompt \
#     --network.backbone.text_prompt tip \
#     --network.backbone.CSC False \
#     --network.pretrained False \
#     --network.checkpoint ./results/pretrained_weights/resnet50_imagenet1k_v1.pth \
#     --trainer.trainer_args.alpha ${alpha} \
#     --trainer.trainer_args.beta ${beta} \
#     --trainer.trainer_args.mix_strategy ${mix_strategy} \
#     --trainer.trainer_args.total_gs_num ${total_gs_num} \
#     --trainer.trainer_args.gs_loss_weight ${gs_loss_weight} \
#     --trainer.trainer_args.loss_components ${loss_components} \
#     --trainer.trainer_args.gs_flag False \
#     --trainer.trainer_args.queue_capacity 500 \
#     --trainer.trainer_args.pre_queue True \
#     --trainer.trainer_args.iter_recompuration 10 \
#     --trainer.trainer_args.soft_split True \
#     --trainer.name oodmixup \
#     --postprocessor.name oneoodprompt \
#     --postprocessor.postprocessor_args.tau 1  \
#     --postprocessor.postprocessor_args.in_score sum  \
#     --dataset.train.batch_size 128 \
#     --dataset.interpolation bilinear \
#     --dataset.train.few_shot 16 \
#     --optimizer.num_epochs 100 \
#     --optimizer.lr 0.1 \
#     --num_gpus 1 --num_workers 4 \
#     --merge_option merge \
#     --output_dir ./debug/ \
#     --mark alpha${alpha}_beta${beta}_${mix_strategy} \
#     --seed 0


# python main.py \
#     --config configs/datasets/imagenet/imagenet_train_fsood.yml \
#     configs/networks/maple.yml \
#     configs/pipelines/train/train_coop.yml \
#     configs/preprocessors/base_preprocessor.yml \
#     configs/postprocessors/mcm.yml \
#     --network.name maple_oneoodprompt \
#     --network.backbone.PROMPT_DEPTH ${depth} \
#     --network.backbone.text_prompt tip \
#     --network.backbone.CSC True \
#     --network.pretrained False \
#     --network.checkpoint ./results/pretrained_weights/resnet50_imagenet1k_v1.pth \
#     --trainer.trainer_args.alpha ${alpha} \
#     --trainer.trainer_args.beta ${beta} \
#     --trainer.trainer_args.mix_strategy ${mix_strategy} \
#     --trainer.trainer_args.total_gs_num ${total_gs_num} \
#     --trainer.trainer_args.gs_loss_weight ${gs_loss_weight} \
#     --trainer.trainer_args.gs_flag False \
#     --trainer.trainer_args.queue_capacity 500 \
#     --trainer.trainer_args.pre_queue True \
#     --trainer.trainer_args.iter_recompuration 10 \
#     --trainer.trainer_args.soft_split True \
#     --trainer.name oodmixup \
#     --postprocessor.name oneoodprompt \
#     --postprocessor.postprocessor_args.tau 1  \
#     --postprocessor.postprocessor_args.in_score sum  \
#     --dataset.train.batch_size 128 \
#     --dataset.train.few_shot 16 \
#     --optimizer.num_epochs 50 \
#     --optimizer.lr 0.1 \
#     --num_gpus 1 --num_workers 4 \
#     --merge_option merge \
#     --output_dir ./debug/ \
#     --mark alpha${alpha}_beta${beta}_${mix_strategy}_pdepth${depth}_gs_flag_false \
#     --seed 0



# mix_strategy=manimix_wccm
# alpha=1
# for depth in 4 6
# do
#     for beta in 1
#     do
#         # python main.py \
#         # --config configs/datasets/imagenet/imagenet_train_fsood.yml \
#         # configs/networks/coop.yml \
#         # configs/pipelines/test/test_fsood.yml \
#         # configs/preprocessors/base_preprocessor.yml \
#         # configs/postprocessors/mcm.yml \
#         # --network.name coop_oneoodprompt \
#         # --network.backbone.text_prompt tip \
#         # --network.pretrained True \
#         # --network.checkpoint ./exp_feat_mix/imagenet_coop_oneoodprompt_oodmixup_sgd_e100_lr0.1_alpha${alpha}_beta${beta}_${mix_strategy}/s0/last_epoch100_acc0.7158.ckpt \
#         # --postprocessor.name oneoodprompt \
#         # --postprocessor.postprocessor_args.tau 1.0  \
#         # --postprocessor.postprocessor_args.in_score oodscore  \
#         # --dataset.train.batch_size 128 \
#         # --dataset.train.few_shot 16 \
#         # --num_gpus 1 --num_workers 6 \
#         # --merge_option merge \
#         # --output_dir ./exp_feat_mix/ \
#         # --mark alpha${alpha}_beta${beta}_${mix_strategy}_test_tau10 
#         python main.py \
#             --config configs/datasets/imagenet/imagenet_train_fsood.yml \
#             configs/networks/maple.yml \
#             configs/pipelines/train/train_coop.yml \
#             configs/preprocessors/base_preprocessor.yml \
#             configs/postprocessors/mcm.yml \
#             --network.name maple_oneoodprompt \
#             --network.backbone.PROMPT_DEPTH ${depth} \
#             --network.backbone.text_prompt tip \
#             --network.pretrained False \
#             --network.checkpoint ./results/pretrained_weights/resnet50_imagenet1k_v1.pth \
#             --trainer.trainer_args.alpha ${alpha} \
#             --trainer.trainer_args.beta ${beta} \
#             --trainer.trainer_args.mix_strategy ${mix_strategy} \
#             --trainer.name oodmixup \
#             --postprocessor.name oneoodprompt \
#             --postprocessor.postprocessor_args.tau 1  \
#             --postprocessor.postprocessor_args.in_score sum  \
#             --dataset.train.batch_size 128 \
#             --dataset.train.few_shot 16 \
#             --optimizer.num_epochs 50 \
#             --optimizer.lr 0.1 \
#             --num_gpus 1 --num_workers 4 \
#             --merge_option merge \
#             --output_dir ./exp_maple_manimix_wccm/ \
#             --mark alpha${alpha}_beta${beta}_${mix_strategy}_promptdepth${depth} \
#             --seed 0
#     done
# done


