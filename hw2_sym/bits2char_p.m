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