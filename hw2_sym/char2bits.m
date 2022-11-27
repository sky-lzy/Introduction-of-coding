function bits = char2bits(ch)
% Input: a char vector
% Output: a bit vector

Nchar = length(ch); % num of char
bits = zeros(1,8*Nchar);
for k = 1:Nchar
    bits(8*k-7:8*k) = dec2bin(ch(k),8)-'0';
end

end