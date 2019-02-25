% 初始化参数和全局变量
old_error = 0;
n = 0; %迭代次数
B = [0;0;0;1]; %参数，列向量为准
% 加载样本数据
x = xlsread('../data/watermelon3a3d.xlsx', 'Sheet1', 'B2:R5');
y = xlsread('../data/watermelon3a3d.xlsx', 'Sheet1', 'B6:R6');
[t, m] = size(y);
% 画出数据
for i = 1:m
    if y(i) == 1
        plot3(x(1,i), x(2, i), x(3, i), '+r');
	    hold on;
    elseif y(i) == 0
        plot3(x(1,i), x(2, i), x(3, i), 'og');
        hold on;
    end
end
xlabel('密度');
ylabel('随便');
zlabel('含糖率');
title('逻辑回归');

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
    db1 = 0;  %loss方程对B求1阶倒数
    db2 = 0;  %loss方程对B求2阶倒数
    
    for i = 1:m
        p1 = 1 - 1 / (1 + exp(bx(i))); % 1 - p0
        db1 = db1 - x(:,i) * (y(i) - p1);
        db2 = db2 + x(:,i) * x(:,i).' * p1 * (1 - p1);
    end
    
    B = B - pinv(db2) * db1; %pinv 对不可逆矩阵求伪逆
% 迭代结束
end
syms a  b;
z = -(B(1)*a+B(2)*b+B(4))/B(3);
fmesh(z, [0.1 0.9 0.1 0.9]);

% output B
% 输出迭代结果，画出图像