function theta = cal_theta(x1,x2)
    %输入两个复数，计算它们在复平面上的夹角
    a = real(x1)*real(x2)+imag(x1)*imag(x2);
    theta = a/abs(x1)/abs(x2);
end