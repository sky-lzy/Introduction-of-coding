function [output,eb] = realcore_channel(input,N_bits,T,K,fs,n0,visualize)
    u = pskmod(input,2^N_bits);% 将比特映射为复电平
%     scatterplot(u);
    [v,es] = core(u,T,K,fs,n0,visualize);
    eb = es/N_bits;
    output = pskdemod(v,N_bits);%符号判决
end

function [v,es] = core(u,T,K,fs,n0,visualize)
    rng(0);
    
    N = length(u); % 符号序列长度
    t = 0:T-1;
    carrier = exp(1j*2*pi*t*K/T);
    v = zeros(1,N);
    x_plot = [];
    s_plot = [];
    r_plot = [];
    es = 0;
    for i = 1:N
        x = u(i)*ones(1,T);
        x_plot = [x_plot,x];
        s = real(x.*carrier);
        es = es + sum(s.^2);
        s_plot = [s_plot,s];
        noise = randn(1,T)*sqrt(fs*n0/2);
        r = s+noise;
        r_plot = [r_plot,r];
        y = real(r*2.*carrier.^(-1));
        v(i) = sum(y)/T;
    end
    es = es/fs;
    
    
    if visualize
        % planisphere
        scatterplot(u);
        scatterplot(v);
        
        % frequency spectrum
        figure();
        subplot(2,1,1);hold on;
        xlabel('Frequency(Hz)');
        ylabel('Magnitude');
        grid on;
        title('Baseband spectrum')
        plot(-fs/2+1:fs/2,abs(fftshift(fft(x_plot,fs))));
        
        subplot(2,1,2);hold on;
        xlabel('Frequency(Hz)');
        ylabel('Magnitude');
        title('Carrier spectrum')
        grid on;
        plot(-fs/2+1:fs/2,abs(fftshift(fft(s_plot,fs))));
        
        % waveform
        figure();
        subplot(2,1,1);hold on;
        xlabel('t');
        ylabel('s');
        title('Transmission signal waveform')
        grid on;
        plot(0:N*T-1,s_plot);
        
        subplot(2,1,2);hold on;
        xlabel('t');
        ylabel('r');
        title('Received signal waveform')
        grid on;
        plot(0:N*T-1,r_plot);
        
        
        
        % power spectrum
        figure();
        subplot(2,1,1);hold on;
        plot(-fs/2+1:fs/2,pow2db(abs(fftshift(fft(xcorr(s_plot),fs)))));
        xlabel('frequency(Hz)');
        ylabel('power/frequency(dB/Hz)');
        title('power spectrum of transmission signal')
        grid on;
        
        subplot(2,1,2);hold on;
        plot(-fs/2+1:fs/2,pow2db(abs(fftshift(fft(xcorr(r_plot),fs)))));
        xlabel('frequency(Hz)');
        ylabel('power/frequency(dB/Hz)');
        title('power spectrum of received signal')
        grid on;
        
        
        
    end
end