close all; clear; clc;
%% uniform quantization (blockOption)
i_quant = 0;
quant_step = 50;   % 1-255;
quant_factor = 1; % 1-100
quant_array = [10, 20, 30, 40];   % your quantization array

cr = zeros(1,6);
procImages = uint8(zeros(1,128,128));
psnrs_u = zeros(1,5);
for blockOption = 0:5
    [procImage,recImage,psnrArray,srcImgBits,bitCount] = func_codec(blockOption,i_quant,quant_step,quant_factor,quant_array);
    cr(blockOption+1) = bitCount/srcImgBits;  
    psnrs_u(blockOption+1) = mean(psnrArray);
    procImages(blockOption+1,:,:) = procImage;
end
close all;
figure('Name','procImages differ from blockOption','NumberTitle','off');
for i = 1:6
    subplot(2,3,i);hold on;
    title(['blockOption:',num2str(i-1)]);
    imshow(squeeze(procImages(i,:,:)));
end
sgtitle('procImages differ from blockOption');
figure('Name','CR','NumberTitle','off');
plot(0:5,cr,'Marker','o');hold on;
title('CRs differ from blockOption');
xlabel('blockOption');
ylabel('CR');
figure();
plot(0:5,psnrs_u,'Marker','o');hold on;
ylim([0,20]);
title('PSNRs differ from blockOption');
xlabel('blockOption');
ylabel('PSNR');

%% uniform quantization (step)
blockOption = 0;
i_quant = 0;
quant_step = [10,25,50,100];   % 1-255;
quant_factor = 1; % 1-100
quant_array = [10, 20, 30, 40];   % your quantization array

procImages = uint8(zeros(4,128,128));
psnrs_u = zeros(1,4);
bitCounts_u = zeros(1,4);
for index = 1:4
    [procImage,recImage,psnrArray,srcImgBits,bitCount] = func_codec(blockOption,i_quant,quant_step(index),quant_factor,quant_array);
    cr(index) = bitCount/srcImgBits;  
    procImages(index,:,:) = procImage;
    psnrs_u(index) = psnrArray;
    bitCounts_u(index) = bitCount;
end
close all;
figure('Name','procImages differ from step(uniform quantization)','NumberTitle','off');
for i = 1:4
    subplot(2,2,i);hold on;
    title(['step:',num2str(quant_step(i))]);
    imshow(squeeze(procImages(i,:,:)));
end
sgtitle('procImages differ from quant step');
figure('Name','R-D','NumberTitle','off');
plot(bitCounts_u,psnrs_u,'Marker','*');hold on;
title('Rate-Distortion');
xlabel('Bit Rate');
ylabel('PSNR');

%% H.264
blockOption = 0;
i_quant = 1;
quant_step = 50;   % 1-255;
quant_factor = [1,5,10,25,50,75,90,100]; % 1-100
quant_array = [10, 20, 30, 40];   % your quantization array

num_dots = length(quant_factor);
procImages = uint8(zeros(num_dots,128,128));
psnrs_h = zeros(1,num_dots);
bitCounts_h = zeros(1,num_dots);
for index = 1:num_dots
    [procImage,recImage,psnrArray,srcImgBits,bitCount] = func_codec(blockOption,i_quant,quant_step,quant_factor(index),quant_array);
    cr(index) = bitCount/srcImgBits;  
    procImages(index,:,:) = procImage;
    psnrs_h(index) = psnrArray;
    bitCounts_h(index) = bitCount;
end
close all;
figure('Name','procImages differ from quant factor(JPEG)','NumberTitle','off');
for i = 1:num_dots
    subplot(2,4,i);hold on;
    title(['factor:',num2str(quant_factor(i))]);
    imshow(squeeze(procImages(i,:,:)));
end
sgtitle('procImages differ from quant factor');
figure('Name','R-D(JPEG)','NumberTitle','off');
plot(bitCounts_h,psnrs_h,'Marker','*');hold on;
title('Rate-Distortion(JPEG)');
xlabel('Bit Rate');
ylabel('PSNR');

%% custom quantization
blockOption = 0;
i_quant = 2;
quant_step = 50;   % 1-255;
quant_factor = 1; % 1-100
quant_array = {[5 35 65 88 104 120 136 152 168 185 215 245],...%中值细化13值
                [5 10 20 40 65 100 155 190 215 235 245 250],...%边值细化13值
                [5 10 18 26 35 55 80 105 115 155 200 245],...% 低值细化13值
                [20 56 101 141 151 176 201 221 230 238 246 251],...% 高值细化13值
                [55 100 152 210],...%4值量化
                [40 76 108 134 158 189 224],...%8值量化
                [8 22 40 50 76 86 108 120 134 144 158 168 189 202 224]%16值量化
                };   % your quantization array

num_dots = length(quant_array);
procImages = uint8(zeros(num_dots,128,128));
psnrs_c = zeros(1,num_dots);
bitCounts_c = zeros(1,num_dots);
for index = 1:num_dots
    [procImage,recImage,psnrArray,srcImgBits,bitCount] = func_codec(blockOption,i_quant,quant_step,quant_factor,cell2mat(quant_array(index)));
    cr(index) = bitCount/srcImgBits;  
    procImages(index,:,:) = procImage;
    psnrs_c(index) = psnrArray;
    bitCounts_c(index) = bitCount;
end
close all;
figure('Name','procImages differ from quant array(custom)','NumberTitle','off');
for i = 1:num_dots
    subplot(2,4,i);hold on;
    title(['No:',num2str(i)]);
    imshow(squeeze(procImages(i,:,:)));
end
sgtitle('procImages differ from quant array');
[sorted_bitCounts,I] = sort(bitCounts_c);
sorted_psnrs = psnrs_c(I);
figure('Name','R-D(custom)','NumberTitle','off');
plot(sorted_bitCounts,sorted_psnrs,'Marker','*');hold on;
title('Rate-Distortion(custom)');
xlabel('Bit Rate');
ylabel('PSNR');

%% compare
figure();hold on;
plot(bitCounts_u,psnrs_u,'Marker','*','Color','r','LineWidth',1.5);hold on;
plot(bitCounts_h,psnrs_h,'Marker','o','Color','g','LineWidth',1.5);hold on;
plot(sorted_bitCounts,sorted_psnrs,'Marker','+','Color','b','LineWidth',1.5);
legend('uniform','JPEG','custom');
title('Rate-Distortion(compare)');
xlabel('Bit Rate');
ylabel('PSNR');