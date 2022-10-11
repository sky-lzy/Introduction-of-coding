function [decode,corr_rate] = conv_decode(r,l_decode,g,sorh,dtest,crc,block_size,block_number)
    %'r'Ϊ���������У�'l_decode'Ϊ������ĳ���,'g'Ϊ�����ϵ����*һ��ע��Ҫ���з�ת��,'crc'�Ƿ�Ϊcrc
    %'block_size'crc���С,'block_number'crc����,'sorh'���о�1����Ӳ�о�0
    %decodeΪ������У�corr_rateΪ�����ȷ��(crc=0��Ϊ������������ʣ�crc=1ʱΪ�����)
    %ֻ�����ھ���󳤶Ⱥ���������֮��Ϊ���������

    L = length(r);                   %LΪ�յ�����볤�� 
    rate = L/l_decode;               %����󳤶Ⱥ���������֮��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if sorh       %���о�����
        state_re = zeros(8,l_decode);    %���ڻ���״̬
        decode = zeros(1,l_decode);      %�����������Ϣ
        templ_1 = zeros(8,rate);   %��ǰ״̬����1֮������������2bit����ֵ,1~8�ֱ��Ӧ000~111
        templ_0 = zeros(8,rate);   %��ǰ״̬����0֮������������2bit����ֵ,1~8�ֱ��Ӧ000~111

        %����ά�رȵ�ת��ͼ
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
        templ_1 = (1-templ_1*2)*(1+sqrt(-1));   %��ģ����и���ƽӳ�䣬0ӳ�䵽1+j��1ӳ�䵽-1-j
        templ_0 = (1-templ_0*2)*(1+sqrt(-1));

        state_prob = zeros(1,8);     %��¼ÿ��״̬��ǰ�ĸ���ֵ
        next_state_prob = zeros(1,8);  %��¼��һ��ÿ��״̬�ĸ���ֵ
        next_state_prob = next_state_prob - 10000;
        state_act = zeros(1,8); %��¼��ǰ״̬�Ƿ���·���ﵽ��1200�������ʶ���ﵽ������ֻ������������ã�
        state_act(1) = 1;       %��ʼ״̬Ϊ000
        next_state_act = zeros(1,8);
        next_state_act(1) = 1;
        for i = 1:rate:L           %ÿ��ȡrateλ�����α������յ���r
            for j = 1:8         %���״̬�������ֵ
                if mod(j-1,2)   %���״̬���һλΪ1��֤���������Ϊ1
                    %(j-2)/2+1��(j-2)/2+5���������Եõ���״̬����һ��״̬��Ҫ�Ƚ���һ�ָ������
                    if state_act((j-2)/2+1) && state_act((j-2)/2+5) %����״̬������·�����Դﵽ
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
                    elseif state_act((j-2)/2+1)                    %ֻ�е�һ��״̬��·��
                        state_re(j,(i+rate-1)/rate) = (j-2)/2+1;
                        next_state_prob(j) = state_prob((j-2)/2+1);
                        for k =1:rate
                            next_state_prob(j) = next_state_prob(j) + cal_theta(r(i+k-1),templ_1((j-2)/2+1,k));
                        end
                        %next_state_prob(j) = state_prob((j-2)/2+1) + cal_theta(r(i),templ_1((j-2)/2+1,1))+cal_theta(r(i+1),templ_1((j-2)/2+1,2));
                        next_state_act(j) = 1;
                    elseif state_act((j-2)/2+5)                    %ֻ�еڶ���״̬��·��
                        state_re(j,(i+rate-1)/rate) = (j-2)/2+5;
                        next_state_prob(j) = state_prob((j-2)/2+5);
                        for k = 1:rate
                            next_state_prob(j) = next_state_prob(j) + cal_theta(r(i+k-1),templ_1((j-2)/2+5,k));
                        end
                        %next_state_prob(j) = state_prob((j-2)/2+5) + cal_theta(r(i),templ_1((j-2)/2+5,1))+cal_theta(r(i+1),templ_1((j-2)/2+5,2));
                        next_state_act(j) = 1;
                    end
                
                else            %���״̬���һλ��Ϊ1��֤���������Ϊ0
                    %(j-1)/2+1��(j-1)/2+5���������Եõ���״̬����һ��״̬��Ҫ�Ƚ���һ�ָ������
                    if state_act((j-1)/2+1) && state_act((j-1)/2+5) %����״̬������·�����Դﵽ
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
                    elseif state_act((j-1)/2+1)                    %ֻ�е�һ��״̬��·��
                        state_re(j,(i+rate-1)/rate) = (j-1)/2+1;
                        next_state_prob(j) = state_prob((j-1)/2+1);
                        for k =1:rate
                            next_state_prob(j) = next_state_prob(j) + cal_theta(r(i+k-1),templ_0((j-1)/2+1,k));
                        end
                        %next_state_prob(j) = state_prob((j-1)/2+1) + cal_theta(r(i),templ_0((j-1)/2+1,1))+cal_theta(r(i+1),templ_0((j-1)/2+1,2));
                        next_state_act(j) = 1;
                    elseif state_act((j-1)/2+5)                    %ֻ�еڶ���״̬��·��
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
    else          %Ӳ�о�����          
        %�����о�r
        for i = 1:L
            if cal_theta(r(i),(1+sqrt(-1)))>0
                r(i) = 0;
            else
                r(i) = 1;
            end
        end

        state_re = zeros(8,l_decode);    %���ڻ���״̬
        decode = zeros(1,l_decode);      %�����������Ϣ
        templ_1 = zeros(8,rate);   %��ǰ״̬����1֮������������2bit����ֵ,1~8�ֱ��Ӧ000~111
        templ_0 = zeros(8,rate);   %��ǰ״̬����0֮������������2bit����ֵ,1~8�ֱ��Ӧ000~111

        %����ά�رȵ�ת��ͼ
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


        state_prob = zeros(1,8);     %��¼ÿ��״̬��ǰ�ĸ���ֵ
        next_state_prob = zeros(1,8);  %��¼��һ��ÿ��״̬�ĸ���ֵ
        next_state_prob = next_state_prob - 10000;
        state_act = zeros(1,8); %��¼��ǰ״̬�Ƿ���·���ﵽ��1200�������ʶ���ﵽ������ֻ������������ã�
        state_act(1) = 1;       %��ʼ״̬Ϊ000
        next_state_act = zeros(1,8);
        next_state_act(1) = 1;
        for i = 1:rate:L           %ÿ��ȡrateλ�����α������յ���r
            for j = 1:8         %���״̬�������ֵ
                if mod(j-1,2)   %���״̬���һλΪ1��֤���������Ϊ1
                    %(j-2)/2+1��(j-2)/2+5���������Եõ���״̬����һ��״̬��Ҫ�Ƚ���һ�ָ������
                    if state_act((j-2)/2+1) && state_act((j-2)/2+5) %����״̬������·�����Դﵽ
                        comp = [state_prob((j-2)/2+1) + sum(r(i:i+rate-1)==templ_1((j-2)/2+1,:)'), ...
                        state_prob((j-2)/2+5) +  sum(r(i:i+rate-1)==templ_1((j-2)/2+5,:)')];
                        [next_state_prob(j),I] = max(comp);
                        if I == 1
                            state_re(j,(i+rate-1)/rate) = (j-2)/2+1;
                        else
                            state_re(j,(i+rate-1)/rate) = (j-2)/2+5;
                        end
                        next_state_act(j) = 1;
                    elseif state_act((j-2)/2+1)                    %ֻ�е�һ��״̬��·��
                        state_re(j,(i+rate-1)/rate) = (j-2)/2+1;
                        next_state_prob(j) = state_prob((j-2)/2+1) + sum(r(i:i+rate-1)==templ_1((j-2)/2+1,:)');
                        next_state_act(j) = 1;
                    elseif state_act((j-2)/2+5)                    %ֻ�еڶ���״̬��·��
                        state_re(j,(i+rate-1)/rate) = (j-2)/2+5;
                        next_state_prob(j) = state_prob((j-2)/2+5) + sum(r(i:i+rate-1)==templ_1((j-2)/2+5,:)');
                        next_state_act(j) = 1;
                    end

                else            %���״̬���һλ��Ϊ1��֤���������Ϊ0
                    %(j-1)/2+1��(j-1)/2+5���������Եõ���״̬����һ��״̬��Ҫ�Ƚ���һ�ָ������
                    if state_act((j-1)/2+1) && state_act((j-1)/2+5) %����״̬������·�����Դﵽ
                        comp = [state_prob((j-1)/2+1) + sum(r(i:i+rate-1)==templ_0((j-1)/2+1,:)'),...
                        state_prob((j-1)/2+5) +  sum(r(i:i+rate-1)==templ_0((j-1)/2+5,:)')];
                        [next_state_prob(j),I] = max(comp); 
                        if I == 1
                            state_re(j,(i+rate-1)/rate) = (j-1)/2+1;
                        else
                            state_re(j,(i+rate-1)/rate) = (j-1)/2+5;
                        end
                        next_state_act(j) = 1;
                    elseif state_act((j-1)/2+1)                    %ֻ�е�һ��״̬��·��
                        state_re(j,(i+rate-1)/rate) = (j-1)/2+1;
                        next_state_prob(j) = state_prob((j-1)/2+1) + sum(r(i:i+rate-1)==templ_0((j-1)/2+1,:)');
                        next_state_act(j) = 1;
                    elseif state_act((j-1)/2+5)                    %ֻ�еڶ���״̬��·��
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

