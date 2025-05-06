# 🎧 A Metric for Predicting the Quality of Ambisonic Spatial Audio Reproduced Using Spatially Interpolated or Extrapolated Room Impulse Responses

This repository contains the official implementation of the paper:

**[A Metric for Predicting the Quality of Ambisonic Spatial Audio Reproduced Using Spatially Interpolated or Extrapolated Room Impulse Responses](https://ieeexplore.ieee.org/abstract/document/10889495)**,  
presented at **ICASSP 2025**.

This work proposes a novel **objective evaluation metric** for assessing the quality of B-format Room Impulse Responses (RIRs). These RIRs are commonly used in ambisonic spatial audio systems, particularly in applications involving **spatial interpolation** or **extrapolation** of sound fields.

---

## 📦 Repository Overview

- ├── `ICASSP25_test.m` – Main script to run the evaluation  
- ├── `ICASSP25_KSRIR.m` – Core metric function  
- ├── `xRIRAnalyzer_HR.m` – Segment analysis with configurable parameters  
- ├── `xRIRCleaner.m` – Remove the low-level and silence parts before the direct sound  
- ├── `*.mat` – Supporting data and helper functions  
- └── `Test_wav_files/` – Folder containing reference and synthesized audio  

---

## 🚀 Getting Started

### Prerequisites

- [MATLAB](https://www.mathworks.com/products/matlab.html) (tested on R2021b or later)
- WAV-format ambisonic audio files (reference and synthesized)

### Running the Code

1. Clone or download this repository.  
2. Open `ICASSP25_test.m` in MATLAB.  
3. Modify the input path in the script to point to your WAV files.  
4. Run the script `ICASSP25_test.m`

---

## ⚙️ Configuration

Change Input Files:
Replace the contents of the `Test_wav_files/` folder with your own reference and synthesized audio files.

Adjust Segment Length:
In `xRIRAnalyzer_HR.m`, you can change the length of the captured segments using the variable `tau3`.

---

## 📈 Output
The evaluation script will output an objective score quantifying the spatial audio quality based on the proposed metric. This score can be used for:

Benchmarking spatial interpolation/extrapolation methods

Analyzing room acoustics processing performance

Supporting perceptual audio quality studies

---

## 📄 Citation
If you use this code or reference the method in your research, please cite:

```bibtex
@INPROCEEDINGS{10889495,
  author={Ren, Hualin and Ritz, Christian and Zhao, Jiahong and Zheng, Xiguang and Jang, Daeyoung},
  booktitle={ICASSP 2025 - 2025 IEEE International Conference on Acoustics, Speech and Signal Processing (ICASSP)}, 
  title={A Metric for Predicting the Quality of Ambisonic Spatial Audio Reproduced Using Spatially Interpolated or Extrapolated Room Impulse Responses}, 
  year={2025},
  volume={},
  number={},
  pages={1-5},
  keywords={Measurement;Location awareness;Accuracy;Spatial audio;Virtual reality;Acoustics;Reflection;Reliability;Ambisonics;Speech processing;Room impulse response;spatial audio quality;objective quality metric;virtual reality},
  doi={10.1109/ICASSP49660.2025.10889495}}
```
---

## 📬 Contact
For questions, feedback, or collaboration, feel free to contact:

📧 Hualin Ren — hualin@uow.edu.au

---

## 📝 License
This repository is made available for academic and research use only. 

For commercial licensing, please contact the authors directly.


