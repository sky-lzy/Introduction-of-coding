function [output_bits, err_rate] = BSC_channel(input_bits, rate_s, rate_sample, freq_carrier, SNR, modulation_mode, M, Is_plot)

    k = log2(M); 
    mess_len = length(input_bits); 
%     if (mod(mess_len, k))
%         error('The length of message is not in integral multiple of k. '); 
%     end

    % Electric Level Modulation
    input_bits = [input_bits,zeros(1,mod(k-length(input_bits),k))];
    input_bits_group = reshape(input_bits, k, ceil(mess_len/k));
    input_bits_group = bin2dec(char(input_bits_group'+'0'))';
    if (modulation_mode == "psk") 
%         tx_elec = pskmod(input_bits_group, M, 'InputType', 'bit'); 
        tx_elec = pskmod(input_bits_group, M); 
    elseif (modulation_mode == "qam")
%         tx_elec = qammod(input_bits_group, M, 'InputType', 'bit', 'UnitAveragePower', 1); 
        tx_elec = qammod(input_bits_group, M, 'UnitAveragePower', 1); 
    else
        error('Modulation Mode can only be "psk" or "qam". '); 
    end

    % Baseband Wave 
    % rate_b = rate_s * k; 
    signal_sample = rate_sample/rate_s; 
    tx_bswave = kron(tx_elec, ones(1, signal_sample)); 
    
    % Passband Wave Modulation
    run_sample = length(tx_bswave); 
    carrier_cos = sqrt(2) * cos(2*pi*freq_carrier*(0:run_sample-1)/rate_sample); 
    carrier_sin = sqrt(2) * -sin(2*pi*freq_carrier*(0:run_sample-1)/rate_sample); 
    tx_pswave = real(tx_bswave) .* carrier_cos + imag(tx_bswave) .* carrier_sin; 

    % AWGN 
    SNR_pow = db2pow(-SNR); 
    rx_pswave = tx_pswave + randn(1, run_sample) * sqrt(SNR_pow*rate_s/2); 

    % Passband Demodulation
    rx_bswave = rx_pswave .* carrier_cos + 1j * rx_pswave .* carrier_sin; 

    % Baseband Matched Filtering 
    rx_elec = mean(reshape(rx_bswave, signal_sample, run_sample/signal_sample), 1); 

    % Electric Level Demodulation
    if (modulation_mode == "psk") 
%         output_bits = pskdemod(rx_elec, M, 'OutputType', 'bit'); 
        output_bits = pskdemod(rx_elec, M); 
    elseif (modulation_mode == "qam")
%         output_bits = qamdemod(rx_elec, M, 'OutputType', 'bit', 'UnitAveragePower', 1); 
        output_bits = qamdemod(rx_elec, M, 'UnitAveragePower', 1); 
    end
    output_bits = double(dec2bin(output_bits')-'0')';

    output_bits = reshape(output_bits, 1, []); 

    err_rate = biterr(input_bits, output_bits) / mess_len; 

    if (exist('Is_plot', 'var') && Is_plot)
        % Constellation
        % figure(); 
        % subplot(1, 2, 1); 
        % scatterplot(tx_elec); 
        % title('Constellation of Transmitter'); 
        % temp2 = subplot(1, 2, 2); 
        scatterplot(rx_elec); 
        title('Constellation of Receiver'); 

        % Wave 
        figure(); 
        subplot(4, 1, 1); 
        plot(1:1e4, real(tx_bswave(1:1e4))); 
        hold on; 
        plot(1:1e4, imag(tx_bswave(1:1e4))); 
        title('Baseband Wave of Transmitter'); 
        subplot(4, 1, 2); 
        plot(1:1e4, tx_pswave(1:1e4)); 
        title('Passband Wave of Transmitter'); 
        subplot(4, 1, 3); 
        plot(1:1e4, rx_pswave(1:1e4)); 
        title('Passband Wave of Receiver'); 
        subplot(4, 1, 4); 
        plot(1:1e4, real(rx_bswave(1:1e4))); 
        hold on; 
        plot(1:1e4, imag(rx_bswave(1:1e4))); 
        title('Baseband Wave of Receiver'); 

        % Power Density 
        
    end

end
