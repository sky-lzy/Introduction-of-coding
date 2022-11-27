function output = realcore_channel(input,N_bits,T,K,n0,visualize)
    u = pskmod(input,2^N_bits);
%     scatterplot(u);
    v = core(u,T,K,n0,visualize);
    output = pskdemod(v,N_bits);
end

function v = core(u,T,K,n0,visualize)
    rng(0);
    fs = 10000;% 假定采样率10k
    N = length(u);
    t = 1:T;
    carrier = exp(1j*2*pi*t*K/T);
    v = zeros(1,N);
    x_plot = [];
    s_plot = [];
    y_plot = [];
    r_plot = [];
    for i = 1:N
        x = u(i)*ones(1,T);
        x_plot = [x_plot,x];
        s = real(x.*carrier);
        s_plot = [s_plot,s];
        noise = randn(1,T)*sqrt(fs*n0/2);
        r = s+noise;
        r_plot = [r_plot,r];
        y = real(r*2.*carrier.^(-1));
        y_plot = [y_plot,y];
        v(i) = sum(y)/T;
    end
    if visualize
        % wave
        scatterplot(u);
        scatterplot(v);
        
        figure();
        subplot(2,2,1);hold on;
        grid on;
        xlabel('t');
        ylabel('x');
        plot(0:N*T-1,x_plot);
        
        subplot(2,2,3);hold on;
        xlabel('t');
        ylabel('s');
        grid on;
        plot(0:N*T-1,x_plot);
        
        
        subplot(2,2,2);hold on;
        xlabel('t');
        ylabel('y');
        grid on;
        plot(0:N*T-1,y_plot);
        
        subplot(2,2,4);hold on;
        xlabel('t');
        ylabel('r');
        grid on;
        plot(0:N*T-1,r_plot);
        
        % power spectrum
        
        figure();
        subplot(2,1,1);hold on;
        plot(-fs/2+1:fs/2,abs(fft(xcorr(s),fs)));
        xlabel('f(Hz)');
        ylabel('power spectrum of sended signal');
        grid on;
        
        subplot(2,1,2);hold on;
        plot(-fs/2+1:fs/2,abs(fft(xcorr(r),fs)));
        xlabel('f(Hz)');
        ylabel('power spectrum of received signal');
        grid on;
        
        
        
    end
end