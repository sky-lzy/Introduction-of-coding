clear;clc;

% 二元1/2效率卷积码模块 
% 建议参数（15,17）-> oct2bin(15)=1101 oct2bin(17)=1111（2,1,4）码
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
g1 = [1,1,0,1]; %生成多项式系数
g2 = [1,1,1,1];
L = 1200; % 如果收尾，待编码长为L = L+4
d = floor(rand(1,L)*2); %产生长为L个符号的{0,1}二元测试用待编码序列，长度为L
tail = zeros(1,4); % 约束长度为4，如果要收尾则需要输入连续4个0清空编码器

% CRC编码，25bytes = 200bits一组
packnum = ceil(L/200);
dcrc = [];
for k = 1:packnum
    pack = crc3(d(200*(k-1)+1:200*k));
    dcrc = [dcrc,pack];
end


x1 = mod(conv(g1,dcrc),2);
x2 = mod(conv(g2,dcrc),2);
d = reshape([x1;x2],[1,length(x1)+length(x2)]);% d为卷积码编码后不收尾得到的序列
L = length(dcrc)*2;% 效率为1/2，编码后码长翻倍,且还需加上crc编码产生的长度。
d = d(1:L); %对编码器中残留的部分进行截断
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%此处复电平采用示例程序中的映射方式
u =(1-d*2)*(1+sqrt(-1)); %将序列d映射到一个复数符号流，d中每个二元符号映射到一个复电平，0映射到1+j，1映射到-1-j，每符号能量为2
% 信道参数假设都为0（此时事实上rou没作用）
b = 0;
rou = 0;
belta = zeros(1,L);
belta(1) = (randn()+sqrt(-1)*rand())/sqrt(2);% belta_1实虚部分别独立服从零均值方差为0.5的高斯分布
z =(randn(1,L)+sqrt(-1)*randn(1,L))/sqrt(2); % z_i为实虚部方差均为1/2的零均值高斯分布
for i = 2:L
    belta(i) = rou*belta(i-1)+sqrt(1-rou^(2))*z(i);
end
v = zeros(L,1);
for i = 1:L
    a = sqrt(1-b^(2))+b*belta(i);
    % 连续使用T次信道
    T = 5;
    sigma_n = 1;% 假定噪声理论总方差为1，即噪声功率为1
    n =(randn(1,T)+sqrt(-1)*randn(1,T))*sigma_n/sqrt(2); % n_i为实虚部独立服从方差均为sigma_n^2/2的零均值高斯分布
    x = ones(1,T)*u(i)/sqrt(T);
    y = a*x+n;
    v(i) = sum(y)/sqrt(T);
end
% 输出v即为发射出去的复电平信号。


