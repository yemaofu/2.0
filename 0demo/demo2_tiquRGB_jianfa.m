%����˳������ƴ�Ӻ��ͼƬ���Լ���ƴ�Ӻ��ͼƬ��ȡGֵ
clear all
clc

filepath = pwd;
path1 = '..\6ƴ�ӽ��_����\';
path2 = '..\7��ֵ���\����\��������\';
path3 = '..\6ƴ�ӽ��_����\�������ļ�\';

cd (path1);
files = dir('*.png');%��ȡͼƬ��Ϣ
len = length(files);%��ȡͼƬ����
row_num=940;%��ȡGֵ���к�
cd (filepath)
%---------------��˳�������ļ�------------------------------ps��������

for i = 1:len
    oldname = files(i).name;
    old_path = [path1, oldname]; % �ļ�·��
    im = imread(old_path);
    % �޸��ļ�����4λ��������ǰ���0
    new_path = sprintf('%s%04d.png', path3, i); % �����������ļ�·��
    imwrite(im, new_path);
end

% cd (path1)%ɾ������ͼƬ�ļ�����ʡ�洢�ռ䣬���������ļ���
% delete('*.png')
cd(filepath); %�������ڵĹ���Ŀ¼
%-------------------------------------------------------------

%----------------------------��ȡĳһ�е�Gֵ-----------------------

%��ȡ��������ͼƬ
I = cell(1, len);

for i = 1:len
    cd (filepath)
    cd(path3)

    imageName = strcat(num2str(i, '%04d'), '.png');
    I{i} = imread(imageName);

    s{i} = I{i}(row_num, :, 2);
    cd (filepath)
    cd(path2)
    dlmwrite('data_jianfa.csv', s(i), '-append', 'delimiter', ',');

end

cd(filepath)
