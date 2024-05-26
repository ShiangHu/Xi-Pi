# XiPi toolbox

[shiang Hu](https://github.com/ShiangHu), [zhihao Zhang](https://github.com/annie-jpg), [BRAIT-LAB](https://shianghu.github.io/lab)

[[`Paper`](https://ieeexplore.ieee.org/document/10430394)] [[`Biorxiv`]()]
2024-May highlights paper - Journal of Biomedical and Health Informatics [[`Click this`](https://www.embs.org/jbhi/articles/may-2024-highlights/)]

The **XiPi(ξ-π) alorithm** separate periodic and aperiodic neural activity **using nonparametric model**. It works in the spectral domain, like FOOOF, IRASA, SpriNt etc.

<p align="center">
  <img src="assets/cover.jpg?raw=true"/>
</p>
<p align="center">
  Cover Photo
</p>

<p align="center">
  <img src="assets/GA.jpg?raw=true"/>
</p>
<p align="center">
  Cover Photo
</p>

## Installation

The code requires `matlab enviroment`. If you want to compare it with FOOOF, you also need to install `FOOOF` [here](https://fooof-tools.github.io/fooof/index.html).

Install XiPi (ξ-π)
```
git clone https://github.com/annie-jpg/XiPeaks-study
```

Add `XiPi_toolbox` directory into your matlab 
```
cd $home/XiPeaks-study; addpath(genpath("XiPi_toolbox"))
```

## Quick Start
The `XiPi` work in the spectral domain. You should calculate the spectral first through power spectrum density estimation method[Welch,Multitaper]. <br>
Using matlab command `doc pwelch` to check, or function `xp_calculateSpec`(see later).

Then, using the core function :
```
[psd_ftd,components] = scmem_unim(freq,spt);
```

Now, you have separate a aperiodic component (AC) and some periodic components (PCs). `psd_ftd` represents the sum of all components, and `components` [column 1] represents the AC, [other column] represent the PCs.
<p align="center">
  <img src="assets/sample.png?raw=true"/>
</p>

## Parameter settings
For `scmem_unim` function, you can set some parameters to limit the peak fitting. According to your datasets, you can set it empirically.
If the peak setting is null, we tend to set default for you.<br>
The peak setting includes: <br>
`peak_min_width`: The peak whose bandwidth < `peak_min_width` will be not found.<br>
`peak_min_value`: The peak whose power proportion < `peak_min_value` will be not found.<br>
`peak_num_limt`: The number of peak detection will <= `peak_num_limt`

```
settings = [1 0.05 3]   % peak_min_width=1;peak_min_value=0.05;peak_num_limt=3;
[psd_ftd,components] = scmem_unim(freq,spt,settings);  
```

## Expansion
For convenience, we provide additional function, including <br>
[import data: `xp_importdata`] <br>
[calculate PSD: `xp_calculateSpec`]<br>
[batch excute ξ-π: `xp_separateSpec`]<br>
[parameterization: `xp_parameterize`]

```
XiPi = xp_importdata([]) % import data.
XiPi = xp_calculateSpec(XiPi,[1 30],50,'select_chan',[1 2])  % calculate spectral in channel 1,2 and 1-30s.
XiPi = xp_separateSepc(XiPi)  % using ξ-π to separate neural PSD.
XiPi = xp_parameterize(XiPi)  % using power-law function and Gaussian function [defalut] to parameterize components.
```
Please use `doc` command to check more function parameter input.

## Prospect and application
The ξ-π algorithm can be:
* extended to time-frequency analysis.
* extended to multivariable cross spectrum.
* applied to obtain oscillation features and predict age, disorder etc.
* applied to eliminate the impact of aperiodic component.

## Contributing
shiang Hu: <br>
zhihao Zhang: <br>
jie Ruan: <br>
Pedro A. Valdes-Sosa: 

## Contributors
shiang Hu, zhihao Zhang, jie Ruan, Borsh, Pedro A. Valdes-Sosa

## Acknowledgements
This work was supported by the NSFC Project Number 62101003. 
