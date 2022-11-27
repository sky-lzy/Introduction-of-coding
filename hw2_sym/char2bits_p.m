function bits = char2bits_p(ch)
% Input: a char vector
% Output: a bit vector

Nchar = length(ch); % num of char
bits = zeros(1,8*Nchar);
for k = 1:Nchar
    bits(8*k-7:8*k) = dec2bin(ch(k),8)-'0';
end

Np = uint8(ch(end)); % padding bits num
bits = bits(1:(end-8-Np)); % remove padding

end