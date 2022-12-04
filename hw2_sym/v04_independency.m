close all; clear; clc;

rng(0); % 随机数种子
Nexp = 1000; % 实验轮数

cd = zeros(Nexp, 16);
ca = zeros(Nexp, 16);

key = randi(256,[1,16])-1; % 生成密钥
for k = 1:Nexp
    m = randi(4,[1,16])-1; % 只使用部分符号作为明文,存在冗余
    cd(k,:) = des_bl(m,key); % des编码
    ca(k,:) = aes_bl(m,key); % aes编码
end

figure();
subplot(2,1,1);
plot(1:16,mean(cd,1),'o');
xlim([1,16]);
ylim([100,155]);
line([1,16],[mean(cd,'all'),mean(cd,'all')],'Color','red','LineStyle','--');
title('信源冗余时(只使用4个符号)单块des编码后各位置的平均值','FontSize',14,'FontName','黑体');
text( 'string',strcat("mean = ",num2str(mean(cd,'all'))), 'Units','normalized','HorizontalAlignment','right','position',[0.95,0.95],  'FontSize',14,'FontName','Consolas');%,'Color','r');  

subplot(2,1,2);
plot(1:16,mean(ca,1),'o');
xlim([1,16]);
ylim([100,155]);
line([1,16],[mean(ca,'all'),mean(ca,'all')],'Color','red','LineStyle','--');
title('信源冗余时(只使用4个符号)单块aes编码后各位置的平均值','FontSize',14,'FontName','黑体');
text( 'string',strcat("mean = ",num2str(mean(ca,'all'))), 'Units','normalized','HorizontalAlignment','right','position',[0.95,0.95],  'FontSize',14,'FontName','Consolas');%,'Color','r');  

figure();
heatmap(corrcoef(cd));
title('信源冗余时(只使用4个符号)单块des编码后各位置间的相关系数');

figure();
heatmap(corrcoef(ca));
title('信源冗余时(只使用4个符号)单块aes编码后各位置间的相关系数');

