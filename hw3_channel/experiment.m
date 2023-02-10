clear; close all; clc; 

rng(0); 

addpath('..\');
addpath('..\hw3_quantification_vlc\MATLABcodec')

blockOption = 0;
%% uniform - cyclic - high quality
i_quant = 0;
quant_step = 10;   % 1-255;
% quant_factor = [1,5,10,25,50,75,90,100]; % 1-100
quant_factor = 1;
quant_array = [10, 20, 30, 40];   % your quantization array
vlcRadio = 0;
modulation_M = 4;
SNR = 12;
coding_config = {"cyclic",23,12};
[procImage,recImage,psnrArray,srcImgBits,bitCount] = func_codec_full(blockOption,i_quant,quant_step,quant_factor,quant_array,vlcRadio,SNR,modulation_M,coding_config);

%% uniform - cyclic - middle quality
i_quant = 0;
quant_step = 50;   % 1-255;
% quant_factor = [1,5,10,25,50,75,90,100]; % 1-100
quant_factor = 1;
quant_array = [10, 20, 30, 40];   % your quantization array
vlcRadio = 0;
modulation_M = 4;
SNR = 9;
coding_config = {"cyclic",23,12};
[procImage,recImage,psnrArray,srcImgBits,bitCount] = func_codec_full(blockOption,i_quant,quant_step,quant_factor,quant_array,vlcRadio,SNR,modulation_M,coding_config);

%% uniform - cyclic - low quality
i_quant = 0;
quant_step = 100;   % 1-255;
% quant_factor = [1,5,10,25,50,75,90,100]; % 1-100
quant_factor = 1;
quant_array = [10, 20, 30, 40];   % your quantization array
vlcRadio = 0;
modulation_M = 4;
SNR = 9;
coding_config = {"cyclic",23,12};
[procImage,recImage,psnrArray,srcImgBits,bitCount] = func_codec_full(blockOption,i_quant,quant_step,quant_factor,quant_array,vlcRadio,SNR,modulation_M,coding_config);

%% uniform - hamming - high quality
i_quant = 0;
quant_step = 10;   % 1-255;
% quant_factor = [1,5,10,25,50,75,90,100]; % 1-100
quant_factor = 1;
quant_array = [10, 20, 30, 40];   % your quantization array
vlcRadio = 0;
modulation_M = 4;
SNR = 12;
coding_config = {"hamming",7,4};
[procImage,recImage,psnrArray,srcImgBits,bitCount] = func_codec_full(blockOption,i_quant,quant_step,quant_factor,quant_array,vlcRadio,SNR,modulation_M,coding_config);

%% uniform - hamming - middle quality
i_quant = 0;
quant_step = 50;   % 1-255;
% quant_factor = [1,5,10,25,50,75,90,100]; % 1-100
quant_factor = 1;
quant_array = [10, 20, 30, 40];   % your quantization array
vlcRadio = 0;
modulation_M = 4;
SNR = 14;
coding_config = {"hamming",7,4};
[procImage,recImage,psnrArray,srcImgBits,bitCount] = func_codec_full(blockOption,i_quant,quant_step,quant_factor,quant_array,vlcRadio,SNR,modulation_M,coding_config);

%% uniform - hamming - low quality
i_quant = 0;
quant_step = 100;   % 1-255;
% quant_factor = [1,5,10,25,50,75,90,100]; % 1-100
quant_factor = 1;
quant_array = [10, 20, 30, 40];   % your quantization array
vlcRadio = 0;
modulation_M = 4;
SNR = 12;
coding_config = {"hamming",7,4};
[procImage,recImage,psnrArray,srcImgBits,bitCount] = func_codec_full(blockOption,i_quant,quant_step,quant_factor,quant_array,vlcRadio,SNR,modulation_M,coding_config);

%% jpeg - cyclic - high quality
i_quant = 1;
quant_step = 50;   % 1-255;
% quant_factor = [1,5,10,25,50,75,90,100]; % 1-100
quant_factor = 1;
quant_array = [10, 20, 30, 40];   % your quantization array
vlcRadio = 0;
modulation_M = 4;
SNR = 9;
coding_config = {"cyclic",23,12};
[procImage,recImage,psnrArray,srcImgBits,bitCount] = func_codec_full(blockOption,i_quant,quant_step,quant_factor,quant_array,vlcRadio,SNR,modulation_M,coding_config);

%% jpeg - cyclic - middle quality
i_quant = 1;
quant_step = 50;   % 1-255;
% quant_factor = [1,5,10,25,50,75,90,100]; % 1-100
quant_factor = 50;
quant_array = [10, 20, 30, 40];   % your quantization array
vlcRadio = 0;
modulation_M = 4;
SNR = 9;
coding_config = {"cyclic",23,12};
[procImage,recImage,psnrArray,srcImgBits,bitCount] = func_codec_full(blockOption,i_quant,quant_step,quant_factor,quant_array,vlcRadio,SNR,modulation_M,coding_config);

%% jpeg - cyclic - low quality
i_quant = 1;
quant_step = 90;   % 1-255;
% quant_factor = [1,5,10,25,50,75,90,100]; % 1-100
quant_factor = 1;
quant_array = [10, 20, 30, 40];   % your quantization array
vlcRadio = 0;
modulation_M = 4;
SNR = 9;
coding_config = {"cyclic",23,12};
[procImage,recImage,psnrArray,srcImgBits,bitCount] = func_codec_full(blockOption,i_quant,quant_step,quant_factor,quant_array,vlcRadio,SNR,modulation_M,coding_config);

