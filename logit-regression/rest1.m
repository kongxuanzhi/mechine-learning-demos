% 初始化参数和全局变量
old_error = 0;
Iter = 0; %迭代次数

% 加载样本数据
% 1-2组
% x = csvread('../data/irisdata.csv', 0, 0,[0 0 99 4]);
% y = csvread('../data/irisdata.csv', 0, 5,[0 5 99 5]);
% 2-3组
x = csvread('../data/irisdata.csv', 50, 0,[50 0 149 4]);
y = csvread('../data/irisdata.csv', 50, 5,[50 5 149 5]);
y = y - 1;
% 1-3组
% x0 = csvread('../data/irisdata.csv', 0, 0,[0 0 49 4]);
% y0 = csvread('../data/irisdata.csv', 0, 5,[0 5 49 5]);
% x1 = csvread('../data/irisdata.csv', 100, 0,[100 0 149 4]);
% y1 = csvread('../data/irisdata.csv', 100, 5,[100 5 149 5]);
% y = y / 2;
% x = [x0;x1];
% y = [y0;y1];

[m, n] = size(y);
% 10次10折交叉验证
for k=1:m
    % 循环迭代
    err0 = 0;
    B = [0;0;0;0;1]; %参数，列向量为准
    while(1)
        bx = zeros(m, 1);
        cur_error = 0;
        add_error = zeros(m, 1);
        % 循环样本数据计算误差
        for i=1:m
            %跳过用于验证的样本
            if i == k
                continue;
            end
%           x(i,:)

            bx(i) = x(i,:) * B;
            tlog = bx(i);
            if abs(bx(i)) < 30
                tlog = log(1 + exp(bx(i)));
            end

            add_error(i) = 1/(1 + exp(bx(i)));
            cur_error = cur_error + (-y(i) * bx(i) + tlog);
        end
        % 比较两次误差，决定是否跳出迭代
        if abs(old_error - cur_error) < 0.0001
            break;
        end 
        % 更新参数（牛顿法或梯度下降法）
        Iter = Iter + 1;
        old_error = cur_error;
        db1 = 0;
        db2 = 0;

        for i = 1:m
            if i == k
                continue;
            end
            
            p1 = 1 - 1 / (1 + exp(bx(i))); % 1 - p0
            db1 = db1 - x(i,:) * (y(i) - p1);
            db2 = db2 + x(i,:).' * x(i,:) * p1 * (1 - p1);
        end
        B = B - (pinv(db2) * db1.');
    % 迭代结束
    end
    
    %用验证集验证准确度

    y1 = -x(k,:) * B;
    tmp = 1/(1+exp(y1));
    tmp = (tmp>=0.5);
    err0 = err0 + (tmp ~= y(k));
    disp(err0);
end
disp(err0);
pause(1);

    
% 输出迭代结果，画出图像
% output B