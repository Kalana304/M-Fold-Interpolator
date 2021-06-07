# DESIGN AND IMPLEMENTATION OF AN M-FOLD INTERPOLATOR
<div align="justify">
This report discusses the design and implementation of an M-fold interpolator, with the upsampling factor 𝑀 ∈ ℤ<sup>+</sup>. The filter specification for the anti-imaging filter within the M-fold interpolator is derived based on the sampling theory for the given signal to be interpolated. Two anti-imaging filters with stopband attenuations of 30dB and 60dB are designed following the procedure used to design a Finite-Duration Impulse Response (FIR) Low-Pass filter. The truncation of the Infinite Response initially obtained, is achieved from the Kaiser Window Function. The designed anti-imaging filters are implemented using the polyphase structure and the interpolators are implemented using the efficient structure in MATLAB R2016a. The report presents the magnitude responses and impulse responses of the filters designed to confirm its characteristics with the desired specifications. Further, the performance of the two interpolators designed are evaluated based on the Root Mean Square Error (RMSE) between the sampled signal at the higher sampling rate and the outputs from each interpolator and the computational complexity difference between the original and efficient implementations of the designed interpolators.</div>

## Table of Content
[Introduction](#introduction)

[Methodology](#method)

  *[heading]
  
[Deriving Filter specifications](#theory)

[Results](#results)

[Conclusion](#conclusion)
