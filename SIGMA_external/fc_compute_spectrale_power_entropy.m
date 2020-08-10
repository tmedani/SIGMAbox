function power_entropy=fc_compute_spectrale_power_entropy(signal,sampling_rate)
% COmpute the entropy of the sepctral power of a signal

% from ECG Feature extraction toolbox : Shantanu V. Deshmukh
% Organization: University of Michigan Dearborn


dstnce=signal;
Fs1=sampling_rate;
% Calculating Power Spectral Entropy
%Fs1=250; %sampling rate per second
Ts1=1/Fs1;%sampling time interval in second
t1=0:Ts1:1-Ts1; n1=length(t1);

fresult1=fft(dstnce);
sum_fresult1=0.0;
for i=1:1:length(fresult1)-1
    sum_fresult1= sum_fresult1 + (abs(fresult1(i)));
end
fresult1=fresult1/sum_fresult1;
entropy1=0.0;
for i=1:1:length(fresult1)-1
    entropy1= entropy1+ abs(fresult1(i))*log(1/abs(fresult1(i)));
    pse_rr=entropy1;
end
power_entropy=pse_rr;
end

% function created by T. MEDANI