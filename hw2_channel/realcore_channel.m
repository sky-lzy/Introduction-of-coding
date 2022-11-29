function [output_code,es] = realcore_channel(input_code,N_bits,T,K,fs,n0,visualize)
%   输出判决结果和总符号能量
    len_encode = length(input_code);
    encode_code = zeros(1, len_encode/N_bits);
    for iter = 1:len_encode/N_bits
        encode_code(iter) = bin2dec(num2str(input_code(N_bits*(iter-1)+1:N_bits*iter)));
    end
    u = pskmod(encode_code,2^N_bits);% 将比特映射为复电平
    
    [v,es,u,x_plot,s_plot,r_plot] = core(u,T,K,fs,n0);
    
    receive_code = pskdemod(v,2^N_bits);%符号判决
    output_code = zeros(1, length(input_code));
    for iter = 1:len_encode/N_bits
        output_code(N_bits*(iter-1)+1:N_bits*iter) = dec2bin(receive_code(iter), N_bits) - '0';
    end
    
    if visualize
        visual(fs,T,K,input_code,u,v,x_plot,s_plot,r_plot);
    end
end

function [v,es,u,x_plot,s_plot,r_plot] = core(u,T,K,fs,n0)
    % 内核为实采样的复电平信道
    % 事实上只有输出复电平v和总符号能量es有用，别的参数用来画图
    % fs用作理论模拟，不影响信道传输
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
        y = r*2.*carrier.^(-1);
        v(i) = sum(y)/T;
    end
    es = es/fs;
    
end

function visual(fs,T,K,input_code,u,v,x_plot,s_plot,r_plot)
        N = length(u); % 符号序列长度
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
        xlabel('采样点');
        ylabel('s');
        title('Transmission signal waveform')
        grid on;
        % 只画二元符号映射
        for i = 0:N-1
            if input_code(i+1)==0
                plot(i*T:(i+1)*T-1,s_plot(i*T+1:(i+1)*T),'color','r','linewidth',1.5);
            else
                plot(i*T:(i+1)*T-1,s_plot(i*T+1:(i+1)*T),'color','g','linewidth',1.5);
            end
        end
        subplot(2,1,2);hold on;
        xlabel('采样点');
        ylabel('r');
        title('Received signal waveform')
        grid on;
        plot(0:N*T-1,r_plot,'linewidth',1.5);
        
        
        
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