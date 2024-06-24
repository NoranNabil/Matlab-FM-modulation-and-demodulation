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
t=0:1/fs:10-1/fs;
f=(-n/2:n/2-1)*fs/n;

%%%%%%%%%%%%%%%%%%%%%%%%%% DSB_SC modulation %%%%%%%5%%%%%%%%%%%%%%%%%%%%%%
%carrier
Fc=48000;
Ac=1;
trans_carrier=Ac*cos(2*pi*Fc*t);

DSB_t=trans_carrier'.*upsampled;
DSB_f=abs(fftshift(fft(DSB_t,n)))/n;

%%%%%%%%%%%%%%%%%%%% DSB_SC coherent demodulation %%%%%%%%%%%%%%%%%%%%%%%%%
rec_carrier=trans_carrier;
V_t=DSB_t'.*rec_carrier;

rec_DSB_t=filtfilt(filter1,1,V_t);
%sound(rec_DSB_t,fs);    %%%% play back
rec_DSB_f=abs(fftshift(fft(rec_DSB_t,n)))/n;

%%%%%%%%%DSB_SC coherent demodulation- receiver frequency offest effect%%%%%%%%%
f_shift=200;
Ac=1;
carrier_shift=Ac*cos(2*pi*(Fc+f_shift)*t);

V_t_shift=DSB_t'.*carrier_shift;

rec_DSB_t_shift=filtfilt(filter1,1,V_t_shift);
%sound(rec_DSB_t_shift,fs); %%%%% play back
rec_DSB_f_shift=abs(fftshift(fft(rec_DSB_t_shift,n)))/n;

%%%%%%%%%%%%%%%%%%%%%%%%%% SSB_SC modulation %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ac=1;
Fc=48000;
carrier_1=Ac*cos(2*pi*Fc*t);
carrier_2=Ac*sin(2*pi*Fc*t);

m_t=upsampled;
m_t_h=imag(hilbert(m_t,n));

SSB_t=m_t'.*carrier_1+m_t_h'.*carrier_2; %%% LSB
SSB_f=abs(fftshift(fft(SSB_t,n)))/n;

%%%%%%%%%%%%%%%%%%%%%%% SSB_LSB coherent demodulation %%%%%%%%%%%%%%%%%%%%%
rec_carrier=carrier_1;
Y_t=SSB_t.*rec_carrier;

rec_SSB_t=filtfilt(filter1,1,Y_t);
%sound(rec_SSB_t,fs); %%%%% play back

rec_SSB_f=abs(fftshift(fft(rec_SSB_t,n)))/n;

%%%%%%%%% SSB-LSB coherent demodulation- receiver phase shift effect%%%%%%%
f_shift=50;
Ac=1;
carrier_shift=Ac*cos(2*pi*(Fc+f_shift)*t);

Y_t_shift=SSB_t.*carrier_shift;

rec_SSB_t_shift=filtfilt(filter1,1,Y_t_shift);
%sound(rec_SSB_t_shift,fs); %%%%% play back

rec_SSB_f_shift=abs(fftshift(fft(rec_SSB_t_shift,n)))/n;

%%%%%%%%%%%%%%%%%%%%%% plots %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Time
figure();
%%% 1-DSB_SC mod
subplot(2,2,1);
plot(t,DSB_t);
xlabel("Time (sec)");
ylabel("Amplitude (V)");
title("DSB-SC Modulated signal Time domian plot");
%%% 2-DSB_SC coherent demod
subplot(2,2,3);
plot(t,rec_DSB_t);
xlabel("Time (sec)");
ylabel("Amplitude (V)");
title("DSB-SC Demodulated signal Time domian plot");
%%% 3-SSB mod
subplot(2,2,2);
plot(t,SSB_t);
xlabel("Time(sec)");
ylabel("Amplitude(V)");
title("SSB-LSB Modulated signal Time domian plot");
%%% 4-SSB demod
subplot(2,2,4);
plot(t,rec_SSB_t);
xlabel("Time(sec)");
ylabel("Amplitude(V)");
title("SSB-LSB demodulated signal Time domian plot");
%%%%%%%%%%%%%%%%%%%%%%% Frequency
figure();
%%% 1-DSB_SC mod
subplot(2,2,1);
plot(f,DSB_f);
xlabel("Frequency (HZ)");
ylabel("Amplitude");
title("DSB-SC Modulated signal Frequency domian plot");
%%% 2-DSB_sc coherent demod
subplot(2,2,3);
plot(f,rec_DSB_f);
xlabel("Frequency (HZ)");
ylabel("Amplitude");
title("DSB-SC Demodulated signal Frequency domian plot");
%%% 3-SSB mod
subplot(2,2,2);
plot(f,SSB_f);
xlabel("Frequency(HZ)");
ylabel("Amplitude");
title("SSB-LSB Modulated signal Frequency domian plot");
%%% 4-SSB demod
subplot(2,2,4);
plot(f,rec_SSB_f);
xlabel("Frequency(HZ)");
ylabel("Amplitude");
title("SSB-LSB demodulated signal Frequency domian plot");




