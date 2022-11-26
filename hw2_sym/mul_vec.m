function out = mul_vec(in1, in2)
% Input: two 0-255 integers
% Output: a 0-255 integer, the product

inb1 = zeros(1,8);
inb1(end-length(in1)+1:end) = in1;
inb2 = zeros(1,8);
inb2(end-length(in2)+1:end) = in2;

p = [1,0,0,0,1,1,0,1,1]; % 283
out = boolean(mod(conv(inb1, inb2),2));
for k = 1:7
    if(out(k))
        out(k:k+8) = xor(out(k:k+8), p);
    end
end
out = out(8:15);
% out = bin2dec(char(out + '0'));
end