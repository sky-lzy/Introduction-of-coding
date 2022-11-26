function out = MixColumns(in)
% Input: a 4x4 matrix with element 0-255
% Output: a 4x4 matrix with element 0-255

pos = [2,3,1,1;1,2,3,1;1,1,2,3;3,1,1,2];
out = mul_matrix(pos, in);

end

function out = mul_matrix(in1, in2)
% Input: two 4x4 matrixs with element 0-255
% Output: a 4x4 matrix with element 0-255, the product

out = zeros(4,4);
for k = 1:4
    for l = 1:4
        for m = 1:4
            out(k,l) = bitxor(out(k,l), mul_num(in1(k,m), in2(m,l)));
        end
    end
end
end

function out = mul_num(in1, in2)
% Input: two 0-255 integer
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