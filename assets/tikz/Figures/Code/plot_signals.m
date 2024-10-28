clear;
addpath("../../../../Octagon test VT 22/Signals/")

[sig,fs] = audioread("ValidationSignal.wav");
t = (1:length(sig))/fs;

figure(1); clf
plot(t,sig)