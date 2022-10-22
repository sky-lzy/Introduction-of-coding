function [decode,corr_rate] = conv_decode(r,l_decode,g,sorh,dtest,crc,block_size,block_number)
    %'r'为待解码序列，'l_decode'为解码出的长度,'g'为卷积码系数（*一定注意要逐行翻转）,'crc'是否为crc
    %'block_size'crc块大小,'block_number'crc块数,'sorh'软判决1或者硬判决0
    %decode为输出序列，corr_rate为输出正确率(crc=0是为逐个比特误码率，crc=1时为误块率)
    %只适用于卷积后长度和码流长度之比为整数的情况

    L = length(r);                   %L为收到卷积码长度 
    rate = L/l_decode;               %卷积后长度和码流长度之比
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if sorh       %软判决译码
        state_re = zeros(8,l_decode);    %用于回溯状态
        decode = zeros(1,l_decode);      %最后解码出的信息
        templ_1 = zeros(8,rate);   %当前状态输入1之后编码器输出的2bit编码值,1~8分别对应000~111
        templ_0 = zeros(8,rate);   %当前状态输入0之后编码器输出的2bit编码值,1~8分别对应000~111

        %生成维特比的转换图
        for i = 1:8
            cur_state = zeros(1,3);
            cur_state(3) = mod(i-1,2);
            cur_state(2) = mod((i-1-cur_state(3))/2,2);
            cur_state(1) = mod(((i-1-cur_state(3))/2-cur_state(2))/2,2);
            %templ_1(i,1) = mod([1,0,1,1]*[cur_state,1]',2);
            %templ_1(i,2) = mod([1,1,1,1]*[cur_state,1]',2);
            %templ_0(i,1) = mod([1,0,1,1]*[cur_state,0]',2);
            %templ_0(i,2) = mod([1,1,1,1]*[cur_state,0]',2);
            for k = 1:rate
                templ_1(i,k) = mod(g(k,:)*[cur_state,1]',2);
                templ_0(i,k) = mod(g(k,:)*[cur_state,0]',2);
            end
        end
        templ_1 = (1-templ_1*2)*(1+sqrt(-1));   %将模板进行复电平映射，0映射到1+j，1映射到-1-j
        templ_0 = (1-templ_0*2)*(1+sqrt(-1));

        state_prob = zeros(1,8);     %记录每个状态当前的概率值
        next_state_prob = zeros(1,8);  %记录下一拍每个状态的概率值
        next_state_prob = next_state_prob - 10000;
        state_act = zeros(1,8); %记录当前状态是否有路径达到（1200个点大概率都会达到，所以只在最初几步有用）
        state_act(1) = 1;       %起始状态为000
        next_state_act = zeros(1,8);
        next_state_act(1) = 1;
        for i = 1:rate:L           %每次取rate位，依次遍历接收到的r
            for j = 1:8         %逐个状态计算最大值
                if mod(j-1,2)   %如果状态最后一位为1，证明这次输入为1
                    %(j-2)/2+1和(j-2)/2+5是两个可以得到该状态的上一拍状态，要比较哪一种概率最大
                    if state_act((j-2)/2+1) && state_act((j-2)/2+5) %两种状态都已有路径可以达到
                        prob1 = state_prob((j-2)/2+1);
                        prob2 = state_prob((j-2)/2+5);
                        for k =1:rate
                            prob1 = prob1 + cal_theta(r(i+k-1),templ_1((j-2)/2+1,k));
                        end
                        for k = 1:rate
                            prob2 = prob2 + cal_theta(r(i+k-1),templ_1((j-2)/2+5,k));
                        end
                        %comp = [state_prob((j-2)/2+1) + cal_theta(r(i),templ_1((j-2)/2+1,1))+cal_theta(r(i+1),templ_1((j-2)/2+1,2)),...
                        %state_prob((j-2)/2+5) +  cal_theta(r(i),templ_1((j-2)/2+5,1))+cal_theta(r(i+1),templ_1((j-2)/2+5,2))];
                        comp = [prob1,prob2];
                        [next_state_prob(j),I] = max(comp);
                        if I == 1
                            state_re(j,(i+rate-1)/rate) = (j-2)/2+1;
                        else
                            state_re(j,(i+rate-1)/rate) = (j-2)/2+5;
                        end
                        next_state_act(j) = 1;
                    elseif state_act((j-2)/2+1)                    %只有第一种状态有路径
                        state_re(j,(i+rate-1)/rate) = (j-2)/2+1;
                        next_state_prob(j) = state_prob((j-2)/2+1);
                        for k =1:rate
                            next_state_prob(j) = next_state_prob(j) + cal_theta(r(i+k-1),templ_1((j-2)/2+1,k));
                        end
                        %next_state_prob(j) = state_prob((j-2)/2+1) + cal_theta(r(i),templ_1((j-2)/2+1,1))+cal_theta(r(i+1),templ_1((j-2)/2+1,2));
                        next_state_act(j) = 1;
                    elseif state_act((j-2)/2+5)                    %只有第二种状态有路径
                        state_re(j,(i+rate-1)/rate) = (j-2)/2+5;
                        next_state_prob(j) = state_prob((j-2)/2+5);
                        for k = 1:rate
                            next_state_prob(j) = next_state_prob(j) + cal_theta(r(i+k-1),templ_1((j-2)/2+5,k));
                        end
                        %next_state_prob(j) = state_prob((j-2)/2+5) + cal_theta(r(i),templ_1((j-2)/2+5,1))+cal_theta(r(i+1),templ_1((j-2)/2+5,2));
                        next_state_act(j) = 1;
                    end
                
                else            %如果状态最后一位不为1，证明这次输入为0
                    %(j-1)/2+1和(j-1)/2+5是两个可以得到该状态的上一拍状态，要比较哪一种概率最大
                    if state_act((j-1)/2+1) && state_act((j-1)/2+5) %两种状态都已有路径可以达到
                        prob1 = state_prob((j-1)/2+1);
                        prob2 = state_prob((j-1)/2+5);       
                        for k =1:rate
                            prob1 = prob1 + cal_theta(r(i+k-1),templ_0((j-1)/2+1,k));
                        end
                        for k = 1:rate
                            prob2 = prob2 + cal_theta(r(i+k-1),templ_0((j-1)/2+5,k));
                        end                 
                        %comp = [state_prob((j-1)/2+1) + cal_theta(r(i),templ_0((j-1)/2+1,1))+cal_theta(r(i+1),templ_0((j-1)/2+1,2)),...
                        %state_prob((j-1)/2+5) +  cal_theta(r(i),templ_0((j-1)/2+5,1))+cal_theta(r(i+1),templ_0((j-1)/2+5,2))];
                        comp = [prob1,prob2];
                        [next_state_prob(j),I] = max(comp); 
                        if I == 1
                            state_re(j,(i+rate-1)/rate) = (j-1)/2+1;
                        else
                            state_re(j,(i+rate-1)/rate) = (j-1)/2+5;
                       end
                        next_state_act(j) = 1;
                    elseif state_act((j-1)/2+1)                    %只有第一种状态有路径
                        state_re(j,(i+rate-1)/rate) = (j-1)/2+1;
                        next_state_prob(j) = state_prob((j-1)/2+1);
                        for k =1:rate
                            next_state_prob(j) = next_state_prob(j) + cal_theta(r(i+k-1),templ_0((j-1)/2+1,k));
                        end
                        %next_state_prob(j) = state_prob((j-1)/2+1) + cal_theta(r(i),templ_0((j-1)/2+1,1))+cal_theta(r(i+1),templ_0((j-1)/2+1,2));
                        next_state_act(j) = 1;
                    elseif state_act((j-1)/2+5)                    %只有第二种状态有路径
                        state_re(j,(i+rate-1)/rate) = (j-1)/2+5;
                        next_state_prob(j) = state_prob((j-1)/2+5);
                        for k = 1:rate
                            next_state_prob(j) = next_state_prob(j) + cal_theta(r(i+k-1),templ_0((j-1)/2+5,k));
                        end
                        %next_state_prob(j) = state_prob((j-1)/2+5) + cal_theta(r(i),templ_0((j-1)/2+5,1))+cal_theta(r(i+1),templ_0((j-1)/2+5,2));
                        next_state_act(j) = 1;
                    end
                end
            end
            state_prob = next_state_prob;
            state_act = next_state_act;
        end

        [~,I] = max(state_prob);
        decode(L/rate) = mod(I-1,2);
        I = state_re(I,L/rate);
        for i = L/rate-1:-1:1
            decode(i) = mod(I-1,2);
            I = state_re(I,i);
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    else          %硬判决译码          
        %首先判决r
        for i = 1:L
            if cal_theta(r(i),(1+sqrt(-1)))>0
                r(i) = 0;
            else
                r(i) = 1;
            end
        end

        state_re = zeros(8,l_decode);    %用于回溯状态
        decode = zeros(1,l_decode);      %最后解码出的信息
        templ_1 = zeros(8,rate);   %当前状态输入1之后编码器输出的2bit编码值,1~8分别对应000~111
        templ_0 = zeros(8,rate);   %当前状态输入0之后编码器输出的2bit编码值,1~8分别对应000~111

        %生成维特比的转换图
        for i = 1:8
            cur_state = zeros(1,3);
            cur_state(3) = mod(i-1,2);
            cur_state(2) = mod((i-1-cur_state(3))/2,2);
            cur_state(1) = mod(((i-1-cur_state(3))/2-cur_state(2))/2,2);
            %templ_1(i,1) = mod([1,0,1,1]*[cur_state,1]',2);
            %templ_1(i,2) = mod([1,1,1,1]*[cur_state,1]',2);
            %templ_0(i,1) = mod([1,0,1,1]*[cur_state,0]',2);
            %templ_0(i,2) = mod([1,1,1,1]*[cur_state,0]',2);
            for k = 1:rate
                templ_1(i,k) = mod(g(k,:)*[cur_state,1]',2);
                templ_0(i,k) = mod(g(k,:)*[cur_state,0]',2);
            end
        end


        state_prob = zeros(1,8);     %记录每个状态当前的概率值
        next_state_prob = zeros(1,8);  %记录下一拍每个状态的概率值
        next_state_prob = next_state_prob - 10000;
        state_act = zeros(1,8); %记录当前状态是否有路径达到（1200个点大概率都会达到，所以只在最初几步有用）
        state_act(1) = 1;       %起始状态为000
        next_state_act = zeros(1,8);
        next_state_act(1) = 1;
        for i = 1:rate:L           %每次取rate位，依次遍历接收到的r
            for j = 1:8         %逐个状态计算最大值
                if mod(j-1,2)   %如果状态最后一位为1，证明这次输入为1
                    %(j-2)/2+1和(j-2)/2+5是两个可以得到该状态的上一拍状态，要比较哪一种概率最大
                    if state_act((j-2)/2+1) && state_act((j-2)/2+5) %两种状态都已有路径可以达到
                        comp = [state_prob((j-2)/2+1) + sum(r(i:i+rate-1)==templ_1((j-2)/2+1,:)'), ...
                        state_prob((j-2)/2+5) +  sum(r(i:i+rate-1)==templ_1((j-2)/2+5,:)')];
                        [next_state_prob(j),I] = max(comp);
                        if I == 1
                            state_re(j,(i+rate-1)/rate) = (j-2)/2+1;
                        else
                            state_re(j,(i+rate-1)/rate) = (j-2)/2+5;
                        end
                        next_state_act(j) = 1;
                    elseif state_act((j-2)/2+1)                    %只有第一种状态有路径
                        state_re(j,(i+rate-1)/rate) = (j-2)/2+1;
                        next_state_prob(j) = state_prob((j-2)/2+1) + sum(r(i:i+rate-1)==templ_1((j-2)/2+1,:)');
                        next_state_act(j) = 1;
                    elseif state_act((j-2)/2+5)                    %只有第二种状态有路径
                        state_re(j,(i+rate-1)/rate) = (j-2)/2+5;
                        next_state_prob(j) = state_prob((j-2)/2+5) + sum(r(i:i+rate-1)==templ_1((j-2)/2+5,:)');
                        next_state_act(j) = 1;
                    end

                else            %如果状态最后一位不为1，证明这次输入为0
                    %(j-1)/2+1和(j-1)/2+5是两个可以得到该状态的上一拍状态，要比较哪一种概率最大
                    if state_act((j-1)/2+1) && state_act((j-1)/2+5) %两种状态都已有路径可以达到
                        comp = [state_prob((j-1)/2+1) + sum(r(i:i+rate-1)==templ_0((j-1)/2+1,:)'),...
                        state_prob((j-1)/2+5) +  sum(r(i:i+rate-1)==templ_0((j-1)/2+5,:)')];
                        [next_state_prob(j),I] = max(comp); 
                        if I == 1
                            state_re(j,(i+rate-1)/rate) = (j-1)/2+1;
                        else
                            state_re(j,(i+rate-1)/rate) = (j-1)/2+5;
                        end
                        next_state_act(j) = 1;
                    elseif state_act((j-1)/2+1)                    %只有第一种状态有路径
                        state_re(j,(i+rate-1)/rate) = (j-1)/2+1;
                        next_state_prob(j) = state_prob((j-1)/2+1) + sum(r(i:i+rate-1)==templ_0((j-1)/2+1,:)');
                        next_state_act(j) = 1;
                    elseif state_act((j-1)/2+5)                    %只有第二种状态有路径
                        state_re(j,(i+rate-1)/rate) = (j-1)/2+5;
                        next_state_prob(j) = state_prob((j-1)/2+5) + sum(r(i:i+rate-1)==templ_0((j-1)/2+5,:)');
                        next_state_act(j) = 1;
                    end
                end
            end
            state_prob = next_state_prob;
            state_act = next_state_act;
        end

        [~,I] = max(state_prob);
        decode(l_decode) = mod(I-1,2);
        I = state_re(I,l_decode);
        for i = l_decode-1:-1:1
            decode(i) = mod(I-1,2);
            I = state_re(I,i);
        end


    end
    if crc
        corr_block = 0;
        for i = 1:block_number-1
            bit_to_test = decode((i-1)*block_size+1:i*block_size);
            out = crc3(bit_to_test);
            if out(end-2:end) == [0;0;0]
                corr_block = corr_block + 1;
            end
        end
        bit_to_test = decode((block_number-1)*block_size+1:end);
        out = crc3(bit_to_test);
        if out(end-2:end) == [0;0;0]
            corr_block = corr_block + 1;
        end
        corr_rate = corr_block/block_number;
    else
        corr_rate = sum(decode==dtest)/(L/rate);
    end
end

