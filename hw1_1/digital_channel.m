function output_bits = digital_channel(input_bits, N_bits, T, b, rou, sigma_n, Is_plot_scatter, Send_acquire_beta, Recv_acquire_beta)

    send_flag = exist('Send_acquire_beta', 'var') && (Send_acquire_beta == true);
    recv_flag = exist('Recv_acquire_beta', 'var') && (Recv_acquire_beta == true);

    % encode: N_bits-bit for every signal
    M = 2^N_bits;
    len_encode = length(input_bits)/N_bits;
    encode_bits = zeros(1, len_encode);
    for iter = 1:len_encode
        encode_bits(iter) = bin2dec(num2str(input_bits(N_bits*(iter-1)+1:N_bits*iter)));
    end
    
    % generate channel
    a = generate_channel(len_encode*T, b, rou);
    % avg_a = zeros(1, len_encode);
    % for iter_t = 1:T
    %     avg_a = mean(a(T*(iter_t-1)+1:T*iter_t));
    % end

    % signal processing
    u = pskmod(encode_bits, M);
    % if (send_flag)
    %     u = u .* exp(-1j*angle(avg_a));
    % end
    v = complex_elec_channel(u, T, a, sigma_n, send_flag, ~send_flag&&recv_flag);
    % if (~send_flag && recv_flag)
    %     v = v .* exp(-1j*angle(avg_a));
    % end
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

function y = complex_sample_channel(x, a, sigma_n)

    N = length(x);
    noise = (randn(1, N) + 1j*randn(1, N)) * sigma_n / sqrt(2);
    y = a.*x + noise;

end

function v = complex_elec_channel(u, T, a, sigma_n, flag_send, flag_recv)

    L = length(u);
    v = zeros(1, L);

    for iter_l = 1:L
        x = 1/sqrt(T)*u(iter_l)*ones(1, T);
        if (flag_send)
            x = x .* exp(-1j*angle(a(T*(iter_l-1)+1:T*iter_l)));
        end
        y = complex_sample_channel(x, a(T*(iter_l-1)+1:T*iter_l), sigma_n);
        if (flag_recv)
            y = y .* exp(-1j*angle(a(T*(iter_l-1)+1:T*iter_l)));
        end
        v(iter_l) = 1/sqrt(T)*sum(y);
    end

end

function a = generate_channel(N, b, rou)

    betas = zeros(1, N);
    betas(1) = (randn() + 1j*randn()) / sqrt(2);
    for iter_n = 2:N
        z_n = (randn() + 1j*randn()) / sqrt(2);
        betas(iter_n) = rou*betas(iter_n-1) + sqrt(1-rou^2)*z_n;
    end

    a = sqrt(1-b^2) + b*betas;

end