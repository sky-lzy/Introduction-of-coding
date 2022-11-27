close all; clear; clc;

% 点击“运行并计时”

rng(0); % 随机数种子
Nexp = 20; % 实验轮数

key = randi(256,[1,16])-1; % 生成密钥
for k = 1:Nexp
    lenm = randi(96); % 明文长度1-96随机
    m = randi(256,[1,lenm])-1; % 生成明文
    c1 = des(m,key)+1; % des编码
    c2 = aes(m,key)+1; % aes编码
end
