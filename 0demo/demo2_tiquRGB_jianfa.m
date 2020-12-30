%重新顺序命名拼接后的图片，对减法拼接后的图片提取G值
clear all
clc

filepath = pwd;
path1 = '..\6拼接结果_减法\';
path2 = '..\7数值结果\减法\减法参数\';
path3 = '..\6拼接结果_减法\重命名文件\';

cd (path1);
files = dir('*.png');%读取图片信息
len = length(files);%读取图片数量
row_num=940;%提取G值的行号
cd (filepath)
%---------------重顺序命名文件------------------------------ps批量处理

for i = 1:len
    oldname = files(i).name;
    old_path = [path1, oldname]; % 文件路径
    im = imread(old_path);
    % 修改文件名，4位数，不足前面加0
    new_path = sprintf('%s%04d.png', path3, i); % 重命名后新文件路径
    imwrite(im, new_path);
end

% cd (path1)%删除所有图片文件，节省存储空间，不包括子文件夹
% delete('*.png')
cd(filepath); %返回现在的工作目录
%-------------------------------------------------------------

%----------------------------提取某一行的G值-----------------------

%读取规律命名图片
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
