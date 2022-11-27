function x = D_(y, key)
% Input: two 4x4 uint8 array
% Output: a 4x4 uint8 array

yp = uint8(zeros(1,23));
yp(8:23) = uint8(reshape(y,[1,16]));
xp = uint8(zeros(1,23));
key = reshape(key,[2,8]);
key(key==0) = max(key,[],'all');

for k = 8:23
    for r = 1:8
        xp(k) = bitxor(xp(k), mul(key(1,r), yp(k-r+1)));
    end
    for r = 2:8
        xp(k) = bitxor(xp(k), mul(key(2,r), xp(k-r+1)));
    end
    xp(k) = mul(inverse(key(2,1)),xp(k));
end
x = reshape(uint8(xp(8:23)),[4,4]);

end