clear all; clc
filepath = pwd;
path1 = '..\7��ֵ���\����\';
path2 = '..\7��ֵ���\����\��������\';

%-----------��������--------------
y1 = 14.872; %���߽ؾ�
x1 = 4.7318; %����б��
%--------------------------------

cd(path2)
data_jf = csvread('data_jianfa.csv');
jf_site = csvread('jf_site.csv');
rowname = importdata('rowname.csv');

% cd(filepath)

[k, h] = size(data_jf); %��ȡ���ݵ�������

for i = 1:k
    [jf_a{i}, jf_b{i}] = max(data_jf(i, jf_site(i, 1):jf_site(i, 2))); %�ҵ���ֵ�ڲ��������е�λ��jf_b
end

max_site = cell2mat(jf_b.') + jf_site(:, 1) - 1; %���������������е�λ��

% cd(path1)

for j = 1:k
    newjf_data{j} = ((data_jf(j, max_site(j):jf_site(j, 3))) - y1) ./ x1; %������Ϲ�ʽ������ֵG����Ũ��ת��

    newcol{j} = [max_site(j):1:jf_site(j, 3)] .* 2 ./ 1000; %�������ص����2��m

    jf_final_cell{j} = [newcol{j}; newjf_data{j}]; %ѡȡ��ֵ����ĩβ�����ݣ����顰���롱�͡�Ũ�ȡ���������

    jf_final_p1 = cell2mat(jf_final_cell(j));
    dlmwrite('jf_final_p1.csv', jf_final_p1, '-append', 'delimiter', ',');
end

data_p1 = importdata('jf_final_p1.csv');

cd(filepath)
cd(path1)

data_p2 = data_p1.';

xlswrite('jf_final.xlsx', rowname', 'Sheet1', 'A1');
xlswrite('jf_final.xlsx', data_p2, 'Sheet1', 'A2');

cd(filepath)
