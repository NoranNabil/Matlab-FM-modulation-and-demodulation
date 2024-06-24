%%%%%%%%%%%%%%%% signal recording %%%%%%%%%%%%%%%%%%%%%
%signal = audiorecorder(48000, 8, 1);
%recordblocking(signal, 10);
%play(signal);
%data=getaudiodata(signal);
%audiowrite("D:test2.wav",data,48000);

%%%%%%%%%%%%%% singal reading %%%%%%%%%%%%%%%%%%%%%%%%
[signall,fs]=audioread("D:test2.wav");
%sound(signall,fs); %%%%%%%%%%% signal playback

n=length(signall);
t=0:1/fs:n/fs-1/fs;
f=(-n/2:n/2-1)*fs/n; 

Signall=abs(fftshift(fft(signall,n)))/n;
%%%%%%%%%%%%%% signal filterig %%%%%%%%%%%%%%%%%%%%%%
%%%%1-f_cutoff=3400
fc=3400;
filter=fir1(120,2*fc/fs,'low');
filteredsignal=filtfilt(filter,1,signall);
%sound(filteredsignal,fs); %%%%%%%%%%% signal playback
Filteredsignal=abs(fftshift(fft(filteredsignal,n)))/n;

%%%%2-f_1=2900
fc_1=2900; 
filter1=fir1(120,2*fc_1/fs,'low');
filteredsignal_1=filtfilt(filter1,1,signall);
%sound(filteredsignal_1,fs); %%%%%%%%%%% signal playback
Filteredsignal_1=abs(fftshift(fft(filteredsignal_1,n)))/n;

%%%%2-f_2=1800
fc_2=1800; 
filter2=fir1(120,2*fc_2/fs,'low');
filteredsignal_2=filtfilt(filter2,1,signall);
%sound(filteredsignal_smaller,fs); %%%%%%%%%%% signal playback
Filteredsignal_2=abs(fftshift(fft(filteredsignal_2,n)))/n;

%%%%3-f_unintel=600
fc_unintel=400; 
filter3=fir1(120,2*fc_unintel/fs,'low');
filteredsignal_unintel=filtfilt(filter3,1,signall);
%sound(filteredsignal_unintel,fs); %%%%%%%%%%% signal playback
Filteredsignal_unintel=abs(fftshift(fft(filteredsignal_unintel,n)))/n;

%%%%%%%%%%%%%%%%%% letters %%%%%%%%%%%%%%%%%%%%%%%%
%%%1-"F"
[f_letter,fs]=audioread("D:f.wav");
n_f=length(f_letter);
t_f=0:1/fs:n_f/fs-1/fs;

filtered_f=filtfilt(filter,1,f_letter); %%% using Fc=3.4 KHZ 
%sound(filtered_f,fs);

filter_un=fir1(120,2*1800/fs,'low');
unintel_f=filtfilt(filter_un,1,f_letter);
%sound(unintel_f,fs); %%%%%uninteligllible "F" AT fc=1.8KHZ
  
%%%2-"S"
[s_letter,fs]=audioread("D:s.wav");
n_s=length(s_letter);
t_s=0:1/fs:n_s/fs-1/fs;

%sound(s_letter,fs);

filtered_s=filtfilt(filter,1,s_letter); %%% using Fc=3.4 KHZ 
%sound(filtered_s,fs);

filter_un=fir1(120,2*1100/fs,'low');
unintel_s=filtfilt(filter_un,1,s_letter); %at fc=1.1KHZ
%sound(unintel_s,fs);

%%%3-"B"
[b_letter,fs]=audioread("D:b.wav");
n_b=length(b_letter);
t_b=0:1/fs:n_b/fs-1/fs;

%sound(b_letter,fs);

filtered_b=filtfilt(filter,1,b_letter); %%% using Fc=3.4 KHZ 
%sound(filtered_b,fs);

filter_un=fir1(120,2*300/fs,'low');
unintel_b=filtfilt(filter_un,1,b_letter); %at fc=0.3KHZ
%sound(unintel_b,fs);


%%%4-"D"
[d_letter,fs]=audioread("D:d.wav");
n_d=length(d_letter);
t_d=0:1/fs:n_d/fs-1/fs;

%sound(d_letter,fs);

filtered_d=filtfilt(filter,1,d_letter); %%% using Fc=3.4 KHZ 
%sound(filtered_d,fs);

filter_un=fir1(120,2*300/fs,'low');
unintel_d=filtfilt(filter_un,1,d_letter); %at fc=0.3KHZ
%sound(unintel_d,fs);

%%%5-"M"
[m_letter,fs]=audioread("D:m.wav");
n_m=length(m_letter);
t_m=0:1/fs:n_m/fs-1/fs;

%sound(m_letter,fs);

filtered_m=filtfilt(filter,1,m_letter); %%% using Fc=3.4 KHZ 
%sound(filtered_m,fs);

filter_un=fir1(120,2*150/fs,'low');
unintel_m=filtfilt(filter_un,1,m_letter); %at fc=0.15KHZ
%sound(unintel_m,fs);

%%%6-"N"
[n_letter,fs]=audioread("D:n.wav");
n_n=length(n_letter);
t_n=0:1/fs:n_n/fs-1/fs;

%sound(n_letter,fs);

filtered_n=filtfilt(filter,1,n_letter); %%% using Fc=3.4 KHZ 
%sound(filtered_n,fs);

filter_un=fir1(120,2*200/fs,'low');
unintel_n=filtfilt(filter_un,1,n_letter); %at fc=0.2KHZ
%sound(unintel_n,fs);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%% upsampling%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
upsampled=interp(filteredsignal,4);
Fs=4*fs;
N=4*n;
T=0:1/Fs:10-1/Fs;
F=(-N/2:N/2-1)*Fs/N;
Upsampled=abs(fftshift(fft(upsampled,N)))/N;
%%%%%%%%%%%%%%%%%%%%%%%%%%%% DSB_LC modulation%%%%%%%%%%%%%%%%%%%%%%%
Fc=48000;
carrier=cos(2*pi*Fc*T);
modulation_index=.8;
Ac=max(abs(upsampled))/modulation_index;
modulated=(Ac+upsampled).*carrier';

%%%%%%%%%%%%%%%%%%%%% demodulation %%%%%%%%%%%%%%%%%%%%%%%%%
demodulated=modulated.*(modulated>0);
demodulated=filtfilt(filter,1,demodulated)-mean(demodulated);
%sound(demodulated,Fs); 
Demodulated=abs(fftshift(fft(demodulated,N)))/N;

Energy_signal=sum(Upsampled.^2);
Energy_demodulated=sum(Demodulated.^2);

demodulated=demodulated/sqrt(Energy_demodulated/Energy_signal);
Demodulated=abs(fftshift(fft(demodulated,N)))/N;
Energy_demodulated=sum(Demodulated.^2);
%sound(demodulated,Fs);

%%%%%%%%%%%%%%  Time domain plots %%%%%%%%%%%%%%%%%%%%
figure();
%% 1-orginal signal
subplot(7,2,1);
plot(t,signall);
xlabel("Time (sec)");
ylabel("Amplitude (V)");
title("Original signal in time domian");
%% 2-filtered signal at fc=3.4Khz
subplot(7,2,3);
plot(t,filteredsignal);
xlabel("Time in sec");
ylabel("Amplitude (V)");
title("Filtered signal in Time domian plot");
%% 3-filtered signal at fc_1=2.9Khz
subplot(7,2,5);
plot(t,filteredsignal_1);
xlabel("Time in sec");
ylabel("Amplitude (V)");
title("FC=2.9KHZ Filtered signal in Time domian plot");
%% 4-filtered signal at fc_2=1.8Khz
subplot(7,2,7);
plot(t,filteredsignal_2);
xlabel("Time in sec");
ylabel("Amplitude (V)");
title("FC=1.8KHZ Filtered signal in Time domian plot");
%% 5-filtered signal at fc_unintell=600hz
subplot(7,2,9);
plot(t,filteredsignal_unintel);
xlabel("Time in sec");
ylabel("Amplitude (V)");
title("Unintelligible Filtered signal in Time domian plot");
%% 6-letter f 
subplot(7,2,11);
plot(t_f,unintel_f);
xlabel("Time (sec)");
ylabel("Amplitude (V)");
title("Unintelligible Filtered Letter F in time domain");
%% 7-letter s
subplot(7,2,13);
plot(t_s,unintel_s);
xlabel("Time (sec)");
ylabel("Amplitude (V)");
title("Unintelligible Filtered Letter S in time domain");
%% 8-letter b
subplot(7,2,2);
plot(t_b,unintel_b);
xlabel("Time (sec)");
ylabel("Amplitude (V)");
title("Unintelligible Filtered Letter B in time domain");
%% 9-letter d
subplot(7,2,4);
plot(t_d,unintel_d);
xlabel("Time (sec)");
ylabel("Amplitude (V)");
title("Unintelligible Filtered Letter D in time domain");
%% 10-letter m
subplot(7,2,6);
plot(t_m,unintel_m);
xlabel("Time (sec)");
ylabel("Amplitude (V)");
title("Unintelligible Filtered Letter M in time domain");
%% 10-letter n
subplot(7,2,8);
plot(t_n,unintel_n);
xlabel("Time (sec)");
ylabel("Amplitude (V)");
title("Unintelligible Filtered Letter N in time domain");
%% 11-modulated
subplot(7,2,10);
plot(T,modulated);
xlabel("Time (sec)");
ylabel("Amplitude (V)");
title("Modulated signal in Time domian");
%% 12-demodulation
subplot(7,2,12);
plot(T,demodulated);
xlabel("Time (sec)");
ylabel("Amplitude (V)");
title("Demodulated signal in Time domian");

%%%%%%%%%%%%%%  Frequency domain plots %%%%%%%%%%%%%%%%%%%%
figure();
%% 1-orginal signal
subplot(7,2,1);
plot(f,Signall);
xlabel("Frequency (HZ)");
ylabel("Amplitude");
title("Original signal in frequency domian");
%% 2-filtered signal at fc=3.4khz
subplot(7,2,3);
plot(f,Filteredsignal);
xlabel("Frequency in HZ");
ylabel("Amplitude");
title("Filtered signal Frequency domian plot");
%% 3-filtered signal at fc=2.9khz
subplot(7,2,5);
plot(f,Filteredsignal_1);
xlabel("Frequency in HZ");
ylabel("Amplitude");
title("FC=2.9KHZ Filtered signal Frequency domian plot");
%% 4-filtered signal at fc=1.8khz
subplot(7,2,7);
plot(f,Filteredsignal_2);
xlabel("Frequency in HZ");
ylabel("Amplitude");
title("FC=2.9KHZ Filtered signal Frequency domian plot");
%% 5-filtered signal at fc_unintel=600hz
subplot(7,2,9);
plot(f,Filteredsignal_unintel);
xlabel("Frequency in HZ");
ylabel("Amplitude");
title("Unintelligible Filtered signal Frequency domian plot");
%% 6- letter f 
subplot(7,2,11);
plot(f,abs(fftshift(fft(unintel_f,n)))/n);
xlabel("Frequency in HZ");
ylabel("Amplitude");
title("Unintelligible Letter F in frequency domain");
%% 7- letter s
subplot(7,2,13);
plot(f,abs(fftshift(fft(unintel_s,n)))/n);
xlabel("Frequency in HZ");
ylabel("Amplitude");
title("Unintelligible Letter S in frequency domain");
%% 8- letter b
subplot(7,2,2);
plot(f,abs(fftshift(fft(unintel_b,n)))/n);
xlabel("Frequency in HZ");
ylabel("Amplitude");
title("Unintelligible Letter B in frequency domain");
%% 9- letter d
subplot(7,2,4);
plot(f,abs(fftshift(fft(unintel_d,n)))/n);
xlabel("Frequency in HZ");
ylabel("Amplitude");
title("Unintelligible Letter D in frequency domain");
%% 10- letter m
subplot(7,2,6);
plot(f,abs(fftshift(fft(unintel_m,n)))/n);
xlabel("Frequency in HZ");
ylabel("Amplitude");
title("Unintelligible Letter M in frequency domain");
%% 11- letter n
subplot(7,2,8);
plot(f,abs(fftshift(fft(unintel_n,n)))/n);
xlabel("Frequency in HZ");
ylabel("Amplitude");
title("Unintelligible Letter N in frequency domain");
%%12- modulated
subplot(7,2,10);
plot(F,abs(fftshift(fft(modulated,N)))/N);
xlabel("Frequency (HZ)");
ylabel("Amplitude");
title("Modulated signal in Frequency domian");
%% 12-demodulated
subplot(7,2,12);
plot(F,abs(fftshift(fft(demodulated,N)))/N);
xlabel("Frequency (HZ)");
ylabel("Amplitude");
title("Demodulated signal in Frequency domian");







