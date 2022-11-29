close all; clear; clc;

rng(0); % 随机数种子
Nexp = 10; % 实验轮数

lenccount = 0;
bytecount1 = zeros(1,256);
bytecount2 = zeros(1,256); % 分别统计
key = randi(256,[1,16])-1; % 生成密钥
for k = 1:Nexp
    lenm = randi(100); % 明文长度1-100随机
    m = randi(32,[1,lenm])-1; % 只使用0-32的数作为明文,明显冗余
    c1 = des(m,key)+1; % des编码
    c2 = aes(m,key)+1; % aes编码
    lenc = length(c1);
    lenccount = lenccount + lenc;
    for r = 1:lenc
        bytecount1(c1(r)) = bytecount1(c1(r)) + 1;
        bytecount2(c2(r)) = bytecount2(c2(r)) + 1;
    end
end
% 归一化处理
bytecount1 = bytecount1 / lenccount;
bytecount2 = bytecount2 / lenccount;

figure();
subplot(2,1,1);
plot(0:255,bytecount1,'o');
xlim([0,255]);
line([0,255],[mean(bytecount1),mean(bytecount1)],'Color','red','LineStyle','--');
title('信源冗余时des编码后的的冗余情况','FontSize',14,'FontName','黑体');
xlabel('字节值');
ylabel('出现次数/总字节数');
text( 'string',strcat("mean = ",num2str(mean(bytecount1)),", var = ",num2str(var(bytecount1)*lenccount)), 'Units','normalized','HorizontalAlignment','right','position',[0.95,0.95],  'FontSize',14,'FontName','Consolas');%,'Color','r');  

subplot(2,1,2);
plot(0:255,bytecount2,'o');
xlim([0,255]);
line([0,255],[mean(bytecount2),mean(bytecount2)],'Color','red','LineStyle','--');
title('信源冗余时aes编码后的的冗余情况','FontSize',14,'FontName','黑体');
xlabel('字节值');
ylabel('出现次数/总字节数');
text( 'string',strcat("mean = ",num2str(mean(bytecount2)),", var = ",num2str(var(bytecount2)*lenccount)), 'Units','normalized','HorizontalAlignment','right','position',[0.95,0.95],  'FontSize',14,'FontName','Consolas');%,'Color','r');  
