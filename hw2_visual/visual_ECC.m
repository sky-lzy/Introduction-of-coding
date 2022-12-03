%% 

clear all,
close all,
clc
%%% ECC
%generate code
ECC_parameters = ECC_generate(); 
p = ECC_parameters(1); 
n = ECC_parameters(2); 
a = ECC_parameters(3); 
b = ECC_parameters(4); 
pri_key = ECC_parameters(5); 
base_point = [ECC_parameters(6), ECC_parameters(7)]; 
pub_key = [ECC_parameters(8), ECC_parameters(9)]; 

mess_len = 200; 
mess = randi([1, n-1], 1, mess_len); 

[C1, C2] = ECC_encode(p, a, b, base_point(1), base_point(2), pub_key(1), pub_key(2), mess_len, mess);

%change to bin
bitpcode = ceil(log2(max(max(C1))));

input_code = zeros(1,bitpcode*mess_len*3);
for k = 1:mess_len
    input_code((k-1)*bitpcode+1 : k*bitpcode) = dec2bin(C1(k,1),bitpcode)-'0';
end
for k = mess_len+1:mess_len*2
    input_code((k-1)*bitpcode+1 : k*bitpcode) = dec2bin(C1(k-mess_len,2),bitpcode)-'0';
end
for k = mess_len*2+1:mess_len*2+2
    input_code((k-1)*bitpcode+1 : k*bitpcode) = dec2bin(C2(k-mess_len*2),bitpcode)-'0';
end

%trans
T = 21;
K = 3;
fs = 10000;% 假定采样率10k
n0 = 0.0005;
sigma2 = fs*n0/2;
[output_code,es] = realcore_channel(input_code,1,T,K,fs,n0,0);

%change 2 num
out_put_C1 = zeros(mess_len,2);
out_put_C2 = zeros(1,2);
for k = 1:mess_len
    out_put_C1(k,1) = bin2dec(num2str(output_code((k-1)*bitpcode+1 : k*bitpcode)));
end
for k = mess_len+1:mess_len*2
    out_put_C1(k-mess_len,2) = bin2dec(num2str(output_code((k-1)*bitpcode+1 : k*bitpcode)));
end
for k = mess_len*2+1:mess_len*2+2
    out_put_C2(k-mess_len*2) = bin2dec(num2str(output_code((k-1)*bitpcode+1 : k*bitpcode)));
end

%decode
mess_decode = ECC_decode(p, a, b, pri_key, mess_len, out_put_C1, out_put_C2); 

%% none
%change to bin
input_code_none = zeros(1,bitpcode*mess_len);
for k = 1:mess_len
    input_code_none((k-1)*bitpcode+1 : k*bitpcode) = dec2bin(mess(k),bitpcode)-'0';
end

%trans
[output_code_none,es] = realcore_channel(input_code_none,1,T,K,fs,n0,0);

%change 2 num
clear input_code
output = zeros(1,mess_len);
for k = 1:mess_len
    output_none(k) = bin2dec(num2str(output_code_none((k-1)*bitpcode+1 : k*bitpcode)));
end

%% visual
h = figure();
sgt = sgtitle('Error Pattern','Color','Red');
sgt.FontSize = 20;
set(sgt, 'FontName', 'Times New Roman');
visual_map = zeros(2,mess_len,3);
visual_map(:,:,1) = 0;
visual_map(:,:,2) = 255;
visual_map(:,:,3) = 0;
visual_map(:,mess_decode~=mess,1) = 255;
visual_map(:,mess_decode~=mess,2) = 0;
subplot(2,1,1);
imshow(visual_map);
visual_map(:,:,1) = 0;
visual_map(:,:,2) = 255;
visual_map(:,:,3) = 0;
visual_map(:,output_none~=mess,1) = 255;
visual_map(:,output_none~=mess,2) = 0;
subplot(2,1,2);
imshow(visual_map);

disp(sum(mess_decode~=mess)/mess_len)
disp(sum(output_none~=mess)/mess_len)