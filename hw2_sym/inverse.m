function out = inverse(in)
% Input: a 0-255 number
% Output: a 0-255 number, multiplicative inverse of Input in GF(2^8) = GF(2) [x]/(x8 + x4 + x3 + x + 1)

in = uint8(in);
% special cases
if(in==0 || in==1)
    out = in;
    return;
end

inb = dec2bin(in,8) - '0';
p = [1,0,0,0,1,1,0,1,1]; % 283
% initialize
dividend = p;
divisor = inb;
q = zeros(8, 8);
r = zeros(8, 8);
x = zeros(10, 8);
x(2,:) = [0,0,0,0,0,0,0,1];
count = 0;
% Euclidean algorithm
while(1) % r > 1
    count = count + 1;
    [q(count,:), r(count,:)] = div(dividend, divisor);
    x(count+2,:) = mod(x(count,:) - mul_vec(x(count+1,:),q(count,:)), 2);
    dividend = divisor;
    divisor = r(count,:);
    if(~any(divisor(1:7)) && divisor(8)) % reaches 1
        break;
    end
end

out = bin2dec(char(x(count+2,:) + '0'));

end

function [q, r] = div(in1, in2)
% Input: two vectors with element 0/1, in1 > in2
% Output: two 8-bit vectors, the quotient and the remainder

% remove higher 0s
in1 = in1(find(in1,1):end);
l1 = length(in1);
in2 = in2(find(in2,1):end);
l2 = length(in2);

% divide
q0 = zeros(1, l1);
for k = 1:(l1 - l2 + 1)
    if(in1(k))
        in1(k:k+l2-1) = xor(in1(k:k+l2-1), in2);
        q0(k + l2 - 1) = 1;
    end
end

% remove higher 0s
q0 = q0(find(q0,1):end);
r0 = in1(find(in1,1):end);
% adjust format
q = zeros(1, 8);
q((end - length(q0) + 1):end) = q0;
r = zeros(1, 8);
r((end - length(r0) + 1):end) = r0;

end

function out = mul_vec(in1, in2)
% Input: two 8-bit vector
% Output: a 8-bit vector, the product

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
out = out(8:15); % adjust format
end