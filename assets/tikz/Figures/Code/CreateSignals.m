clear all
close all
addpath("../../../../Octagon test VT 22/Signals/")

addpath("../../../../Octagon test VT 22/Functions")
%%
fs = 48000;
Ts = 1/fs;

%% 
[y_elephant_1, fs_e] = audioread("..\..\..\..\Octagon test VT 22\Signals\Elephant\Indian_Elephant.mp3");
figure(30)
pspectrum([y_elephant_1(:,1); y_elephant_1(:,2)],fs_e,'spectrogram','TimeResolution',0.01, ...
    'OverlapPercent',0,'MinThreshold',-60)
[y_elephant, ~] = ReadAndUpsample("..\..\..\..\Octagon test VT 22\Signals\Elephant\Indian_Elephant.mp3",fs);

%% Siren
[y_siren_1, fs_e] = audioread("..\..\..\..\Octagon test VT 22\Signals\Siren.mp3");
figure(31)
pspectrum([y_siren_1(:,1); y_siren_1(:,2)],fs_e,'spectrogram','TimeResolution',0.01, ...
    'OverlapPercent',0,'MinThreshold',-60)

[y_siren, ~] = ReadAndUpsample("..\..\..\..\Octagon test VT 22\Signals\Siren.mp3",fs);
y_siren = y_siren(1:round(length(y_siren)*2/9));

%% Drone
[y_drone, ~] = ReadAndUpsample("..\..\..\..\Octagon test VT 22\Signals\Drone.wav",fs);
y_drone = y_drone(fs:fs*6);

%% Scream
[y_scream_1, fs_e] = audioread("..\..\..\..\Octagon test VT 22\Signals\Scream\woman-scream-01.wav");
figure(32)
pspectrum([y_scream_1(:,1); y_scream_1(:,2)],fs_e,'spectrogram','TimeResolution',0.01, ...
    'OverlapPercent',0,'MinThreshold',-60)

[y_scream, ~] = ReadAndUpsample("..\..\..\..\Octagon test VT 22\Signals\Scream\woman-scream-01.wav",fs);



%% 500Hz signal
f_sin = linspace(500,9500,10);
t_sin = 0:Ts:1;
y_sin = sin(2*pi*f_sin(1)*t_sin);
zer = zeros(1,0.2*fs);% 0.1 seconds between signals

for freq = f_sin(2:end)
    y_sin = [y_sin zer sin(2*pi*freq*t_sin)];
end

%% Wide band noise
wn = randn(1,fs*10);
y_wn = bandpass(wn,[100 10000],fs);
t_wn = Ts*[0:length(y_wn)-1];
% Low
y_wn_low = 0.5*y_wn;
% High
y_wn_high = 2*y_wn;

%% Combine the signals
est_data = [zer,...
            y_wn/max(abs(y_wn)),zer,...
            y_sin/max(abs(y_sin)),zer,...
            y_drone/max(abs(y_drone)),zer
            ];
val_data = [zer,...
            y_wn/max(abs(y_wn)),zer,...
            y_sin/max(abs(y_sin)),zer,...
            y_drone/max(abs(y_drone)),zer,...   
            y_elephant/max(abs(y_elephant)),zer,...
            y_siren/max(abs(y_siren)),zer,...
            y_scream/max(abs(y_scream)),zer,...
            y_wn_low/max(abs(y_wn)),zer,...
            y_wn_high/max(abs(y_wn)),zer
            ];
        
est_data = est_data/max(abs([est_data,val_data])); % To avoid clipping   
est_t = Ts*[0:length(est_data)-1];
figure(1)
plot(est_t,est_data)
title("Estimation data")
xlabel('Time (s)')


val_data = val_data/max(abs([est_data,val_data])); % To avoid clipping   
val_t = Ts*[0:length(val_data)-1];
figure(2)
plot(val_t,val_data)
title("Validation data")
xlabel('Time (s)')

%% Plot with different colors
sep = fs*0.2;
figure(51);clf
plot((1:numel(y_wn))/fs,y_wn/max(abs(y_wn))/max(abs([est_data,val_data]))); hold on
plot((sep+numel(y_wn)+(1:numel(y_sin)))/fs,y_sin/max(abs(y_sin))/max(abs([est_data,val_data])));
plot((2*sep+numel(y_wn)+numel(y_sin)+(1:numel(y_drone)))/fs,y_drone/max(abs(y_drone))/max(abs([est_data,val_data])));
plot((3*sep+numel(y_wn)+numel(y_sin)+numel(y_drone)+(1:numel(y_elephant)))/fs,y_elephant/max(abs(y_elephant))/max(abs([est_data,val_data])));
plot((4*sep+numel(y_wn)+numel(y_sin)+numel(y_drone)+numel(y_elephant)+(1:numel(y_siren)))/fs,y_siren/max(abs(y_siren))/max(abs([est_data,val_data])));
plot((5*sep+numel(y_wn)+numel(y_sin)+numel(y_drone)+numel(y_elephant)+numel(y_siren)+(1:numel(y_scream)))/fs,y_scream/max(abs(y_scream))/max(abs([est_data,val_data])));
plot((6*sep+numel(y_wn)+numel(y_sin)+numel(y_drone)+numel(y_elephant)+numel(y_siren)+numel(y_scream)+(1:numel(y_wn_low)))/fs,y_wn_low/max(abs(y_wn))/max(abs([est_data,val_data])));
plot((7*sep+numel(y_wn)+numel(y_sin)+numel(y_drone)+numel(y_elephant)+numel(y_siren)+numel(y_scream)+numel(y_wn_low)+(1:numel(y_wn_high)))/fs,y_wn_high/max(abs(y_wn))/max(abs([est_data,val_data])));
xlabel("Time [s]")
ylabel("Amplitude")
title("Experimental Signals")
% return
% matlab2tikz('../SignalOverview.tex')

%% Plot the spectum
figure(3)
pspectrum([est_data, val_data],fs,'spectrogram','TimeResolution',0.01, ...
    'OverlapPercent',0,'MinThreshold',-60)

%% Listen to the signal
% soundsc(est_data,fs)
% soundsc(val_data,fs)

%% Save the signal
audiowrite('EstimationSignal.wav',est_data,fs)
audiowrite('ValidationSignal.wav',val_data,fs)

%% Look at the created signal
[y_est,Fs_est] = audioread('EstimationSignal.wav');
[y_val,Fs_val] = audioread('ValidationSignal.wav');

t_est = 1/Fs_est*[0:length(y_est)-1];
t_val = 1/Fs_val*[0:length(y_val)-1];

figure(4)
plot(t_est,y_est)

figure(5)
plot(t_val,y_val)

figure(6)
pspectrum([y_est],Fs_est,'spectrogram','TimeResolution',0.01, ...
    'OverlapPercent',0,'MinThreshold',-60)

figure(7)
pspectrum([y_val],Fs_val,'spectrogram','TimeResolution',0.01, ...
    'OverlapPercent',0,'MinThreshold',-60)

% matlab2tikz('../SignalOverviewFreq.tex')
