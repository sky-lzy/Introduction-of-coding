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