function y = D(x, key)
% Input: two 4x4 uint8 array
% Output: a 4x4 uint8 array

xp = uint8(zeros(1,23));
xp(8:23) = uint8(reshape(x,[1,16]));
yp = uint8(zeros(1,23));
key = reshape(key,[2,8]);
key(key==0) = uint8(max(key,[],'all')) + 1;

for k = 8:23
    for r = 1:8
        yp(k) = bitxor(yp(k), mul(key(2,r), xp(k-r+1)));
    end
    for r = 2:8
        yp(k) = bitxor(yp(k), mul(key(1,r), yp(k-r+1)));
    end
    yp(k) = mul(inverse(key(1,1)),yp(k));
end
y = reshape(uint8(yp(8:23)),[4,4]);

end