# AAE6102 Assignment 1


## Overview

This project involves the implementation and analysis of a software-defined receiver (SDR) for GPS vector tracking. The customized SDR is based on the open-source MATLAB code published by Bing Xu and Li-Ta Hsu [1].This project contains the following components:  
- `geo/` and `acqtckpos/` - Original source folders.  
- Multiple `.m` files for GNSS signal processing.  
- Two data files: `Urban` and `Opensky.bin`.  
- `SDR_main.m` - The main function for processing IF data.   

## Table of Contents

- [Task 1 – Acquisition](#task-1--acquisition)
- [Task 2 – Tracking](#task-2--tracking)
- [Task 3 – Navigation Data Decoding](#task-3--navigation-data-decoding)
- [Task 4 – Position and Velocity Estimation](#task-4--position-and-velocity-estimation)
- [Task 5 – Kalman Filter-Based Positioning](#task-5--kalman-filter-based-positioning)
- [References](#references)

## Task 1 - Acquisition

To process the IF data using a GNSS SDR and generate the initial acquisition results, follow these steps:  

1. **Run the Parameter Initialization**  
   - Before executing the main function, ensure that the parameter initialization files are properly loaded.  

2. **Load the Data Files**  
   - Modify the file paths in `initParametersUrban.m` and `initParametersOpenSky.m` to correctly reference `Urban.bin` and `Opensky.bin`.  

3. **Execute the Acquisition Process**  
   - Once the parameters are set, run the Parameter initialization section in SDR_main.m to initiate the acquisition process.
  
## Acquisition Results  

**Fig. 1** and **Fig. 2** illustrate the initial acquisition results for both Open Sky and Urban data.  

- **Signal-to-Noise Ratio (SNR)** is plotted as the "Acquisition Metric".  
- **SNR threshold**: 18  
- **Open Sky Data**: Successfully acquired **8 satellites** with PRN codes: `3, 4, 16, 22, 26, 27, 31, 32`.  
- **Urban Data**: Successfully acquired **5 satellites** with PRN codes: `1, 3, 7, 11, 18`.  

<div align="center">
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/Opensky%20Acquisition%20Result.png" width="800">
    <figcaption>
      <b>Fig. 1</b><br> Acquisition result of OpenSky data.
    </figcaption>
  </figure>
</div>

<div align="center">
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/Urban%20Acquisition%20Result.png" width="800">
    <figcaption>
      <b>Fig. 2</b><br> Acquisition result of Urban data.
    </figcaption>
  </figure>
</div>

## Task 2 - Tracking

The tracking performance for the OpenSky and Urban data is shown in **Fig. 3** and **Fig. 4**. Urban interference affects the correlation peaks in two main ways:

1. **ACF Values**:  
   In urban areas, ACF values are generally lower compared to open sky environments. This is due to signal propagation being affected by factors such as multi-path effects, building reflections, and signal attenuation. In contrast, open sky environments offer more direct, unobstructed line-of-sight paths, resulting in higher ACF values.

2. **ACF Variations**:  
   ACF variations tend to be smaller in urban areas. This is likely due to the use of higher-quality antennas and receivers, which help mitigate urban interference. These advanced systems improve signal reception, leading to more stable ACF values despite the challenging urban environment.
   
<div align="center">
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/OpenSky_ACF3.png" width="800">
  </figure>
</div>

<div align="center">
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/OpenSky_ACF4.png" width="800">
   </figure>
</div>

<div align="center">
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/OpenSky_ACF16.png" width="800">
  </figure>
</div>

<div align="center">
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/OpenSky_ACF22.png" width="800">
  </figure>
</div>

<div align="center">
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/OpenSky_ACF26.png" width="800">
  </figure>
</div>

<div align="center">
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/OpenSky_ACF27.png" width="800">
  </figure>
</div>

<div align="center">
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/OpenSky_ACF31.png" width="800">
  </figure>
</div>

<div align="center">
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/OpenSky_ACF32.png" width="800">
    <figcaption>
      <b>Fig. 3</b><br> ACF for the OpenSky data.
    </figcaption>
  </figure>
</div>

<div align="center">
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/Urban_ACF1.png" width="800">
  </figure>
</div>

<div align="center">
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/Urban_ACF3.png" width="800">
  </figure>
</div>

<div align="center">
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/Urban_ACF7.png" width="800">
  </figure>
</div>

<div align="center">
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/Urban_ACF11.png" width="800">
  </figure>
</div>

<div align="center">
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/Urban_ACF18.png" width="800">
    <figcaption>
      <b>Fig. 4</b><br> ACF for the Urban data.
    </figcaption>
  </figure>
</div>


## Task 3 - Navigation Data Decoding
To decode the navigation message and extract key parameters, such as ephemeris data, for at least one satellite, we need to examine the eph data. The table below presents the key parameters for different satellites in the Urban and OpenSky data

# GPS Satellite Ephemeris Data for urban data(PRN 1, 3, 7, 11, 22)

| Parameter      | Description | PRN 1 | PRN 3 | PRN 7 | PRN 11 | PRN 22 |
|---------------|-------------|-------|-------|-------|-------|--------|
| **TOW**  | Time of Week (s) | 449358, 449364, 449370, ... | 449358, 449364, 449370, ... | 449358, 449364, 449370, ... | 449358, 449364, 449370, ... | 449358, 449364, 448602, ... |
| **weeknum**  | GPS Week Number | 1032 | 1032 | 1032 | 1032 | 2056 |
| **IODC**  | Issue of Data Clock | 72 | 72 | 33 | 83 | 66 |
| **TGD**  | Time Group Delay (s) | 5.587e-09 | 1.862e-09 | -1.117e-08 | -1.257e-08 | -1.816e-08 |
| **toc**  | Clock Data Reference Time (s) | 453600 | 453600 | 453600 | 453600 | 453600 |
| **af2**  | Clock Drift Rate (s/s²) | 0 | 0 | 0 | 0 | 0 |
| **af1**  | Clock Drift (s/s) | -9.436e-12 | -1.136e-12 | -7.617e-12 | 8.526e-12 | -5.912e-12 |
| **af0**  | Clock Bias (s) | -3.489e-05 | 0.0001863 | -3.951e-05 | -0.0005900 | -0.000713 |
| **Crs**  | Amplitude of Sine Harmonic Correction Term to Orbit Radius (m) | -120.71 | -62.09 | 6.46 | -67.12 | -73.41 |
| **deltan**  | Mean Motion Difference from Computed Value (rad/s) | 4.190e-09 | 4.447e-09 | 4.891e-09 | 5.890e-09 | 5.192e-09 |
| **M0**  | Mean Anomaly at Reference Time (rad) | 0.5179 | -0.4303 | -0.0807 | -0.1989 | 1.8576 |
| **Cuc**  | Amplitude of Cosine Harmonic Correction Term to Argument of Latitude (rad) | -6.334e-06 | -3.090e-06 | 3.091e-07 | -3.604e-06 | -3.779e-06 |
| **ecc**  | Eccentricity | 0.008923 | 0.002226 | 0.012823 | 0.016643 | 0.007215 |
| **Cus**  | Amplitude of Sine Harmonic Correction Term to Argument of Latitude (rad) | 5.301e-06 | 1.155e-05 | 8.014e-06 | 1.512e-06 | 1.126e-05 |
| **sqrta**  | Square Root of Semi-Major Axis (m^1/2) | 5153.655 | 5153.777 | 5153.742 | 5153.706 | 5153.791 |
| **toe**  | Time of Ephemeris (s) | 453600 | 453600 | 453600 | 453600 | 453600 |
| **Cic**  | Amplitude of Cosine Harmonic Correction Term to Inclination (rad) | -7.450e-08 | 1.117e-08 | 4.284e-08 | -3.166e-07 | 1.322e-07 |
| **omegae**  | Longitude of Ascending Node of Orbit Plane at Weekly Epoch (rad) | -3.106 | -2.064 | 0.04408 | 2.725 | -2.138 |
| **Cis**  | Amplitude of Sine Harmonic Correction Term to Inclination (rad) | 1.601e-07 | 5.215e-08 | 1.266e-07 | -1.322e-07 | -5.402e-08 |
| **i0**  | Inclination Angle at Reference Time (rad) | 0.9761 | 0.9628 | 0.9557 | 0.9098 | 0.9274 |
| **Crc**  | Amplitude of Cosine Harmonic Correction Term to Orbit Radius (m) | 287.46 | 160.31 | 219.59 | 324.40 | 146.09 |
| **w**  | Argument of Perigee (rad) | 0.7114 | 0.5949 | -2.4619 | 1.8914 | -1.3337 |
| **omegadot**  | Rate of Right Ascension (rad/s) | -8.169e-09 | -7.832e-09 | -8.278e-09 | -9.304e-09 | -8.104e-09 |
| **idot**  | Rate of Inclination Angle (rad/s) | -1.810e-10 | 4.810e-10 | -6.868e-10 | 1.285e-11 | 4.293e-10 |

# GPS Satellite Ephemeris Data for Opensky data(PRN 3, 4, 16, 22, 26, 27, 31,32)

| Parameter      | Description | PRN 3 | PRN 4 | PRN 16 | PRN 22 | PRN 26 | PRN 27 | PRN 31 | PRN 32 |
|---------------|-------------|-------|-------|--------|--------|--------|--------|--------|--------|
| **TOW**  | Time of Week (s) | 390108, 390114, 390120, ... | 390108, 390114, 390120, ... | 390108, 390114, 390120, ... | 390108, 390114, 390120, ... | 390108, 390114, 390120, ... | 390108, 390114, 390120, ... | 390108, 390114, 390120, ... | 390108, 390114, 390120, ... |
| **weeknum**  | GPS Week Number | 1155 | 1155 | 1155 | 1155 | 1155 | 1155 | 1155 | 1155 |
| **IODC**  | Issue of Data Clock | 9 | 167 | 9 | 22 | 113 | 30 | 83 | 59 |
| **TGD**  | Time Group Delay (s) | -1.024e-08 | -4.19e-09 | -1.024e-08 | -1.769e-08 | 6.984e-09 | 1.862e-09 | -1.303e-08 | 4.656e-10 |
| **toc**  | Clock Data Reference Time (s) | 396000 | 396000 | 396000 | 396000 | 396000 | 396000 | 396000 | 396000 |
| **af2**  | Clock Drift Rate (s/s²) | 0 | 0 | 0 | 0 | 0 | 0 | 0 | 0 |
| **af1**  | Clock Drift (s/s) | -6.366e-12 | 4.547e-13 | -6.366e-12 | 9.208e-12 | 3.979e-12 | -5.002e-12 | -1.932e-12 | -4.092e-12 |
| **af0**  | Clock Bias (s) | -0.0004069 | -0.0002036 | -0.0004069 | -0.0004894 | 0.0001448 | -0.0002061 | -0.0001448 | -1.012e-05 |
| **Crs**  | Amplitude of Sine Harmonic Correction Term to Orbit Radius (m) | 23.34 | -40.31 | 23.34 | -99.81 | 21.25 | 70.43 | 30.71 | -32 |
| **deltan**  | Mean Motion Difference from Computed Value (rad/s) | 4.246e-09 | 4.369e-09 | 4.246e-09 | 5.283e-09 | 5.051e-09 | 4.030e-09 | 4.807e-09 | 4.580e-09 |
| **M0**  | Mean Anomaly at Reference Time (rad) | 0.7181 | -0.5694 | 0.7181 | -1.2609 | 1.7355 | -0.1730 | 2.8245 | 0.5799 |
| **Cuc**  | Amplitude of Cosine Harmonic Correction Term to Argument of Latitude (rad) | 1.389e-06 | -2.184e-06 | 1.389e-06 | -5.155e-06 | 1.152e-06 | 3.730e-06 | 1.460e-06 | -1.639e-06 |
| **ecc**  | Eccentricity | 0.0122 | 0.0014 | 0.0122 | 0.0067 | 0.0062 | 0.0095 | 0.0102 | 0.0051 |
| **Cus**  | Amplitude of Sine Harmonic Correction Term to Argument of Latitude (rad) | 7.687e-06 | 1.078e-05 | 7.687e-06 | 5.165e-06 | 7.040e-06 | 8.242e-06 | 7.228e-06 | 1.054e-05 |
| **sqrta**  | Square Root of Semi-Major Axis (m^1/2) | 5153.771 | 5153.690 | 5153.771 | 5153.712 | 5153.636 | 5153.652 | 5153.622 | 5153.731 |
| **toe**  | Time of Ephemeris (s) | 396000 | 396000 | 396000 | 396000 | 396000 | 396000 | 396000 | 396000 |
| **Cic**  | Amplitude of Cosine Harmonic Correction Term to Inclination (rad) | -1.005e-07 | 3.725e-08 | -1.005e-07 | -1.005e-07 | -2.048e-08 | 1.080e-07 | -1.136e-07 | -6.519e-08 |
| **omegae**  | Longitude of Ascending Node of Orbit Plane at Weekly Epoch (rad) | -1.674 | 2.458 | -1.674 | 1.272 | -1.812 | -0.717 | -2.787 | 2.417 |
| **Cis**  | Amplitude of Sine Harmonic Correction Term to Inclination (rad) | 1.359e-07 | 2.048e-08 | 1.359e-07 | -9.313e-08 | 8.940e-08 | 1.154e-07 | -5.029e-08 | 8.195e-08 |
| **i0**  | Inclination Angle at Reference Time (rad) | 0.9716 | 0.9608 | 0.9716 | 0.9364 | 0.9399 | 0.9747 | 0.9558 | 0.9577 |
| **Crc**  | Amplitude of Cosine Harmonic Correction Term to Orbit Radius (m) | 237.68 | 171.78 | 237.68 | 266.34 | 234.18 | 230.34 | 240.15 | 175.71 |
| **w**  | Argument of Perigee (rad) | 0.6796 | -3.099 | 0.6796 | -0.8878 | 0.2956 | 0.6308 | 0.3116 | -2.3840 |
| **omegadot**  | Rate of Right Ascension (rad/s) | -8.012e-09 | 7.809e-09 | -8.012e-09 | -8.668e-09 | -8.311e-09 | -8.024e-09 | 7.994e-09 | 8.022e-09 |
| **idot**  | Rate of Inclination Angle (rad/s) | 4.889e-10 | -1.557e-10 | 4.889e-10 | 3.000e-11 | -4.175e-10 | 3.571e-13 | 3.214e-11 | 1.035e-10 |

## Task 4 - Position and Velocity Estimation

**Fig. 5** to **Fig. 12** show the results of using pseudorange measurements from tracking to implement the Weighted Least Squares (WLS) algorithm and Ordinary Least Squares (OLS) to compute the user's position and velocity. The WLS algorithm relies on accurate pseudorange measurements from multiple satellites to calculate the user's position.
By comparing the processing results of Urban and OpenSky, it can be observed that due to the presence of multipath effects, the position and velocity estimates for OpenSky are more accurate. In contrast to the OLS algorithm, the WLS algorithm provides higher accuracy.

## OpenSky Position
<div align="center">
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/OpenskyPosWLS.png" width="800">
    <figcaption><b>Fig. 5</b></figcaption>
  </figure>
  
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/OpenskyPosVarWLS.png" width="800">
    <figcaption><b>Fig. 6</b></figcaption>
  </figure>

## OpenSky Velocity  
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/OpenskyVelWLS.png" width="800">
    <figcaption><b>Fig. 7</b></figcaption>
  </figure>
  
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/OpenskyVelVarWLS.png" width="800">
    <figcaption><b>Fig. 8</b></figcaption>
  </figure>
  
## Urbn Position  
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/UrbanPosWLS.png" width="800">
    <figcaption><b>Fig. 9</b></figcaption>
  </figure>
  
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/UrbanPosVarWLS.png" width="800">
    <figcaption><b>Fig. 10</b></figcaption>
  </figure>
 
## Urban Velocity   
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/UrbanVelWLS.png" width="800">
    <figcaption><b>Fig. 11</b></figcaption>
  </figure>

  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/UrbanVarWLS.png" width="800">
    <figcaption><b>Fig. 12</b></figcaption>
  </figure>
</div>



## Task 5 - Kalman Filter-Based Positioning
In this task, we develop an Extended Kalman Filter (EKF) using pseudorange and Doppler measurements to estimate user position and velocity. **Fig. 13** to **Fig. 20**  show the estimated results for position and velocity.

## OpenSky Position
<div align="center">
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/OpenskyPosEKF.png" width="800">
    <figcaption>
      <b>Fig. 13</b>
    </figcaption>
  </figure>
</div>

<div align="center">
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/OpenskyPosVarEKF.png" width="800">
    <figcaption>
      <b>Fig. 14</b>
    </figcaption>
  </figure>
</div>

## OpenSky Velocity 
<div align="center">
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/OpenskyVelEKF.png" width="800">
    <figcaption>
      <b>Fig. 15</b>
    </figcaption>
  </figure>
</div>

<div align="center">
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/OpenskyVelVarEKF.png" width="800">
    <figcaption>
      <b>Fig. 16</b>
    </figcaption>
  </figure>
</div>


## Urban Position
<div align="center">
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/UrbanPosEKF.png" width="800">
    <figcaption>
      <b>Fig. 17</b>
    </figcaption>
  </figure>
</div>

<div align="center">
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/UrbanPosVarEKF.png" width="800">
    <figcaption>
      <b>Fig. 18</b>
    </figcaption>
  </figure>
</div>

## Urban Velocity
<div align="center">
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/UrbanVelEKF.png" width="800">
    <figcaption>
      <b>Fig. 19</b>
    </figcaption>
  </figure>
</div>

<div align="center">
  <figure>
    <img src="https://github.com/HANG0413/AAE6102-Assignment1/blob/master/UrbanVarEKF.png" width="800">
    <figcaption>
      <b>Fig. 20</b>
    </figcaption>
  </figure>
</div>


## References

[1] B. Xu and L.-T. Hsu, ‘Open-source MATLAB code for GPS vector tracking on a software-defined receiver’, *GPS Solut*, vol. 23, no. 2, p. 46, Apr. 2019, doi: [10.1007/s10291-019-0839-x](https://doi.org/10.1007/s10291-019-0839-x).

[2] H.-F. Ng, G. Zhang, K.-Y. Yang, S.-X. Yang, and L.-T. Hsu, ‘Improved weighting scheme using consumer-level GNSS L5/E5a/B2a pseudorange measurements in the urban area’, *Advances in Space Research*, vol. 66, no. 7, pp. 1647–1658, Oct. 2020, doi: [10.1016/j.asr.2020.06.002](https://doi.org/10.1016/j.asr.2020.06.002).

[3] OpenAI. (2025, March 13). ChatGPT model response on implementing Weighted Least Squares (WLS) for user position and velocity estimation. Retrieved from https://www.openai.com/chatgpt.
