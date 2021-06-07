%% EN 4420 Advance Signal Processing - M-Fold Interpolator 2021
% Author : K.G. Abeywardena
% Index  : 160005C
% Date   : 26/02/2021
% Email  : kalanag@uom.lk
%% Initial Paramters
clc;
clear all;
close all;
set(groot,'defaultAxesXGrid','on')
set(groot,'defaultAxesYGrid','on')
set(0, 'DefaultLineLineWidth', 1.0);

OsI = 2*pi*100;                         % rad/s
TsI = 2*pi/OsI;                         % s
Omega0 = 2*pi*30;                       % rad/s

N = 1001;                               % samples
M = 4;                                  % upsample factor

% after upsampled parameters
Ts = TsI/M;
Os = OsI*M; 
%% Input Signal
close all;
n = 0:N-1;                              % discrete time vector
t = 0:TsI:N-1;
xn = 2*cos(Omega0*TsI*n);
xt = 2*cos(Omega0*TsI*t);

figure
stem(n, xn, 'MarkerSize',5, 'LineWidth', 1.0); axis tight;
xlabel('n'); ylabel('Amplitude');

hold on;
plot(t,xt); axis tight;
axis([180 225 -2.1 2.1]);
legend('Input Signal','Envelop of Input Signal');

title('Input Signal (x[n]) - Time domain');

Xw = fftshift(fft(xn)/N);
fxn = [-N/2:N/2-1]*(2/N);

figure
subplot(2,1,1)
plot(fxn, abs(Xw)); axis tight;
xlabel('Normalized Frequency ( \times \pi rad/sample)'); ylabel('Magnitude');
axis([-1 1 0 1]);
title(strcat(['Magnitude Spectrum of Input Signal x[n]']));

subplot(2,1,2)
plot(fxn, unwrap(angle(Xw)));
xlabel('Normalized Frequency ( \times \pi rad/sample)'); ylabel('Phase (radians)');
title(strcat(['Phase Spectrum of Input Signal x[n]']));

%% FIR Filter Design
clc;
close all;

% Question 01 - Derived Specifications

PassGain = M; StopGain = 0;
CutOff = (pi/M)/Ts;                     % rad/s
BT = 0.2*pi/Ts;                         % rad/s
PassEdge = CutOff - BT/2;               % rad/s
StopEdge = CutOff + BT/2;               % rad/s
Norm = 2*pi;
Ap = 0.1;                               % Passband Ripple (dB)
Aa30 = 30;                              % Stopband attenuation 1 (dB)
Aa60 = 60;                              % Stopband attenuation 2 (dB)

cutoffs = [PassEdge/Norm StopEdge/Norm];    % Edge freqs (Hz)
gains = [1 StopGain];                       % Passband and Stopband gain

% Question 02 - Designing Even-Order Linear Anti-Imaging Filters
% Question 03 - Visualization of the filters

% H_30(z)
deltaP = (10^(0.05*Ap)-1)/(10^(0.05*Ap)+1);
deltaA = 10^(-0.05*Aa30);
dev30 = [deltaP deltaA];                    % Ripple (%)

[o30, w30, beta30, typ30] = kaiserord(cutoffs, gains, dev30, Os/Norm);
o30 = o30 + rem(o30, 2);

K30 = kaiser(o30 + 1, beta30);

figure
stem(0:o30,K30)
xlabel('n'); ylabel('Amplitude');
xlim([0 o30+1]);
title('Kaiser Window - Time Domain');

hnb30 = PassGain*fir1(o30, w30, typ30, K30, 'noscale'); % adjusting the gain 
[H30, W30] = freqz(hnb30,1);

% Visulaizing the Magnitude and Phase responses of the filter H_30(w)
figure;

subplot(2,1,1);
Om = W30/pi;
logH30 = 20*log10(abs(H30));                % Magnitude of Filter in dB
plot(Om,logH30, '-b'); hold on;
axis([0 1 -120 15]);

vertLine = get(gca, 'YLim');
line( [PassEdge*(Ts/pi) PassEdge*(Ts/pi)], vertLine, 'Color','red','LineStyle','-.'); hold on;
line( [StopEdge*(Ts/pi) StopEdge*(Ts/pi)], vertLine, 'Color','red','LineStyle','-.'); hold on;
line( [CutOff*(Ts/pi) CutOff*(Ts/pi)], vertLine, 'Color','yellow','LineStyle','-.')

xlabel('Normalized Frequency ( \times \pi rad/sample)');
ylabel('Magnitude (dB)'); 
title(strcat(('Causal Filter Magnitude Response of H_{30}(w) - Frequency Domain')));

subplot(2,1,2);

PhaseH30 = unwrap(angle(H30));                % Phase of Filter
plot(Om,PhaseH30, '-b'); hold on;
axis([0 1 -15 0]);

vertLine = get(gca, 'YLim');
line( [PassEdge*(Ts/pi) PassEdge*(Ts/pi)], vertLine, 'Color','red','LineStyle','-.'); hold on;
line( [StopEdge*(Ts/pi) StopEdge*(Ts/pi)], vertLine, 'Color','red','LineStyle','-.'); hold on;
line( [CutOff*(Ts/pi) CutOff*(Ts/pi)], vertLine, 'Color','yellow','LineStyle','-.')

xlabel('Normalized Frequency ( \times \pi rad/sample)');
ylabel('Phase (radians)'); 
title(strcat(('Causal Filter Phase Response of H_{30}(w) - Frequency Domain')));

figure;
SF = 1; EF = round(CutOff);
w_pass = Om(SF:EF);
h_pass = logH30(SF:EF);
plot(w_pass,h_pass, '-k'); hold on;
plot(w_pass, ones(length(w_pass)) * (20*log10(M) + Ap/2),'-.b'); hold on;
plot(w_pass, ones(length(w_pass)) * (20*log10(M) - Ap/2),'-.b'); hold on;
plot(w_pass, ones(length(w_pass)) * 20*log10(M),'-.r');
axis([0,EF*(Ts/pi),20*log10(M)-0.1,20*log10(M)+0.1]);
xlabel('Normalized Frequency ( \times \pi rad/ssample)');
ylabel('Magnitude (dB)'); 
title('H_{30}(w) Passband - Frequency Domain')

fvtool(hnb30);

% H_60(z)

deltaP = (10^(0.05*Ap)-1)/(10^(0.05*Ap)+1);
deltaA = 10^(-0.05*Aa60);
dev60 = [deltaP deltaA];                    % Ripple (%)

[o60, w60, beta60, typ60] = kaiserord(cutoffs, gains, dev60, Os/Norm);
o60 = o60 + rem(o60, 2);

K60 = kaiser(o60 + 1, beta60);

figure
stem(0:o60,K60)
xlabel('n'); ylabel('Amplitude');
xlim([0 o60+1]);
title('Kaiser Window - Time Domain');

hnb60 = PassGain*fir1(o60, w60, typ60, K60, 'noscale');
[H60, W60] = freqz(hnb60,1);

% Visulaizing the Magnitude and Phase responses of the filter H_30(w)
figure;

subplot(2,1,1);
Om = W60/pi;
logH60 = 20*log10(abs(H60));                % Magnitude of Filter in dB
plot(Om,logH60, '-b'); hold on;
axis([0 1 -120 16]);

vertLine = get(gca, 'YLim');
line( [PassEdge*(Ts/pi) PassEdge*(Ts/pi)], vertLine, 'Color','red','LineStyle','-.'); hold on;
line( [StopEdge*(Ts/pi) StopEdge*(Ts/pi)], vertLine, 'Color','red','LineStyle','-.'); hold on;
line( [CutOff*(Ts/pi) CutOff*(Ts/pi)], vertLine, 'Color','yellow','LineStyle','-.')

xlabel('Normalized Frequency ( \times \pi rad/sample)');
ylabel('Magnitude (dB)'); 
title(strcat(('Causal Filter Magnitude Response of H_{60}(w) - Frequency Domain')));

subplot(2,1,2);

PhaseH30 = unwrap(angle(H60));                % Phase of Filter
plot(Om,PhaseH30, '-b'); hold on;
axis([0 1 -25 0]);

vertLine = get(gca, 'YLim');
line( [PassEdge*(Ts/pi) PassEdge*(Ts/pi)], vertLine, 'Color','red','LineStyle','-.'); hold on;
line( [StopEdge*(Ts/pi) StopEdge*(Ts/pi)], vertLine, 'Color','red','LineStyle','-.'); hold on;
line( [CutOff*(Ts/pi) CutOff*(Ts/pi)], vertLine, 'Color','yellow','LineStyle','-.')


xlabel('Normalized Frequency ( \times \pi rad/sample)');
ylabel('Phase (rad)'); 
title(strcat(('Causal Filter Phase Response of H_{60}(w) - Frequency Domain')));

figure;
SF = 1; EF = round(CutOff);
w_pass = Om(SF:EF);
h_pass = logH60(SF:EF);
plot(w_pass,h_pass, '-k'); hold on;
plot(w_pass, ones(length(w_pass)) * (20*log10(M) + Ap/2),'-.b'); hold on;
plot(w_pass, ones(length(w_pass)) * (20*log10(M) - Ap/2),'-.b'); hold on;
plot(w_pass, ones(length(w_pass)) * 20*log10(M),'-.r');
axis([0,EF*(Ts/pi),20*log10(M)-0.1,20*log10(M)+0.1]);
xlabel('Normalized Frequency ( \times \pi rad/sample)');
ylabel('Magnitude (dB)'); 
title('H_{60}(w) Passband - Frequency Domain')

fvtool(hnb60);
%% Computation of Interpolated Signals 
clc;
close all;

InterL = 4*N;                   % NOT SURE Currently its at 4004
un = upsample(xn, M);
un = un(1:InterL);
n = 0:InterL-1;

% H_30 Efficient Implementation

% Polyphase filters (type-I)
h30 = hnb30(1:M:end);           % 0 - Polyphase
h31 = hnb30(2:M:end);           % 1 - Polyphase
h32 = hnb30(3:M:end);           % 2 - Polyphase
h33 = hnb30(4:M:end);           % 3 - Polyphase 

fvtool(h30,1); 
fvtool(h31,1); 
fvtool(h32,1); 
fvtool(h33,1); 

% Filtered Polyphase components
f30 = filter(h30, 1, xn);           % Filtered input with 0 - Polyphase
f31 = filter(h31, 1, xn);           % Filtered input with 1 - Polyphase
f32 = filter(h32, 1, xn);           % Filtered input with 2 - Polyphase
f33 = filter(h33, 1, xn);           % Filtered input with 3 - Polyphase

% Upsampled sub-bands
y30 = upsample(f30, M);             % Upsampled output (samples 4004 with 3 0s added at the end)
y31 = upsample(f31, M);
y32 = upsample(f32, M);
y33 = upsample(f33, M);

% Delayed sub-bands
y30 = [zeros(1,0) y30];
y31 = [zeros(1,1) y31];
y32 = [zeros(1,2) y32];
y33 = [zeros(1,3) y33];

% Final Output from the efficient structure
y30n = zeros(1, InterL);

y30n = y30n + y30(1:InterL);
y30n = y30n + y31(1:InterL);
y30n = y30n + y32(1:InterL);
y30n = y30n + y33(1:InterL);

y30ref = filter(hnb30, 1, un);

figure
subplot(2,1,1)
stem(n, y30n, 'k.'); axis tight;
xlabel('n'); ylabel('Amplitude');
axis([0 100 -4.1 4.1]);
title('y_{30}[n] using Efficient Implementation');

subplot(2,1,2)
stem(n, y30ref, 'k.'); axis tight;
xlabel('n'); ylabel('Amplitude');
axis([0 100 -4.1 4.1]);
title('y_{30}[n] using Original Implementation');

% H_60 Efficient Implementation

% Polyphase filters (type-I)
h60 = hnb60(1:M:end);           % 0 - Polyphase
h61 = hnb60(2:M:end);           % 1 - Polyphase
h62 = hnb60(3:M:end);           % 2 - Polyphase
h63 = hnb60(4:M:end);           % 3 - Polyphase 

fvtool(h60,1); 
fvtool(h61,1); 
fvtool(h62,1); 
fvtool(h63,1); 

% Filtered Polyphase components
f60 = filter(h60, 1, xn);           % Filtered input with 0 - Polyphase
f61 = filter(h61, 1, xn);           % Filtered input with 1 - Polyphase
f62 = filter(h62, 1, xn);           % Filtered input with 2 - Polyphase
f63 = filter(h63, 1, xn);           % Filtered input with 3 - Polyphase

% Upsampled sub-bands
y60 = upsample(f60, M);             % Upsampled output (samples 4004 with 3 0s added at the end)
y61 = upsample(f61, M);
y62 = upsample(f62, M);
y63 = upsample(f63, M);

% Delayed sub-bands
y60 = [zeros(1,0) y60];
y61 = [zeros(1,1) y61];
y62 = [zeros(1,2) y62];
y63 = [zeros(1,3) y63];

% Final Output from the efficient structure
y60n = zeros(1, InterL);

y60n = y60n + y60(1:InterL);
y60n = y60n + y61(1:InterL);
y60n = y60n + y62(1:InterL);
y60n = y60n + y63(1:InterL);

y60ref = filter(hnb60, 1, un);

figure
subplot(2,1,1)
stem(n, y60n, 'k.'); axis tight;
xlabel('n'); ylabel('Amplitude');
axis([0 100 -4.1 4.1]);
title('y_{60}[n] using Efficient Implementation');

subplot(2,1,2)
stem(n, y60ref, 'k.'); axis tight;
xlabel('n'); ylabel('Amplitude');
axis([0 100 -4.1 4.1]);
title('y_{60}[n] using Original Implementation');
%% Question 5 - Visualizing the Spectra
clc;
close all;

ff = [-N/2:N/2-1]*(2/N);
fff = [-InterL/2:InterL/2-1]*(2/InterL);

Uw = fftshift(fft(un)/InterL);
Y3w = fftshift(fft(y30ref)/InterL);
Y6w = fftshift(fft(y60n)/InterL);

% Visualizing the magnitude spectra of x[n] and u[n]
figure;
subplot(2,1,1);
plot(ff, abs(Xw)); axis tight;
xlabel('Normalized Frequency ( \times \pi rads/sample)'); ylabel('Magnitude');
axis([-1 1 0 1]);
title(strcat(['Magnitude spectra of x[n]']));

subplot(2,1,2);
plot(fff, abs(Uw)); axis tight;
axis([-1 1 0 1]);
xlabel('Normalized Frequency ( \times \pi rads/sample)'); ylabel('Magnitude');
title(strcat(['Magnitude spectra of u[n]']));

% Visualizing the y_30[n] - magnitude and phase spectra
figure
subplot(2,1,1)
plot(fff, abs(Y3w)); axis tight;
axis([-1 1 0 1.1]);
xlabel('Normalized Frequency ( x \pi rads/sample)'); ylabel('Magnitude');
title(strcat(['Magnitude spectra of y_{30}[n]']));

subplot(2,1,2)
plot(fff, unwrap(angle(Y3w))); axis tight;
xlabel('Normalized Frequency ( x \pi rad/sample)'); ylabel('Phase (radians)');
title(strcat(['Phase spectra of y_{30}[n]']));

% Visualizing the y_60[n] - magnitude and phase spectra
figure
subplot(2,1,1)
plot(fff, abs(Y6w)); axis tight;
axis([-1 1 0 1.1]);
xlabel('Normalized Frequency ( \times \pi rads/sample)'); ylabel('Magnitude');
title(strcat(['Magnitude spectra of y_{60}[n]']));

subplot(2,1,2)
plot(fff, unwrap(angle(Y6w))); axis tight;
xlabel('Normalized Frequency ( \times \pi rad/sample)'); ylabel('Phase (radians)');
title(strcat(['Phase spectra of y_{60}[n]']));
%%
clc;
close all;

n = 0:1:InterL;
t = 0:Ts:InterL;

xun = 2*cos(Omega0*Ts*n);
xut = 2*cos(Omega0*Ts*t);

figure
stem(n, xun, 'LineWidth',1, 'MarkerSize',5); axis tight; hold on;
plot(t, xut);
xlabel('n'); ylabel('Amplitude');
axis([180 225 -2.1 2.1]);
legend('x_u[n]', 'Envelop of x_u[n]');
title('Reference Signal x_u[n]');

grpD3 = mean(grpdelay(hnb30));
grpD6 = mean(grpdelay(hnb60));

% Comparison of x_u[n] and y_30[n]
xun30 = xun(1:end-grpD3);                       % Removing the group delay
y3D = y30n;
y3D(1:grpD3) = [];
n3 = n(1:end-grpD3);

figure;
stem(n3(1:100), y3D(1:100), 'k'); hold on;
stem(n3(1:100), xun30(1:100), 'r.');
xlabel('n'); ylabel('Amplitude');
legend('y_{30}[n]','x_u[n]');
title(sprintf('Reference Signal and y_{30}[n] after Group Delay = %d samples removed',grpD3));

% Comparison of x_u[n] and y_60[n]
xun60 = xun(1:end-grpD6);                       % Removing the group delay
y6D = y60n;
y6D(1:grpD6) = [];
n6 = n(1:end-grpD6);

figure;
stem(n6(1:100), y6D(1:100), 'k'); hold on;
stem(n6(1:100), xun60(1:100), 'r.');
xlabel('n'); ylabel('Amplitude');
legend('y_{60}[n]','x_u[n]');
title(sprintf('Reference Signal and y_{60}[n] after Group Delay = %d samples removed',grpD6));

% RMSE comparison

% for y_30[n]
comp_xun30 = xun30(1000:3000);
comp_y30n = y3D(1000:3000);
RMSE30 = sqrt(mean((comp_xun30 - comp_y30n).^2));
fprintf('RMSE comparing x_u[n] and y_{30}[n] after adjusting group delay = %f\n', RMSE30);

% for y_60[n]
comp_xun60 = xun60(1000:3000);
comp_y60n = y6D(1000:3000);
RMSE60 = sqrt(mean((comp_xun60 - comp_y60n).^2));
fprintf('RMSE comparing x_u[n] and y_{60}[n] after adjusting group delay = %f', RMSE60);