clear; close all; clc; 

rng(0); 
% parameters 
mess = randi([0, 1], 1, 30000); 
Rs = 1e3; 
R_sample = 1e6; 
carrier_freq = 1e4; 
SNR = 5; % Es/N0 (dB)
modulation_mode = "psk"; % "qam" or "psk" 
modulation_M = 4; % QPSK 

% Hamming Encoding (7, 4, 3)
% visualization 
mess_hamming = channel_coding(mess, "hamming/encode", 7, 4); 
[rece_hamming, ~] = BSC_channel(mess_hamming, Rs, R_sample, carrier_freq, SNR, modulation_mode, modulation_M, true); 
decode_hamming = channel_coding(rece_hamming, "hamming/decode", 7, 4); 
error_hamming = biterr(mess, decode_hamming) / length(mess); 

% Cyclic Encoding (23, 12, 7)
mess_cyclic = channel_coding(mess, "cyclic/encode", 23, 12); 
[rece_cyclic, ~] = BSC_channel(mess_cyclic, Rs, R_sample, carrier_freq, SNR, modulation_mode, modulation_M); 
decode_cyclic = channel_coding(rece_cyclic, "cyclic/decode", 23, 12); 
error_cyclic = biterr(mess, decode_cyclic) / length(mess); 

% Repead Encoding (3, 1, 3) 
mess_repeat = channel_coding(mess, "repeat/encode", 3, 1); 
[rece_repeat, ~] = BSC_channel(mess_repeat, Rs, R_sample, carrier_freq, SNR, modulation_mode, modulation_M); 
decode_repeat = channel_coding(rece_repeat, "repeat/decode", 3, 1); 
error_repeat = biterr(mess, decode_repeat) / length(mess); 

% Convolutional Encoding (2, 1, 3) 
% generator: [[1 1 0], [1 1 1]]; hard decision; trace back: 10 
mess_conv = channel_coding(mess, "conv/encode", 2, 1, 3, [6, 7]); 
[rece_conv, ~] = BSC_channel(mess_conv, Rs, R_sample, carrier_freq, SNR, modulation_mode, modulation_M); 
decode_conv = channel_coding(rece_conv, "conv/decode", 2, 1, 3, [6, 7], 10, 'hard'); 
error_conv = biterr(mess, decode_conv) / length(mess); 


