%preparing siganl
[signall,fs]=audioread("D:test2.wav");
n=length(signall);

%filtering 
fc=3400;
filter1=fir1(50,2*fc/fs,'low');
filteredsignal=filtfilt(filter1,1,signall);

%upsampling
upsampled=interp(filteredsignal,4);
fs=4*fs;
n=4*n;
T=0:1/fs:10-1/fs;
F=(-n/2:n/2-1)*fs/n;

FC=48000;
% %%%%%%%%%%%%%%%%%% FM modulation %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% 1- deiviation ratio=3
fm=fc;
deiviation_ratio=3;
freq_deviaiton=deiviation_ratio*fm;
WBFM_t_1=fmmod(upsampled,FC,fs,freq_deviaiton);
WBFM_f_1=abs(fftshift(fft(WBFM_t_1,n)))/n;

%%%%%%%% 2- deiviation ratio=5
deiviation_ratio=5;
freq_deviaiton=deiviation_ratio*fm;
WBFM_t_2=fmmod(upsampled,FC,fs,freq_deviaiton);
WBFM_f_2=abs(fftshift(fft(WBFM_t_2,n)))/n;

%%%%%%%%%%%%%%%%%%%% FM demoduation-direct method %%%%%%%%%%%%%%%%%%%%%%%%%
t=0:1/fs:10-2/fs;
f=(-n/2:n/2-2)*fs/n;

%%%%%%%% 1- deiviation ratio=3
Y_t_1=diff(WBFM_t_1);
V_t_1=Y_t_1.*(Y_t_1>0);

WBFM_rec_t_1=filtfilt(filter1,1,V_t_1);
%sound(WBFM_rec_t_1,fs); %%%%% play back
WBFM_rec_f_1=abs(fftshift(fft(WBFM_rec_t_1,n-1)))/(n-1);

%%%%%%%% 1- deiviation ratio=5
Y_t_2=diff(WBFM_t_2);
V_t_2=Y_t_2.*(Y_t_2>0);

WBFM_rec_t_2=filtfilt(filter1,1,V_t_2);
%sound(WBFM_rec_t_2,fs); %%%%% play back
WBFM_rec_f_2=abs(fftshift(fft(WBFM_rec_t_2,n-1)))/(n-1);

% figure();
% subplot(2,2,1);
% plot(t,WBFM_rec_t_1);
% xlabel("Time(sec)");
% ylabel("Amplitude(V)");
% title("Beta=3 FM demodulated signal Time domian plot");
% 
% subplot(2,2,3);
% plot(t,WBFM_rec_t_2);
% xlabel("Time(sec)");
% ylabel("Amplitude(V)");
% title("Beta=5 FM demodulated signal Time domian plot");
% 
% subplot(2,2,2);
% plot(f,WBFM_rec_f_1);
% xlabel("Frequency(HZ)");
% ylabel("Amplitude");
% title("Beta=3 FM demodulated signal Frequency domian plot");
% 
% subplot(2,2,4);
% plot(f,WBFM_rec_f_2);
% xlabel("Frequency(HZ)");
% ylabel("Amplitude");
% title("Beta=5 FM demodulated signal Frequency domian plot");

% %%%%%%%%%%%%%%%%%% FM single tone modulation %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% 1- deiviation ratio=3
deiviation_ratio=3;
fm=3000;
freq_deviaiton=deiviation_ratio*fm;
m_t=sin(2*pi*fm*T);
ST_WBFM_t_1=fmmod(m_t,FC,fs,freq_deviaiton);
ST_WBFM_f_1=abs(fftshift(fft(ST_WBFM_t_1,n)))/n;

%%%%%%%% 2- deiviation ratio=5
deiviation_ratio=5;
freq_deviaiton=deiviation_ratio*fm;

ST_WBFM_t_2=fmmod(m_t,FC,fs,freq_deviaiton);
ST_WBFM_f_2=abs(fftshift(fft(ST_WBFM_t_2,n)))/n;

%%%%%%%%%%%%%%%%%%%%%%%%%%% Plots %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% Time domain
figure();

subplot(2,2,1);
plot(T(4.2*fs:4.2015*fs),WBFM_t_1(4.2*fs:4.2015*fs));
xlabel("Time(sec)");
ylabel("Amplitude(V)");
title("Beta=3 Modulated signal Time domian plot");

subplot(2,2,3);
plot(T(4.2*fs:4.2015*fs),WBFM_t_2(4.2*fs:4.2015*fs));
xlabel("Time(sec)");
ylabel("Amplitude(V)");
title("Beta=5 Modulated signal Time domian plot");
 
subplot(2,2,2);
plot(T(4.2*fs:4.2015*fs),ST_WBFM_t_1(4.2*fs:4.2015*fs));
xlabel("Time(sec)");
ylabel("Amplitude(V)");
title("Single tone-Modulated signal with B=3 in Time domian");

subplot(2,2,4);
plot(T(4.2*fs:4.2015*fs),ST_WBFM_t_2(4.2*fs:4.2015*fs));
xlabel("Time(sec)");
ylabel("Amplitude(V)");
title("Single tone-Modulated signal with B=5 in Time domian");

%%%%%%% Frequency domain
figure();

subplot(2,2,1);
plot(F,WBFM_f_1);
xlabel("Frequency(HZ)");
ylabel("Amplitude");
title("Beta=3 Modulated signal Frequency domian plot");

subplot(2,2,3);
plot(F,WBFM_f_2);
xlabel("Frequency(HZ)");
ylabel("Amplitude");
title("Beta=5 Modulated signal Frequency domian plot");

subplot(2,2,2);
plot(F,ST_WBFM_f_1);
xlabel("Frequency in HZ");
ylabel("Amplitude");
title("Single tone FM modulated signal with B=3 Frequency domian plot");

subplot(2,2,4);
plot(F,ST_WBFM_f_2);
xlabel("Frequency(HZ)");
ylabel("Amplitude");
title("Single tone FM modulated signal with B=5 Frequency domian plot");
