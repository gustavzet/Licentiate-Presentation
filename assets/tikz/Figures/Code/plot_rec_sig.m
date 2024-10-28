% clear all;
if ~exist("s_val","var")
    load('C:\Users\gusze47\Documents\Research\Octagon test VT 22\Data\val_data.mat');
end
mic = 1;
ang = 1; % 4 for shot
fs = 48e3;

sep = 0.2;
sig_full = [];
t_full = [];
down_samp_factor = 40;

% figure(1);clf
for k = [1 12:numel(title_vec_val)]
    figure(k);clf
    sig = s_val{k}(ang,:,mic);
    N(k) = size(sig,2);
    t = (1:N(k))/fs;
    t = t + sum(N(1:k-1))/fs + sep*(k-1);
    if k ~= 18; plot(t(1:down_samp_factor:end)-t(1),sig(1:down_samp_factor:end)); hold on;
        else plot(t,sig); 
    end
    sig_full = [sig_full zeros(1, sep*fs) sig];
    t_full = [t_full t];

    ylim([-.6 .6]);
    xlabel("Time [s]")
    ylabel("Amplitude")
    title("Signal "+k)
    % cleanfigure();
    % cleanfigure('targetResolution',300)
    % matlab2tikz('test_clean.tex');
    % matlab2tikz(append('../SignalOverviewRec_',num2str(k),'.tex'))
    % return
    % figure(numel(title_vec_val)+k);
    % pspectrum(sig, fs, 'spectrogram', 'TimeResolution', 0.01, ...
    %     'OverlapPercent', 00, 'MinThreshold', -60);
    % xlabel("Time [s]")
    % ylabel("Frequency [kHz]")
    % title("Signal "+k)
    % matlab2tikz(append('../SignalOverviewRecFreq_',num2str(k),'.tex'))
    audiowrite("Rec_Signals/Signal_"+k+".mp3",sig,fs);
end
ylim([-.6 .6]);
xlabel("Time [s]")
ylabel("Amplitude")
title("Experimental signals")
% matlab2tikz('../SignalOverviewRec.tex')
return

%% Sinusoids
figure(2);clf
samp_sin = 4800*10-1;
sep = -1+samp_sin*1/fs;
sig_full = [];
for k = [2:11]
    sig = s_val{k}(ang,:,mic);
    N(k) = size(sig,2);
    t = (1:N(k))/fs;
    t = t + sum(N(1:k-1))/fs + sep*(k-1)-10;
    plot(t(end-samp_sin:end),sig(end-samp_sin:end)); hold on;
    xline(t(end),'--')

    % if k ~= 18; plot(t(1:down_samp_factor:end),sig(1:down_samp_factor:end)); hold on;
    %     else plot(t,sig); 
    % end
    sig_full = [sig_full sig(end-samp_sin:end-1)];
    % t_full = [t_full t];

    % matlab2tikz(append('../SignalOverviewRec_',num2str(k),'.tex'))
    
    % figure(numel(title_vec_val)+k);
    % pspectrum(sig, fs, 'spectrogram', 'TimeResolution', 0.01, ...
    %     'OverlapPercent', 00, 'MinThreshold', -60);
    % xlabel("Time [s]")
    % ylabel("Frequency [kHz]")
    % title("Signal "+k)
    % matlab2tikz(append('../SignalOverviewRecFreq_',num2str(k),'.tex'))

end
% sig_full = [sig_full sig(end-samp_sin:end)];
ylim([-.6 .6]);
xlabel("Time [s]")
ylabel("Amplitude")
title("Sinusoids")
% matlab2tikz('C:\Users\gusze47\Documents\Research\Papers\Lic\Figures\SignalOverviewRec_Sin.tex')

figure(3);clf
% Create the spectrogram plot
pspectrum(sig_full, fs, 'spectrogram', 'TimeResolution', 0.01, ...
    'OverlapPercent', 00, 'MinThreshold', -60);
% xlim([0 100])

% matlab2tikz('C:\Users\gusze47\Documents\Research\Papers\Lic\Figures\SignalOverviewRecFreq_Sin.tex')
audiowrite("Rec_Signals/Signal_sin.mp3",sig_full,fs);
return
sig_full = sig_full(sep*fs:end);
t_full = (1:numel(sig_full))/fs;
figure(2);clf
plot(t_full, sig_full)

figure(3);
% Create the spectrogram plot
pspectrum(sig_full, fs, 'spectrogram', 'TimeResolution', 0.01, ...
    'OverlapPercent', 00, 'MinThreshold', -60);

% Get the current axes handle
ax = gca;

% Define the desired XTick positions in seconds
xTickValues = 0:10:70;

% Update the XTick positions (convert from seconds to minutes)
ax.XTick = xTickValues / 60;

% Set the XTickLabel to the desired values in seconds
ax.XTickLabel = string(xTickValues);

% Update the xlabel to reflect the change
xlabel('Time (seconds)');
% matlab2tikz('../SignalOverviewRecFreq.tex')


%% plot shot seperatly

figure(4);
sig_shot = sig(1:750);
t_shot = (1:numel(sig_shot))/fs
plot(t_shot*1000,sig_shot)
xlabel("Time [ms]")
ylabel("Amplitude")
title("Shot signal")

% matlab2tikz('../SignalShot.tex')

figure(5)
pspectrum(sig_shot,fs,'spectrogram','TimeResolution',0.0005, ...
    'OverlapPercent',0,'MinThreshold',-60);

% matlab2tikz('../SignalShotFreq.tex')
