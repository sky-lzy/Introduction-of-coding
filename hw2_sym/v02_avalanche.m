close all; clear; clc;

rng(0); % 随机数种子
Nexp = 2; % 实验轮数

% 分别统计
codm = zeros(1,128); % des+message
codk = zeros(1,128); % aes+message
coam = zeros(1,128); % des+key
coak = zeros(1,128); % aes+key
for k = 1:Nexp
    key = randi(256,[1,16])-1; % 生成密钥
    message = randi(256,[1,16])-1; % 生成明文
    key_bits = char2bits(key);
    message_bits = char2bits(message);
    cdes = des_bl(message,key);
    cdes_bits = char2bits(cdes);
    caes = aes_bl(message,key);
    caes_bits = char2bits(caes);
    for r = 1:128
        message_bits(r) = (1- message_bits(r));
        message_e = bits2char(message_bits);
        cdes_e = des_bl(message_e,key);
        cdes_e_bits = char2bits(cdes_e);
        codm(r) = codm(r) + sum(double(xor(cdes_e_bits,cdes_bits)));
        caes_e = aes_bl(message_e,key);
        caes_e_bits = char2bits(caes_e);
        coam(r) = coam(r) + sum(double(xor(caes_e_bits,caes_bits)));
    end
    for r = 1:128
        key_bits(r) = (1- key_bits(r));
        key_e = bits2char(key_bits);
        cdes_e = des_bl(message,key_e);
        cdes_e_bits = char2bits(cdes_e);
        codk(r) = codk(r) + sum(double(xor(cdes_e_bits,cdes_bits)));
        caes_e = aes_bl(message,key_e);
        caes_e_bits = char2bits(caes_e);
        coak(r) = coak(r) + sum(double(xor(caes_e_bits,caes_bits)));
    end
end

codm = codm / 128 / Nexp;
codk = codk / 128 / Nexp;
coam = coam / 128 / Nexp;
coak = coak / 128 / Nexp;

figure();
subplot(2,1,1);
plot(1:128,codm,'o');
xlim([1,128]);
line([1,128],[mean(codm),mean(codm)],'Color','red','LineStyle','--');
title('单块des编码改变明文中1bit时密文(128bit)的变化','FontSize',14,'FontName','黑体');
xlabel('位序号');
ylabel('密文比特改变的比例');
text( 'string',strcat("mean = ",num2str(mean(codm)),", var = ",num2str(var(codm)*Nexp)), 'Units','normalized','HorizontalAlignment','right','position',[0.95,0.95],  'FontSize',14,'FontName','Consolas');%,'Color','r');  

subplot(2,1,2)
plot(1:128,coam,'o');
xlim([1,128]);
line([1,128],[mean(coam),mean(coam)],'Color','red','LineStyle','--');
title('单块aes编码改变明文中1bit时密文(128bit)的变化','FontSize',14,'FontName','黑体');
xlabel('位序号');
ylabel('密文比特改变的比例');
text( 'string',strcat("mean = ",num2str(mean(coam)),", var = ",num2str(var(coam)*Nexp)), 'Units','normalized','HorizontalAlignment','right','position',[0.95,0.95],  'FontSize',14,'FontName','Consolas');%,'Color','r');  

figure();
subplot(2,1,1);
plot(1:128,codk,'o');
xlim([1,128]);
line([1,128],[mean(codk),mean(codk)],'Color','red','LineStyle','--');
title('单块des编码改变密钥中1bit时密文(128bit)的变化','FontSize',14,'FontName','黑体');
xlabel('位序号');
ylabel('密文比特改变的比例');
text( 'string',strcat("mean = ",num2str(mean(codk)),", var = ",num2str(var(codk)*Nexp)), 'Units','normalized','HorizontalAlignment','right','position',[0.95,0.95],  'FontSize',14,'FontName','Consolas');%,'Color','r');  

subplot(2,1,2);
plot(1:128,coak,'o');
xlim([1,128]);
line([1,128],[mean(coak),mean(coak)],'Color','red','LineStyle','--');
title('单块aes编码改变密钥中1bit时密文(128bit)的变化','FontSize',14,'FontName','黑体');
xlabel('位序号');
ylabel('密文比特改变的比例');
text( 'string',strcat("mean = ",num2str(mean(coak)),", var = ",num2str(var(coak)*Nexp)), 'Units','normalized','HorizontalAlignment','right','position',[0.95,0.95],  'FontSize',14,'FontName','Consolas');%,'Color','r');  

