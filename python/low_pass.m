function b = low_pass(Fs,Fpass,Fstop)
%UNTITLED 返回离散时间滤波器对象。

% MATLAB Code
% Generated by MATLAB(R) 9.12 and Signal Processing Toolbox 9.0.
% Generated on: 04-Sep-2022 18:46:50

% Equiripple Lowpass filter designed using the FIRPM function.

% All frequency values are in kHz.
%Fs = 32000;  % Sampling Frequency

%Fpass = 3000;               % Passband Frequency
%Fstop = 4000;               % Stopband Frequency
Dpass = 0.057501127785;  % Passband Ripple
Dstop = 0.001;           % Stopband Attenuation
dens  = 20;              % Density Factor

% Calculate the order from the parameters using FIRPMORD.
[N, Fo, Ao, W] = firpmord([Fpass, Fstop]/(Fs/2), [1 0], [Dpass, Dstop]);
Fs
Fpass 
Fstop
N
Fo
Ao 
W 
% Calculate the coefficients using the FIRPM function.
b  = firpm(N, Fo, Ao, W, {dens});
%Hd = dfilt.dffir(b);

% [EOF]
