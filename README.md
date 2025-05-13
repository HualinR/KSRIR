# 🎧 A Metric for Predicting the Quality of Ambisonic Spatial Audio Reproduced Using Spatially Interpolated or Extrapolated Room Impulse Responses

This repository contains the official implementation of the paper:

**[A Metric for Predicting the Quality of Ambisonic Spatial Audio Reproduced Using Spatially Interpolated or Extrapolated Room Impulse Responses](https://ieeexplore.ieee.org/abstract/document/10889495)**,  
presented at **ICASSP 2025**.

This work proposes a novel **objective evaluation metric** for assessing the quality of B-format Room Impulse Responses (RIRs). These RIRs are commonly used in ambisonic spatial audio systems, particularly in applications involving **spatial interpolation** or **extrapolation** of sound fields.

---

## 📦 Repository Overview

- ├── `ICASSP25_test.m` – Main script to run the evaluation
- ├── `ICASSP25_KSRIR.m` – Core objective quality metric
- ├── `xRIRAnalyzer_HR.m` – Segment-level analysis with configurable parameters
- ├── `xRIRCleaner.m` – Preprocessing: removes low-level and silent parts before the direct sound
- ├── `getWindowCenteredAt.m` – Utility function for segment windowing
- ├── `getShortTermAverage.m` – Helper for local averaging
- └── `*.mat` – Supporting reflection profile data

---

## 🚀 Getting Started

### Prerequisites

- [MATLAB](https://www.mathworks.com/products/matlab.html) (tested on R2021b or later)
- Reference and synthesized WAV-format ambisonic audio files
(Ensure both are at the same sampling rate and have equal length)

### Running the Code

1. Clone or download this repository.  
2. Open `ICASSP25_test.m` in MATLAB.  
3. Set the path to your own WAV files inside the script.
4. Run the script to start the evaluation.

---

## ⚙️ Configuration

Adjust Segment Length:
Modify the segment length parameter `tau3` in `xRIRAnalyzer_HR.m`, to change the temporal resolution of the analysis.

---

## 📈 Output
Running the evaluation will output an objective spatial audio quality score based on the proposed metric. This score is useful for:

Benchmarking spatial interpolation or extrapolation algorithms

Evaluating room acoustics processing

Supporting perceptual quality assessment studies in immersive audio

---

## 📄 Citation
If you use this code or reference the method in your work, please cite the following:

```bibtex
@INPROCEEDINGS{10889495,
  author    = {Ren, Hualin and Ritz, Christian and Zhao, Jiahong and Zheng, Xiguang and Jang, Daeyoung},
  booktitle = {ICASSP 2025 - 2025 IEEE International Conference on Acoustics, Speech and Signal Processing (ICASSP)}, 
  title     = {A Metric for Predicting the Quality of Ambisonic Spatial Audio Reproduced Using Spatially Interpolated or Extrapolated Room Impulse Responses}, 
  year      = {2025},
  volume    = {},
  number    = {},
  pages     = {1-5},
  doi       = {10.1109/ICASSP49660.2025.10889495}
}
```
If you use components related to reflection capture or segment analysis (`xRIRAnalyzer_HR.m`, `xRIRCleaner.m`, `getWindowCenteredAt.m`, `getShortTermAverage.m`, or `*.mat`), please also cite:
```bibtex
@Article{app12042061,
  author    = {Zhao, Jiahong and Zheng, Xiguang and Ritz, Christian and Jang, Daeyoung},
  title     = {Interpolating the Directional Room Impulse Response for Dynamic Spatial Audio Reproduction},
  journal   = {Applied Sciences},
  year      = {2022},
  volume    = {12},
  number    = {4},
  article-number = {2061},
  url       = {https://www.mdpi.com/2076-3417/12/4/2061}
}
```
---

## 📬 Contact
For questions, feedback, or collaboration, feel free to contact:

📧 Hualin Ren — hualin@uow.edu.au

---

## 📝 License
This repository is made available for academic and research use only. 

For commercial licensing, please contact the authors directly.


