% 初始化参数和全局变量
old_error = 0;
n = 0; %迭代次数
B = [0;0;1]; %参数，列向量为准
% 加载样本数据
x = xlsread('../data/watermelon3a2d.xlsx', 'Sheet1', 'B2:R4');
y = xlsread('../data/watermelon3a2d.xlsx', 'Sheet1', 'B5:R5');
[t, m] = size(y);
% 画出数据
for i = 1:m
    if y(i) == 1
        plot(x(1,i), x(2, i), '+r');
	    hold on;
    elseif y(i) == 0
        plot(x(1,i), x(2, i), 'og');
        hold on;
    end
end
xlabel('密度');
ylabel('含糖率');
title('二维逻辑回归');

% 循环迭代
while(1)
    bx = zeros(17, 1);
    cur_error = 0;
    % 循环样本数据计算误差
    for i=1:m
        bx(i) = B.' * x(:,i);
        cur_error = cur_error + (-y(i) * bx(i) + log(1 + exp(bx(i))));
    end
    % 比较两次误差，决定是否跳出迭代
    if abs(old_error - cur_error) < 0.0001
        break;
    end 
    % 更新参数（牛顿法或梯度下降法）
    n = n + 1;
    old_error = cur_error;
    db1 = 0;
    db2 = 0;
    
    for i = 1:m
        p1 = 1 - 1 / (1 + exp(bx(i))); % 1 - p0
        db1 = db1 - x(:,i) * (y(i) - p1);
        db2 = db2 + x(:,i) * x(:,i).' * p1 * (1 - p1);
    end
    
    if B(2) ~= 0
        syms x1;
        x2 = -(B(1)*x1 + B(3))/B(2);
        fplot(x2, [0.1 0.9]);
        pause(1);
        hold on;
    end

    B = B - pinv(db2) * db1;
% 迭代结束
end
% 输出迭代结果，画出图像
% output B