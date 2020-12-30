clear all; clc;
filepath = pwd;
path1 = '..\7��ֵ���\����\';
path2 = '..\7��ֵ���\����\��������\';
path3 = '..\7��ֵ���\';

c_initial = 6; %��ʼŨ��g/L

cd(path2)
data_p = importdata('jf_final_p1.csv'); %��ȡλ��Ũ������
time = importdata('time.csv'); %��ȡȡ��ʱ������
cd(filepath)

data_p1 = data_p.';
[k, h] = size(data_p1);

% ft = fittype(@(a, b, c, x) a .* x.^b + c); %�Զ�����Ϸ�����ʽ

% ft = fittype(@(a, b, x) a .* x.^b + c_initial); %�Զ�����Ϸ�����ʽ
ft = fittype(@(a, b, x) a .* x.^b + c_initial);
% ft = fittype(@(a, b, x) a .* x^b + c);

%---------------------------����Ϸ���-------------------------------------

for i = 1:h / 2

    [x_l{i}, y_l{i}] = prepareCurveData(data_p1(:, 2 .* i - 1), data_p1(:, 2 .* i)); %ȥ��NANֵ

    [fit_r{i}, goodness_r{i}] = fit(x_l{i}, y_l{i}, ft, 'Start', [10, -1]); % ��ʽ���

    fit_r_l{i} = coeffvalues(fit_r{i}); %��ȡ����

end

%-------------------------------------------------------------------------

%--------------------------------���������--------------------------------

syms x
mi = 1:2:h;

for j = 1:h / 2;

    % fx(j) = fit_r_l{j}(1, 1) .* x.^fit_r_l{j}(1, 2) + fit_r_l{j}(1, 3); %��Ϻ������
    fx(j) = fit_r_l{j}(1, 1) .* x.^fit_r_l{j}(1, 2);

    mass_p(j) = int(fx(j), min(data_p(mi(j), :)), max(data_p(mi(j), :))); %������Ϻ�������

    front_site(j) = min(data_p(mi(j), :)); %����λ��

    max_front_concentration(j) = max(data_p(mi(j) + 1, :)); %������洦������Ũ��
end

%---------------------------------------------------------------------------

%%%%%%%%%%%%%%%%%%%%%%%%%%��������%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%| ʱ�� | ����ʱ�� |����λ�� | �ų����ʵ��� | ��ʼ���������ʵ��� | �����в��������ʵ��� | �����в���������ƽ��Ũ�� | ������洦������Ũ�� | ������ | ����ϵ�� |

Log10_time = double(log10(time)); %����ʱ��

front_site; %����λ��

mass = double(mass_p); %�ų����ʵ���

mass_intial_solid = double(front_site .* c_initial); %��ʼ���������ʵ���

mass_soild = double(mass_intial_solid - mass); %��������в��������ʵ���

concentration_soild_mean = double(mass_soild ./ front_site); %�����в���������ƽ��Ũ��g/L

front_concentration = double(max_front_concentration); %������洦������Ũ��

k_distribution = double(front_concentration ./ concentration_soild_mean); %����ϵ����Һ����洦Ũ�ȳ��Թ���ƽ��Ũ��

phi_purification = double(mass ./ mass_intial_solid); %���㾻���ʣ��ų����ʵ������ʼ���������ʵ����ı�ֵ

total_results_p = [time'; Log10_time'; front_site; mass; mass_intial_solid; mass_soild; concentration_soild_mean; front_concentration; phi_purification; k_distribution]; %�ܲ�����

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cd(path3)

rowname = {'ʱ��', '����λ��(mm)', '�ų����ʵ���', '��ʼ���������ʵ���', '�����в��������ʵ���', '�����в���������ƽ��Ũ��(g/L)', '������洦������Ũ��(g/L)', '������', '����ϵ��'};
total_results = total_results_p.';

xlswrite('jf_total(1.20_6_0.24(0.12)).xlsx', rowname, 'Sheet1', 'A1');
xlswrite('jf_total(1.20_6_0.24(0.12)).xlsx', total_results, 'Sheet1', 'A2');
cd(filepath)

% plot(fit_r9,x_l9,y_l9)%�������ͼ��
