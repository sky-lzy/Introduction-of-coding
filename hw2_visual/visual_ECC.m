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
bitpcode = ceil(log2(n));

bitstream = round(rand(1,mess_len*(bitpcode-1)));
message = zeros(1,mess_len);
for k = 1:mess_len
    message(k) = bin2dec(num2str(bitstream((k-1)*(bitpcode-1)+1:k*(bitpcode-1))));
end

[C1, C2] = ECC_encode(p, a, b, base_point(1), base_point(2), pub_key(1), pub_key(2), mess_len, message);

%change to bin


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
for n0 = 0.0001:0.0001:0.0005
    sigma2 = fs*n0/2;
    SNR = pow2db(1/sigma2^2);
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
    mess_rec = zeros(1,(bitpcode-1)*mess_len);
    for k = 1:mess_len
        mess_rec((k-1)*(bitpcode-1)+1 : k*(bitpcode-1)) = dec2bin(mod(mess_decode(k),2^(bitpcode-1)),bitpcode-1)-'0';
    end


    %% none

    %trans
    [output_bitstream,es] = realcore_channel(bitstream,1,T,K,fs,n0,0);

    %% visual
    h = figure();
    sgt = sgtitle('Error Pattern','Color','Red');
    sgt.FontSize = 20;
    set(sgt, 'FontName', 'Times New Roman');
    visual_map = zeros(40,mess_len*(bitpcode-1),3);
    visual_map(:,:,1) = 0;
    visual_map(:,:,2) = 255;
    visual_map(:,:,3) = 0;
    visual_map(:,mess_rec~=bitstream,1) = 255;
    visual_map(:,mess_rec~=bitstream,2) = 0;
    subplot(2,1,1);
    imshow(visual_map);
    title('ECC')

    visual_map(:,:,1) = 0;
    visual_map(:,:,2) = 255;
    visual_map(:,:,3) = 0;
    visual_map(:,output_bitstream~=bitstream,1) = 255;
    visual_map(:,output_bitstream~=bitstream,2) = 0;
    subplot(2,1,2);
    imshow(visual_map);
    title('none');

    display(SNR)
    disp('encode')
    display(sum(mess_rec~=bitstream)/(mess_len*(bitpcode-1)))
    disp('noencode')
    display(sum(output_bitstream~=bitstream)/(mess_len*(bitpcode-1)))
end