clear all; clc
filepath = pwd;
path1 = '..\7数值结果\减法\';
path2 = '..\7数值结果\减法\减法参数\';

%-----------标线数据--------------
y1 = 14.872; %标线截距
x1 = 4.7318; %标线斜率
%--------------------------------

cd(path2)
data_jf = csvread('data_jianfa.csv');
jf_site = csvread('jf_site.csv');
rowname = importdata('rowname.csv');

% cd(filepath)

[k, h] = size(data_jf); %获取数据的行列数

for i = 1:k
    [jf_a{i}, jf_b{i}] = max(data_jf(i, jf_site(i, 1):jf_site(i, 2))); %找到峰值在部分数据中的位置jf_b
end

max_site = cell2mat(jf_b.') + jf_site(:, 1) - 1; %计算在完整数据中的位置

% cd(path1)

for j = 1:k
    newjf_data{j} = ((data_jf(j, max_site(j):jf_site(j, 3))) - y1) ./ x1; %利用拟合公式对像素值G进行浓度转化

    newcol{j} = [max_site(j):1:jf_site(j, 3)] .* 2 ./ 1000; %单个像素点代表2μm

    jf_final_cell{j} = [newcol{j}; newjf_data{j}]; %选取峰值处至末尾的数据，重组“距离”和“浓度”的数据组

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
