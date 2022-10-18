clc;clear;

%visualize_error_snr(50);

visualize_error_snr(10000);



% max_snr = 2;
% min_snr = 0.5;
% stride = (max_snr-min_snr)/10;
% s = min_snr:stride:max_snr-stride;
% visualize_error_pattern(s,30);

 
 
%  SNR = 5;
%  sigma_n = sqrt(1/SNR);
%  L = 1200;
%  dtest = floor(rand(1,L)*2); %产生长为L个符号的{0,1}二元测试用待编码序列，长度为L
%  v2 = conv_encode2(dtest, sigma_n);
%  v3 = conv_encode3(dtest, sigma_n);
%  g2 = [1,0,1,1;1,1,1,1];
%  g3 = [1,1,0,1;1,0,1,1;1,1,1,1];
%  [~,rate2] = conv_decodecrc(v2,L,g2,1,dtest,0,0,0);
%  [~,rate3] = conv_decodecrc(v3',L,g3,0,dtest,0,0,0);




