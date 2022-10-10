%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%硬判决译码
r = v';
%首先判决r
for i = 1:L
    if cal_theta(r(i),(1+sqrt(-1)))>0
        r(i)=0;
    else
        r(i) =-1;
    end
end

state_re = zeros(8,L/2);    %用于回溯状态
decode = zeros(1,L/2);      %最后解码出的信息
templ_1 = zeros(8,2);   %当前状态输入1之后编码器输出的2bit编码值,1~8分别对应000~111
templ_0 = zeros(8,2);   %当前状态输入0之后编码器输出的2bit编码值,1~8分别对应000~111

%生成维特比的转换图
for i = 1:8
    cur_state = zeros(1,3);
    cur_state(3) = mod(i-1,2);
    cur_state(2) = mod((i-1-cur_state(3))/2,2);
    cur_state(1) = mod(((i-1-cur_state(3))/2-cur_state(2))/2,2);
    templ_1(i,1) = mod([1,0,1,1]*[cur_state,1]',2);
    templ_1(i,2) = mod([1,1,1,1]*[cur_state,1]',2);
    templ_0(i,1) = mod([1,0,1,1]*[cur_state,0]',2);
    templ_0(i,2) = mod([1,1,1,1]*[cur_state,0]',2);
end
templ_1 = 2.*templ_1 - 1;
templ_0 = 2.*templ_0 - 1;


state_prob = zeros(1,8);     %记录每个状态当前的概率值
next_state_prob = zeros(1,8);  %记录下一拍每个状态的概率值
next_state_prob = next_state_prob - 10000;
state_act = zeros(1,8); %记录当前状态是否有路径达到（1200个点大概率都会达到，所以只在最初几步有用）
state_act(1) = 1;       %起始状态为000
next_state_act = zeros(1,8);
next_state_sct(1) = 1;
for i = 1:2:L           %每次取两位，依次遍历接收到的r
    for j = 1:8         %逐个状态计算最大值
        if mod(j-1,2)   %如果状态最后一位为1，证明这次输入为1
            %(j-2)/2+1和(j-2)/2+5是两个可以得到该状态的上一拍状态，要比较哪一种概率最大
            if state_act((j-2)/2+1) && state_act((j-2)/2+5) %两种状态都已有路径可以达到
                comp = [state_prob((j-2)/2+1) + sum(r(i:i+1)*templ_1((j-2)/2+1)'), ...
                state_prob((j-2)/2+5) +  sum(r(i:i+1)*templ_1((j-2)/2+5)')];
                [next_state_prob(j),I] = max(comp);
                if I == 1
                    state_re(j,(i+1)/2) = (j-2)/2+1;
                else
                    state_re(j,(i+1)/2) = (j-2)/2+5;
                end
                next_state_act(j) = 1;
            elseif state_act((j-2)/2+1)                    %只有第一种状态有路径
                state_re(j,(i+1)/2) = (j-2)/2+1;
                next_state_prob(j) = state_prob((j-2)/2+1) + sum(r(i:i+1)*templ_1((j-2)/2+1)');
                next_state_act(j) = 1;
            elseif state_act((j-2)/2+5)                    %只有第二种状态有路径
                state_re(j,(i+1)/2) = (j-2)/2+5;
                next_state_prob(j) = state_prob((j-2)/2+5) + sum(r(i:i+1)*templ_1((j-2)/2+5)');
                next_state_act(j) = 1;
            end
                
        else            %如果状态最后一位不为1，证明这次输入为0
            %(j-1)/2+1和(j-1)/2+5是两个可以得到该状态的上一拍状态，要比较哪一种概率最大
            if state_act((j-1)/2+1) && state_act((j-1)/2+5) %两种状态都已有路径可以达到
                comp = [state_prob((j-1)/2+1) + sum(r(i:i+1)*templ_0((j-1)/2+1)'),...
                state_prob((j-1)/2+5) +  sum(r(i:i+1)*templ_0((j-1)/2+5)')];
                [next_state_prob(j),I] = max(comp); 
                if I == 1
                    state_re(j,(i+1)/2) = (j-1)/2+1;
                else
                    state_re(j,(i+1)/2) = (j-1)/2+5;
                end
                next_state_act(j) = 1;
            elseif state_act((j-1)/2+1)                    %只有第一种状态有路径
                state_re(j,(i+1)/2) = (j-1)/2+1;
                next_state_prob(j) = state_prob((j-1)/2+1) + sum(r(i:i+1)*templ_0((j-1)/2+1)');
                next_state_act(j) = 1;
            elseif state_act((j-1)/2+5)                    %只有第二种状态有路径
                state_re(j,(i+1)/2) = (j-1)/2+5;
                next_state_prob(j) = state_prob((j-1)/2+5) + sum(r(i:i+1)*templ_0((j-1)/2+5)');
                next_state_act(j) = 1;
            end
        end
    end
    state_prob = next_state_prob;
    state_act = next_state_act;
end

[~,I] = max(state_prob);
decode(L/2) = mod(I-1,2);
for i = L/2:-1:1
    decode(i) = mod(state_re(I,i)-1,2);
    I = state_re(I,i);
end