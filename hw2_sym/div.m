function [q, r] = div(in1, in2)
% Input: two vectors with element 0/1, in1 > in2
% Output: two vectors, the quotient and the remainder

% p = [1,0,0,0,1,1,0,1,1]; % 283
in1 = in1(find(in1,1):end);
l1 = length(in1);
in2 = in2(find(in2,1):end);
l2 = length(in2);

q0 = zeros(1, l1);
for k = 1:(l1 - l2 + 1)
    if(in1(k))
        in1(k:k+l2-1) = xor(in1(k:k+l2-1), in2);
        q0(k + l2 - 1) = 1;
    end
end

q0 = q0(find(q0,1):end);
r0 = in1(find(in1,1):end);
q = zeros(1, 8);
q((end - length(q0) + 1):end) = q0;
r = zeros(1, 8);
r((end - length(r0) + 1):end) = r0;

end