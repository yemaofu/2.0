clear all; clc;
filepath = pwd;
path1 = '..\7数值结果\减法\';
path2 = '..\7数值结果\减法\减法参数\';
path3 = '..\7数值结果\';

c_initial = 6; %初始浓度g/L

cd(path2)
data_p = importdata('jf_final_p1.csv'); %读取位移浓度数据
time = importdata('time.csv'); %读取取样时间序列
cd(filepath)

data_p1 = data_p.';
[k, h] = size(data_p1);

% ft = fittype(@(a, b, c, x) a .* x.^b + c); %自定义拟合方程形式

% ft = fittype(@(a, b, x) a .* x.^b + c_initial); %自定义拟合方程形式
ft = fittype(@(a, b, x) a .* x.^b + c_initial);
% ft = fittype(@(a, b, x) a .* x^b + c);

%---------------------------求拟合方程-------------------------------------

for i = 1:h / 2

    [x_l{i}, y_l{i}] = prepareCurveData(data_p1(:, 2 .* i - 1), data_p1(:, 2 .* i)); %去除NAN值

    [fit_r{i}, goodness_r{i}] = fit(x_l{i}, y_l{i}, ft, 'Start', [10, -1]); % 公式拟合

    fit_r_l{i} = coeffvalues(fit_r{i}); %获取参数

end

%-------------------------------------------------------------------------

%--------------------------------积分求面积--------------------------------

syms x
mi = 1:2:h;

for j = 1:h / 2;

    % fx(j) = fit_r_l{j}(1, 1) .* x.^fit_r_l{j}(1, 2) + fit_r_l{j}(1, 3); %拟合函数表达
    fx(j) = fit_r_l{j}(1, 1) .* x.^fit_r_l{j}(1, 2);

    mass_p(j) = int(fx(j), min(data_p(mi(j), :)), max(data_p(mi(j), :))); %计算拟合函数积分

    front_site(j) = min(data_p(mi(j), :)); %锋面位置

    max_front_concentration(j) = max(data_p(mi(j) + 1, :)); %冻结锋面处的溶质浓度
end

%---------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%参数计算%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%| 时间 | 对数时间 |锋面位置 | 排出溶质的量 | 初始固相中溶质的量 | 固相中残留的溶质的量 | 固相中残留的溶质平均浓度 | 冻结锋面处的溶质浓度 | 净化率 | 分配系数 |

Log10_time = double(log10(time)); %对数时间

front_site; %锋面位置

mass = double(mass_p); %排出溶质的量

mass_intial_solid = double(front_site .* c_initial); %初始固相中溶质的量

mass_soild = double(mass_intial_solid - mass); %计算固相中残留的溶质的量

concentration_soild_mean = double(mass_soild ./ front_site); %固相中残留的溶质平均浓度g/L

front_concentration = double(max_front_concentration); %冻结锋面处的溶质浓度

k_distribution = double(front_concentration ./ concentration_soild_mean); %分配系数：液相锋面处浓度除以固相平均浓度

phi_purification = double(mass ./ mass_intial_solid); %计算净化率：排出溶质的量与初始固相中溶质的量的比值

total_results_p = [time'; Log10_time'; front_site; mass; mass_intial_solid; mass_soild; concentration_soild_mean; front_concentration; phi_purification; k_distribution]; %总参数表

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(path3)

rowname = {'时间', '锋面位置(mm)', '排出溶质的量', '初始固相中溶质的量', '固相中残留的溶质的量', '固相中残留的溶质平均浓度(g/L)', '冻结锋面处的溶质浓度(g/L)', '净化率', '分配系数'};
total_results = total_results_p.';

xlswrite('jf_total(1.20_6_0.24(0.12)).xlsx', rowname, 'Sheet1', 'A1');
xlswrite('jf_total(1.20_6_0.24(0.12)).xlsx', total_results, 'Sheet1', 'A2');
cd(filepath)

% plot(fit_r9,x_l9,y_l9)%绘制拟合图像
