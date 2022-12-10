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

bitpcode = ceil(log2(N_mod-1));
bitstream = round(rand(1,mess_len*(bitpcode-1)));
message = zeros(1,mess_len);
for k = 1:mess_len
    message(k) = bin2dec(num2str(bitstream((k-1)*(bitpcode-1)+1:k*(bitpcode-1))));
end
mess_encode = RSA_encode(pub_key, N_mod, mess_len, message); 

%change to bin
input_code = zeros(1,bitpcode*mess_len);
for k = 1:mess_len
    input_code((k-1)*bitpcode+1 : k*bitpcode) = dec2bin(mess_encode(k),bitpcode)-'0';
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
    output = zeros(1,mess_len);
    for k = 1:mess_len
        output(k) = bin2dec(num2str(output_code((k-1)*bitpcode+1 : k*bitpcode)));
    end

    %decode
    mess_decode = RSA_encode(pri_key, N_mod, mess_len, output);

    mess_rec = zeros(1,(bitpcode-1)*mess_len);
    for k = 1:mess_len
        mess_rec((k-1)*(bitpcode-1)+1 : k*(bitpcode-1)) = dec2bin(mod(mess_decode(k),2^(bitpcode-1)),bitpcode-1)-'0';
    end


    %% none
    %trans
    [output_bitstream,es] = realcore_channel(bitstream,1,T,K,fs,n0,0);

    %% visual
    h = figure();
    sgt = sgtitle('Error Pattern ','Color','Red');
    sgt.FontSize = 20;
    set(sgt, 'FontName', 'Times New Roman');
    visual_map = zeros(200,mess_len*(bitpcode-1),3);
    visual_map(:,:,1) = 0;
    visual_map(:,:,2) = 255;
    visual_map(:,:,3) = 0;
    visual_map(:,mess_rec~=bitstream,1) = 255;
    visual_map(:,mess_rec~=bitstream,2) = 0;
    subplot(2,1,1);
    imshow(visual_map);
    title('RSA')

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