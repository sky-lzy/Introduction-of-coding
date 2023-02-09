clear; close all; clc; 

rng(0); 

addpath('..\');
addpath('..\hw3_quantification_vlc\MATLABcodec')

% H.264
blockOption = 0;
i_quant = 1;
quant_step = 50;   % 1-255;
quant_factor = [1,5,10,25,50,75,90,100]; % 1-100
quant_array = [10, 20, 30, 40];   % your quantization array

num_dots = length(quant_factor);
procImages = uint8(zeros(num_dots,128,128));
psnrs_h = zeros(1,num_dots);
bitCounts_h = zeros(1,num_dots);
cr = zeros(1,6);
for index = 1:num_dots
    [procImage,recImage,psnrArray,srcImgBits,bitCount] = func_codec_full(blockOption,i_quant,quant_step,quant_factor(index),quant_array);
    cr(index) = bitCount/srcImgBits;  
    procImages(index,:,:) = procImage;
    psnrs_h(index) = psnrArray;
    bitCounts_h(index) = bitCount;
end
