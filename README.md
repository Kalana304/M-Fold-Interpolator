# DESIGN AND IMPLEMENTATION OF AN M-FOLD INTERPOLATOR
<div align="justify">
This report discusses the design and implementation of an M-fold interpolator, with the upsampling factor 𝑀 ∈ ℤ<sup>+</sup>. The filter specification for the anti-imaging filter within the M-fold interpolator is derived based on the sampling theory for the given signal to be interpolated. Two anti-imaging filters with stopband attenuations of 30dB and 60dB are designed following the procedure used to design a Finite-Duration Impulse Response (FIR) Low-Pass filter. The truncation of the Infinite Response initially obtained, is achieved from the Kaiser Window Function. The designed anti-imaging filters are implemented using the polyphase structure and the interpolators are implemented using the efficient structure in MATLAB R2016a. The report presents the magnitude responses and impulse responses of the filters designed to confirm its characteristics with the desired specifications. Further, the performance of the two interpolators designed are evaluated based on the Root Mean Square Error (RMSE) between the sampled signal at the higher sampling rate and the outputs from each interpolator and the computational complexity difference between the original and efficient implementations of the designed interpolators.</div>

## Table of Content
[INTRODUCTION](#introduction)

[METHODOLOGY](#method)

* [Deriving Filter specifications](#derivation)
* [Deriving the Kaiser Window parameters](#kaiser)
* [Polyphase Filter Implementation](#implementation)
* [Filter Evaluation](#evaluation)
  
[RESULTS](#results)

* [Time and Frequency domain analysis of the designed filters](#analysis)
* [Polyphase Filter Magnitude Spectra](#spectra)
* [Filter Evaluation](#eval)

[CONCLUSION](#conclusion)

[REFERENCES](#references)

## INTRODUCTION
<div align="justify">
This report describes the step-by-step procedure used to design an M-fold Interpolator with Low-Pass FIR Digital Filter as the Anti-Imaging Filter for prescribed specifications using the windowing method in conjunction with the Kaiser window. The software implementation and the evaluation of the M-fold interpolators was done by MATLAB (Version R2016a)
The ideal passband gains and the passband edge and stopband frequencies were obtained following the sampling theory for the given signal 𝑥[𝑛]. When selecting the passband and stopband edge frequencies, the widest possible transition band was considered as that reduces the need for sharp transitions and hence the order of the filters to be designed. This leads to the lower computational complexity as it increases with the order of the filter.
The closed form direct approach is used by following the Fourier series method to define and design the even-order linear-phase anti-imaging FIR digital filters for the derived and given specifications, while Kaiser Window is used for windowing. The parameters of the Kaiser window were used to tune the filters to the prescribed characteristics. The designed FIR digital filters are then implemented using the polyphase structure such that the implementation of the M-fold interpolators can be done in the efficient structure derived.
The time domain and frequency domain representation of the filters are obtained throughout the different design stages to evaluate the filter characteristics. The frequency responses of the filters were obtained primarily through the Fast Fourier Transform (FFT) algorithm implementation which provides a faster implementation of the Discrete Fourier Transform (DFT). The filters were then evaluated for its capability of successful re-sampling of the original signal with negligible distortion and computations complexities and the reduction of computation complexity with the efficient implementations.</div>

## METHODOLOGY

<div align="justify">
The project has the following requirements.
  
- Deriving the Ideal Passband Gain, Passband, and Stopband Edge frequencies for the Anti-Imaging filters to be designed
- Designing Anti-Imaging filters with two different Stopband attenuations, 𝐻<sub>30</sub>(𝑧) and 𝐻<sub>60</sub>(𝑧)
- Implementing the designed Anti-Imaging filters in Polyphase structure and the M-fold interpolators using the Efficient structure
- Evaluating the performance of the M-fold interpolators in-terms of the ability to re-sample the original signal and the computational complexities.
  
</div>

### Deriving Filter specifications

The passband gains, passband and stopband edges with widest possible transition width are derived in this section. To derive them, I employed the concepts of the sampling theory. For the complete derivation, check the [final report]("Report/Final Report.pdf").

###### Provided Parameters
|  Parameter  | Symbol | Value | Units | 
| :----------------: |:------------:| :-------:| :--------: | 
|Upsampling factor  | M | 4 | - | 
|Fundamental frequency   | &Omega;<sub>0</sub> | 60&pi; | rad/s |
|Sampling frequency     | &Omega;<sub>s</sub> | 200&pi; | rad/s |




### Deriving the Kaiser Window parameters

### Polyphase Filter Implementation

### Filter Evaluation

## RESULTS

### Time and Frequency domain analysis of the designed filters

### Polyphase Filter Magnitude Spectra

### Filter Evaluation

## CONCLUSION
<div align="justify">
The computational efficiency of implementing an M-fold Interpolator using the polyphase structure and efficient implementation is evident with approximately 75% reduction of the multiplications and the additions required to process and upsample the input sequence successfully. Also the two implementations (original and efficient) provide the similar outputs without any additional distortions apart from the group delay which is inherent to the designed digital filter and is not depending on the structure used to implement them. It can be seen , to obtain a higher stopband attenuation, higher order filters are required that increases the computational complexity with a very minimum reduction in the RMSE.
  
Further, the results depicts that the M-fold Interpolator is not only computationally efficient but also provides a very close representation of a sequence sampled at a sampling frequency M times higher than the sampling frequency used to obtain input sequence.
  
When designing the Anti-Imaging filters, the flexibility of the Kaiser Window has been incorporated. Since the ideal filters cannot be practically implemented, it is advantageous to be able to make a flexible filter of which the limitations can be controlled. This is a practical approach since small imperfections such as pass band ripple will not cause an observable difference in the filtered output. This means that the parameters of the filter can be adjusted until the differences between the filter output and an ideal output become indistinguishable for all the practical purposes. </div>

## REFERENCES
