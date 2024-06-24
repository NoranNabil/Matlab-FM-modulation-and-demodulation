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
%%%%%%%%%%%%%%%%%%%%%%%% single tone fm modulation %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%% SNRi=40db %%%%%%%%%%%
SNRi=40;
%%%%%%%% 1- deiviation ratio=3
pm=0.5;
fm=fc;
deiviation_ratio=3;
freq_deviaiton=deiviation_ratio*fm;
WBFM_t_1=fmmod(upsampled,FC,fs,freq_deviaiton);
Yin_1=WBFM_t_1+awgn(WBFM_t_1,SNRi,pm);
Vout_1=fmdemod(Yin_1,FC,fs,freq_deviaiton);
%sound(Vout_1,fs);
%%%%%%%% 2- deiviation ratio=5
deiviation_ratio=5;
freq_deviaiton=deiviation_ratio*fm;
WBFM_t_2=fmmod(upsampled,FC,fs,freq_deviaiton);
Yin_2=WBFM_t_2+awgn(WBFM_t_2,SNRi,pm);
Vout_2=fmdemod(Yin_2,FC,fs,freq_deviaiton);
%sound(Vout_2,fs);

%%%%%%%%%%% SNRi=30db %%%%%%%%%%%
SNRi=30;
%%%%%%%% 1- deiviation ratio=3
deiviation_ratio=3;
freq_deviaiton=deiviation_ratio*fm;
WBFM_t_3=fmmod(upsampled,FC,fs,freq_deviaiton);
Yin_3=WBFM_t_3+awgn(WBFM_t_3,SNRi,pm);
Vout_3=fmdemod(Yin_3,FC,fs,freq_deviaiton);
%sound(Vout_3,fs);
%%%%%%%% 2- deiviation ratio=5
deiviation_ratio=5;
freq_deviaiton=deiviation_ratio*fm;
WBFM_t_4=fmmod(upsampled,FC,fs,freq_deviaiton);
Yin_4=WBFM_t_4+awgn(WBFM_t_4,SNRi,pm);
Vout_4=fmdemod(Yin_4,FC,fs,freq_deviaiton);
%sound(Vout_3,fs);

%%%%%%%%%%% SNRi=10db %%%%%%%%%%%
SNRi=40;
%%%%%%%% 1- deiviation ratio=3
deiviation_ratio=3;
freq_deviaiton=deiviation_ratio*fm;
WBFM_t_5=fmmod(upsampled,FC,fs,freq_deviaiton);
Yin_5=WBFM_t_5+awgn(WBFM_t_5,SNRi,pm);
Vout_5=fmdemod(Yin_5,FC,fs,freq_deviaiton);
%sound(Vout_5,fs);
%%%%%%%% 2- deiviation ratio=5
deiviation_ratio=5;
freq_deviaiton=deiviation_ratio*fm;
WBFM_t_6=fmmod(upsampled,FC,fs,freq_deviaiton);
Yin_6=WBFM_t_6+awgn(WBFM_t_6,SNRi,pm);
Vout_6=fmdemod(Yin_6,FC,fs,freq_deviaiton);
%sound(Vout_6,fs);

%%%%%%%%%%%%%%%%%%%%%%%%%% Threshold effect %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pm=0.5;
fm=fc;
deiviation_ratio=1;

SNR_bb=25;
No=1/(2*fm*10^(SNR_bb/10))
Bt=2*fm*(1+deiviation_ratio);
B=FC+Bt/2;
SNRi=1/(2*No*B);
SNRi=10*log10(SNRi);
SNRth=10*log10(20*(1+deiviation_ratio))
SNRo=10*log10(3*(deiviation_ratio^2)*(0.5/max(abs(upsampled))^2)*SNR_bb)

freq_deviaiton=deiviation_ratio*fm;
WBFM=fmmod(upsampled,FC,fs,freq_deviaiton);
Yin=WBFM+awgn(WBFM,SNRi,pm);
Vout=fmdemod(Yin,FC,fs,freq_deviaiton);

sound(Vout,fs);




