function out = mul(in1, in2)
% Input: two 0-255 integers
% Output: a 0-255 integer, the product

in1b = dec2bin(in1,8) - '0';
in2b = dec2bin(in2,8) - '0';
p = [1,0,0,0,1,1,0,1,1]; % 283
out = boolean(mod(conv(in1b, in2b),2));
for k = 1:7
    if(out(k))
        out(k:k+8) = xor(out(k:k+8), p);
    end
end
% out(8:15)
out = bin2dec(char(out + '0'));
end