% 重命名"原始图片"中的图片文件，使其顺序命名；利用减法和除法对"顺序命名"文件夹中的图片进行去除背景处理；
clear, clc

filepath = pwd;
cd ('..\2原始图片');
files = dir('*.png');
path1 = '..\2原始图片\'; % 文件所在文件夹路径
path2 = '..\3顺序命名\'; % 文件重命名后存放的文件夹路径
path3 = '..\4减法去背景值\';
len = length(files);

%---------------------重新顺序命名文件------------------------------
for i = 1:len
    oldname = files(i).name;
    old_path = [path1, oldname]; % 文件路径
    im = imread(old_path);
    % 修改文件名，4位数，不足前面加0
    new_path = sprintf('%s%04d.png', path2, i); % 重命名后新文件路径
    imwrite(im, new_path);
end

cd(filepath); %返回现在的工作目录
%------------------------------------------------------------

%---------------------背景操作--------------------------------

cd('..'); %返回根目录，读取背景图片
Image_bg = imread('bg.png'); %定义背景值
Image_bg = im2double(Image_bg);
cd(filepath)

cd(path2);

I = cell(1, len);

for i = 1:len
    imageName = strcat(num2str(i, '%04d'), '.png');
    I{i} = imread(imageName);
    A = im2double(I{i});

    %----------用图像减法完成去背景操作---------

    s = Image_bg - A;
    imwrite(s, [path3, num2str(i, '%04d'), '.png']);
    %--------------------------------------------
end

cd(filepath); %返回现在的工作目录,也就是本代码放置的文件夹
%------------------------------------------------------------
