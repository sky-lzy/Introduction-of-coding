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
    cr(blockOption+1) = srcImgBits/bitCount;  
    psnrs_u(blockOption+1) = mean(psnrArray);
    procImages(blockOption+1,:,:) = procImage;
end
close all;
figure('Name','procImages with different blockOption','NumberTitle','off');
for i = 1:6
    subplot(2,3,i);hold on;
    title(['blockOption:',num2str(i-1)]);
    imshow(squeeze(procImages(i,:,:)));
end
sgtitle('procImages with different blockOption');
figure('Name','CR','NumberTitle','off');
plot(0:5,cr,'Marker','o');hold on;
title('CRs differ from blockOption');
xlabel('blockOption');
ylabel('CR');
figure();
plot(0:5,psnrs_u,'Marker','o');hold on;
ylim([0,20]);
title('PSNRs with different blockOption');
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
    cr(index) = srcImgBits/bitCount;  
    procImages(index,:,:) = procImage;
    psnrs_u(index) = psnrArray;
    bitCounts_u(index) = bitCount;
end
close all;
figure('Name','procImages with different step(uniform quantization)','NumberTitle','off');
for i = 1:4
    subplot(2,2,i);hold on;
    title(['step:',num2str(quant_step(i))]);
    imshow(squeeze(procImages(i,:,:)));
end
sgtitle('procImages with different quant step');
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
    cr(index) = srcImgBits/bitCount;  
    procImages(index,:,:) = procImage;
    psnrs_h(index) = psnrArray;
    bitCounts_h(index) = bitCount;
end
close all;
figure('Name','procImages with different quant factor(JPEG)','NumberTitle','off');
for i = 1:num_dots
    subplot(2,4,i);hold on;
    title(['factor:',num2str(quant_factor(i))]);
    imshow(squeeze(procImages(i,:,:)));
end
sgtitle('procImages with different quant factor');
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
quant_array = {[5,35,65,88,104,120,136,152,168,185,215,245],...
                [5,35,88,104,120,136,152,185,245],...
                [30,65,120,136,152,168,200,245],...
                [50,104,120,136,152,200],...%中值细化
                [5,10,15,20,40,65,100,155,190,215,225,235,245,250],...
                [5,10,20,40,100,155,190,215,235,245,250],...
                [5,10,40,80,155,190,235,245,250],...
                [5,10,20,155,235,245,250],...%边值细化
                [5,10,18,26,35,48,55,68,80,105,155,200,245],...
                [5,10,18,26,35,55,80,105,155,200,245],...
                [5,10,18,26,55,80,155,200,245],...
                [5,10,26,40,105,245],...% 低值细化
                [20,56,101,141,151,166,176,190,201,212,221,230,238,246,251],...
                [20,56,101,141,151,176,201,221,230,238,246,251],...
                [56,101,151,201,221,230,238,246,251],...
                [80,151,230,238,246,251],...% 高值细化
                };   % your quantization array

num_dots = length(quant_array);
procImages = uint8(zeros(num_dots,128,128));
psnrs_c = zeros(1,num_dots);
bitCounts_c = zeros(1,num_dots);
for index = 1:num_dots
    [procImage,recImage,psnrArray,srcImgBits,bitCount] = func_codec(blockOption,i_quant,quant_step,quant_factor,cell2mat(quant_array(index)));
    cr(index) = srcImgBits/bitCount;  
    procImages(index,:,:) = procImage;
    psnrs_c(index) = psnrArray;
    bitCounts_c(index) = bitCount;
end
close all;
figure('Name','procImages with different quant array(custom)','NumberTitle','off');
for i = 1:num_dots
    subplot(4,4,i);hold on;
    title(['No:',num2str(i)]);
    imshow(squeeze(procImages(i,:,:)));
end
sgtitle('procImages with different quant array');
figure('Name','R-D(custom)','NumberTitle','off');
for i = 1:4
    bitCounts_t = bitCounts_c(4*(i-1)+1:4*i);
    psnrs_t = psnrs_c(4*(i-1)+1:4*i);
    [sorted_bitCounts,I] = sort(bitCounts_t);
    sorted_psnrs = psnrs_t(I);
    plot(sorted_bitCounts,sorted_psnrs,'Marker','*');hold on;
end
legend('中值细化','边值细化','低值细化','高值细化');
title('Rate-Distortion(custom)');
xlabel('Bit Rate');
ylabel('PSNR');

%% compare
figure();hold on;
plot(bitCounts_u,psnrs_u,'Marker','*','Color','r','LineWidth',1.5);hold on;
plot(bitCounts_h,psnrs_h,'Marker','o','Color','g','LineWidth',1.5);hold on;
for i = 1:4
    bitCounts_t = bitCounts_c(4*(i-1)+1:4*i);
    psnrs_t = psnrs_c(4*(i-1)+1:4*i);
    [sorted_bitCounts,I] = sort(bitCounts_t);
    sorted_psnrs = psnrs_t(I);
    plot(sorted_bitCounts,sorted_psnrs,'Marker','+','LineWidth',1.5);hold on;
end
legend('uniform','JPEG','中值细化','边值细化','低值细化','高值细化');
title('Rate-Distortion(compare)');
xlabel('Bit Rate');
ylabel('PSNR');