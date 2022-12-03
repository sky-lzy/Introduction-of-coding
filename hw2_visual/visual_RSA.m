clear all,
close all,
clc
%%% RSA
%generate code
prime_size = 10; 
mess_len = 200; 
output = RSA_generate(prime_size); 
pub_key = output(1); 
pri_key = output(2); 
N_mod = output(3); 

message = randi([2, N_mod - 1], 1, mess_len);
mess_encode = RSA_encode(pub_key, N_mod, mess_len, message); 

%change to bin
bitpcode = ceil(log2(N_mod-1));

input_code = zeros(1,bitpcode*mess_len);
for k = 1:mess_len
    input_code((k-1)*bitpcode+1 : k*bitpcode) = dec2bin(mess_encode(k),bitpcode)-'0';
end

%trans
T = 21;
K = 3;
fs = 10000;% 假定采样率10k
n0 = 0.0005;
sigma2 = fs*n0/2;
[output_code,es] = realcore_channel(input_code,1,T,K,fs,n0,0);

%change 2 num
output = zeros(1,mess_len);
for k = 1:mess_len
    output(k) = bin2dec(num2str(output_code((k-1)*bitpcode+1 : k*bitpcode)));
end

%decode
mess_decode = RSA_encode(pri_key, N_mod, mess_len, output);

%% none
%change to bin
input_code_none = zeros(1,bitpcode*mess_len);
for k = 1:mess_len
    input_code_none((k-1)*bitpcode+1 : k*bitpcode) = dec2bin(message(k),bitpcode)-'0';
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
visual_map(:,mess_decode~=message,1) = 255;
visual_map(:,mess_decode~=message,2) = 0;
subplot(2,1,1);
imshow(visual_map);
visual_map(:,:,1) = 0;
visual_map(:,:,2) = 255;
visual_map(:,:,3) = 0;
visual_map(:,output_none~=message,1) = 255;
visual_map(:,output_none~=message,2) = 0;
subplot(2,1,2);
imshow(visual_map);

disp('encode')
display(sum(mess_decode~=message)/mess_len)
disp('noencode')
display(sum(output_none~=message)/mess_len)