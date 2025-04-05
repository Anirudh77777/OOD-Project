# Static to Dynamic Proxy Generation for Enhanced Out-of-Distribution Detection in Deep Learning

## Overview
This repository implements the **AdaNeg framework**, a novel approach to Out-of-Distribution (OOD) detection. OOD detection ensures machine learning systems can reliably handle inputs that deviate from the training distribution, crucial in safety-critical domains like autonomous vehicles, healthcare, and cybersecurity.

## Features
- **Dynamic Proxies**: Utilizes task-adaptive and sample-adaptive proxies to overcome semantic misalignment in static methods.
- **Robust Evaluation**: Benchmarked on diverse datasets, including:
  - **In-Distribution (ID)**: ImageNet-1K, CIFAR-10.
  - **Near-OOD**: iNaturalist.
  - **Far-OOD**: Textures, Places365, OpenImages-O.
- **Performance Metrics**: Evaluates using AUROC, FPR95, and ID Accuracy.
- **Hyperparameter Sensitivity Analysis**: Assesses the impact of scaling temperature, memory size, and decision thresholds.
- **Comparative Analysis**: Benchmarks AdaNeg against methods like NegLabel, LAPT, and Maximum Confidence Minimization.

## Methodology
1. **Task-Adaptive Proxies**: Align with dataset-level OOD characteristics using a memory bank.
2. **Sample-Adaptive Proxies**: Refine task-adaptive proxies for individual test samples with attention mechanisms.
3. **Weighted Similarity Scoring**: Combines fixed negative labels with adaptive proxies for OOD detection.
4. **Data Augmentation**: Includes geometric and color transformations to enhance robustness.

## Results
- Outperformed static methods in near-OOD and far-OOD detection scenarios.
- Demonstrated adaptability to high-variability datasets.
- Identified optimal hyperparameter settings for enhanced performance.

## Limitations
- Computational overhead compared to static methods.
- Dependency on pretrained Vision-Language Models (e.g., CLIP).
- Challenges in scaling to extremely large datasets.

## Future Directions
- Optimize computational efficiency.
- Evaluate on real-world domain-specific datasets.
- Develop hybrid frameworks combining generative and adaptive approaches.


## Citation
If you find this work useful, please cite:

```
@article{vishwanath2024adaneg,
  title={Static to Dynamic Proxy Generation for Enhanced Out-of-Distribution Detection in Deep Learning},
  author={Anirudh Vishwanath},
  journal={University of Rochester},
  year={2024}
}
```

## Acknowledgments
This work was conducted using computational resources provided by the University of Rochester’s BlueHive cluster. Special thanks to collaborators and advisors for their support.
