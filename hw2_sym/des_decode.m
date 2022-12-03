function message = aes_decode(ciphertext, key, CBC)
% Input: two uint8/char vectors, message to decrypt and key, and CBC or ECB
% Output: a char vector, the message

% default mode: CBC
if(~exist('CBC','var'))
    CBC = true;
end

% default key: V me 50!
if(~exist('key','var'))
    key = 'KFCCrazyThuVMe50';
end

% subkey generation
s_box = s_box_foward();
keys = subkey(key,s_box);
Nblocks  = length(ciphertext) / 16; % block num

% decryption
message = char(zeros(size(ciphertext)));
for k = 1:Nblocks
    message(16*k-15:16*k) = des_bl_decode(ciphertext(16*k-15:16*k),keys); % decrypt by block
    if(CBC && k>1) % xor last cipher block
        message(16*k-15:16*k) = bitxor(uint8(message(16*k-15:16*k)),uint8(ciphertext(16*k-31:16*k-16)));
    end
end
Npadding = uint8(message(end)); % padding num
if(length(message) > Npadding)
    message = char(message(1:end-Npadding)); % remove padding and convert to char
end

end