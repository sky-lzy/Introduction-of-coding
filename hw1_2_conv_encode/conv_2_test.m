clc;clear;

rng(0);

%visualize_error_snr(50);
% visualize_error_snr(10000);
max_snr = 2;
min_snr = 0.5;
stride = (max_snr-min_snr)/10;
s = min_snr:stride:max_snr-stride;
visualize_error_pattern(s,20,0);
visualize_error_pattern(s,20,1);




