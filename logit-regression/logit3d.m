% ��ʼ��������ȫ�ֱ���
old_error = 0;
n = 0; %��������
B = [0;0;0;1]; %������������Ϊ׼
% ������������
x = xlsread('../data/watermelon3a3d.xlsx', 'Sheet1', 'B2:R5');
y = xlsread('../data/watermelon3a3d.xlsx', 'Sheet1', 'B6:R6');
[t, m] = size(y);
% ��������
for i = 1:m
    if y(i) == 1
        plot3(x(1,i), x(2, i), x(3, i), '+r');
	    hold on;
    elseif y(i) == 0
        plot3(x(1,i), x(2, i), x(3, i), 'og');
        hold on;
    end
end
xlabel('�ܶ�');
ylabel('���');
zlabel('������');
title('�߼��ع�');

% ѭ������
while(1)
    bx = zeros(17, 1);
    cur_error = 0;
    % ѭ���������ݼ������
    for i=1:m
        bx(i) = B.' * x(:,i);
        cur_error = cur_error + (-y(i) * bx(i) + log(1 + exp(bx(i))));
    end
    % �Ƚ������������Ƿ���������
    if abs(old_error - cur_error) < 0.0001
        break;
    end 
    % ���²�����ţ�ٷ����ݶ��½�����
    n = n + 1;
    old_error = cur_error;
    db1 = 0;  %loss���̶�B��1�׵���
    db2 = 0;  %loss���̶�B��2�׵���
    
    for i = 1:m
        p1 = 1 - 1 / (1 + exp(bx(i))); % 1 - p0
        db1 = db1 - x(:,i) * (y(i) - p1);
        db2 = db2 + x(:,i) * x(:,i).' * p1 * (1 - p1);
    end
    
    B = B - pinv(db2) * db1; %pinv �Բ����������α��
% ��������
end
syms a  b;
z = -(B(1)*a+B(2)*b+B(4))/B(3);
fmesh(z, [0.1 0.9 0.1 0.9]);

% output B
% ����������������ͼ��