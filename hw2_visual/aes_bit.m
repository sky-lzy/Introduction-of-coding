function out = aes_bit(in_bit, en, key_bit)
% Input: in: a bit vector, message or ciphertext in bit
%        key_bit: 1x128 bit vector, the key, default: 'KFCCrazyThuVMe60'
%        en: true-encrypt(default), false-decrypt
% Output: out: 1x128 bit vector, ciphertext(mode==true) or message(otherwise)
% !WARNING!: when en==false, if the ciphertext is wrong, the length of the message decryptede might be wrong too!

% default mode: encrypt
if(~exist('en','var'))
    en = true;
end

% default key: V me 50!
if(~exist('key_bit','var'))
    key = 'KFCCrazyThuVMe50';
else
    key = bits2char(key_bit); % bit 2 char (no padding)
end

if(en)
    in = bits2char_p(in_bit); % bit 2 char (padding)
    out = aes(in, key); % encrypt
    out = char2bits(out);
else
    in = bits2char(in_bit); % bit 2 char (no padding)
    out = aes_decode(in, key); % decrypt
    out = char2bits_p(out);
end

end

function ch = bits2char(bits)
% Input: a bit vector, length must be multiples of 8
% Output: a char vector

Nchar = length(bits)/8; % num of char
ch = zeros(1,Nchar);
for k = 1:Nchar
    ch(k) = bin2dec(char(bits(8*k-7:8*k)+'0'));
end
ch = char(ch); % convert to char

end

function ch = bits2char_p(bits)
% Input: a bit vector
% Output: a char vector

Nchar = ceil(length(bits)/8)+1; % num of char
ch = zeros(1,Nchar);
for k = 1:(Nchar-2)
    ch(k) = bin2dec(char(bits(8*k-7:8*k)+'0'));
end

Np = 8*(Nchar-1)-length(bits); % padding bits num
ch(Nchar-1) = bin2dec(char([bits(8*(Nchar-1)-7:end),zeros(1,Np)]+'0')); % padding
ch(Nchar) = uint8(Np); % record Np at the end
ch = char(ch); % convert to char

end

function bits = char2bits(ch)
% Input: a char vector
% Output: a bit vector

Nchar = length(ch); % num of char
bits = zeros(1,8*Nchar);
for k = 1:Nchar
    bits(8*k-7:8*k) = dec2bin(ch(k),8)-'0';
end

end

function bits = char2bits_p(ch)
% Input: a char vector
% Output: a bit vector

Nchar = length(ch); % num of char
bits = zeros(1,8*Nchar);
for k = 1:Nchar
    bits(8*k-7:8*k) = dec2bin(ch(k),8)-'0';
end

Np = uint8(ch(end)); % padding bits num
if (length(bits) > 8 + Np)
    bits = bits(1:(end-8-Np)); % remove padding
end

end