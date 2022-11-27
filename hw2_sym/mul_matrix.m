function out = mul_matrix(in1, in2)
% Input: two 4x4 matrix with element 0-255
% Output: a 4x4 matrix with element 0-255, the product

out = zeros(4,4);
for k = 1:4
    for l = 1:4
        for m = 1:4
            out(k,l) = bitxor(out(k,l), mul(in1(k,m), in2(m,l)));
        end
    end
end
out = uint8(out);

end