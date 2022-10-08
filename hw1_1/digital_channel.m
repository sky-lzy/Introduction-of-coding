function output_bits = digital_channel(input_bits, N_bits, T, b, rou, sigma_n, Is_plot_scatter)

    % encode: N_bits-bit for every signal
    M = 2^N_bits;
    len_encode = length(input_bits)/N_bits;
    encode_bits = zeros(1, len_encode);
    for iter = 1:len_encode
        encode_bits(iter) = bin2dec(num2str(input_bits(N_bits*(iter-1)+1:N_bits*iter)));
    end

    u = pskmod(encode_bits, M);
    v = complex_elec_channel(u, T, b, rou, sigma_n);
    receive_bits = pskdemod(v, M);

    % decode
    output_bits = zeros(1, length(input_bits));
    for iter = 1:len_encode
        output_bits(N_bits*(iter-1)+1:N_bits*iter) = dec2bin(receive_bits(iter), N_bits) - '0';
    end

    % visualization
    if ((exist('Is_plot_scatter', 'var')) && (Is_plot_scatter == true))
        scatterplot(u);
        scatterplot(v);
    end

end

function y = complex_sample_channel(x, b, rou, sigma_n)

    N = length(x);

    betas = zeros(1, N);
    betas(1) = (randn() + 1j*randn()) / sqrt(2);
    for iter_i = 2:N
        z_i = (randn() + 1j*randn()) / sqrt(2);
        betas(iter_i) = rou*betas(iter_i-1) + sqrt(1-rou^2)*z_i;
    end

    a = sqrt(1-b^2) + b*betas;
    noise = (randn(1, N) + 1j*randn(1, N)) * sigma_n / sqrt(2);
    y = a.*x + noise;

end

function v = complex_elec_channel(u, T, b, rou, sigma_n)

    L = length(u);
    v = zeros(1, L);

    for iter_l = 1:L
        x = 1/sqrt(T)*u(iter_l)*ones(1, T);
        y = complex_sample_channel(x, b, rou, sigma_n);
        v(iter_l) = 1/sqrt(T)*sum(y);
    end

end
