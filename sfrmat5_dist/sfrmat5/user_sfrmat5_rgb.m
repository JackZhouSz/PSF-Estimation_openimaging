% test_sfrmat5
% Peter Burns, 27 Feb 2023
clear;
clc;
% dir_path = 'G:\Code\oae\dataset\ES600D\crop';
% dir_path = 'G:\datasets\cap\ES600D\crop_raw';
% save_path = 'G:\Code\oae\dataset\ES600D\mat_raw';
dir_path = '..\..\dataset\63762BB\crop\shot0.00';
save_path = '..\..\dataset\63762BB\mat\shot0.00';

if exist(save_path, 'dir') == 0
    % ����ļ��в����ڣ��򴴽����ļ���
    mkdir(save_path);
end
% ��ȡ�ļ����е������ļ�
fileList = dir(fullfile(dir_path, '*.tif'));

io = 1;
del = 1;
npol = 5;
wflag = 0;
% ѭ����ȡÿ���ļ�
for i = 1:numel(fileList)
    filename = fileList(i).name
    filepath = fullfile(dir_path, filename);
    pattern = 'fov(-?\d+\.\d+)_angle(-?\d+\.\d+)';
    tokens = regexp(filename, pattern, 'tokens', 'once');

    % ��ȡ������
    fov = str2double(tokens{1});
    rot = str2double(tokens{2});
    
    
    % ��ȡtifͼ��
    image = imread(filepath);
      
     [status, sfr, e, sfr50, fitme, esf, nbin, del2] = sfrmat5(io, del, image, npol);
     
     meanx = zeros(1,3);
     
     s_esf = esf(30:192-30,:);
     A = size(s_esf);
     nor_esf = zeros(A(1),A(2));     
     len = A(1);
     for idx = 1:3
         maxV = max(s_esf(:,idx));
         minV = min(s_esf(:,idx));
         nor_esf(:,idx) = (s_esf(:,idx)-ones(len,1)*minV)/((maxV-minV));
     end
%      offset1 = zeros(1,2);
%      offset1(1,1) = (sum(nor_esf(:,1))- sum(nor_esf(:,2)))/4;
%      offset1(1,2) = (sum(nor_esf(:,3))- sum(nor_esf(:,2)))/4;
     
     
%      for j = 1:3
%         indices = find(s_esf(:,j) >= 50 & s_esf(:,j) <= 190);
%         meanx(1,j) = mean(indices);
%      end
     
     for j = 1:3
        indices = find(nor_esf(:,j) >= 0.2 & nor_esf(:,j) <= 0.9);
        meanx(1,j) = mean(indices);
     end
     
     offset = zeros(1,2);     
     offset(1,1) = (sum(nor_esf(:,1))-sum(nor_esf(:,2)))/4;
     offset(1,2) = (sum(nor_esf(:,3))-sum(nor_esf(:,2)))/4;
     
     
    % ��������Զ�ͼ����н�һ������
    if max(max(sfr(:,2)))==1 && ~any(isnan(sfr(:,2)))
        % ׼��Ҫ���������

        % ָ�������ļ���·�����ļ���
        savefilename = strrep(filename, '.tif', '.mat');
        saveFile = fullfile(save_path,savefilename);

        if isnan(sum(sum(sfr)))
            disp('�����д��� NaN ֵ���޷�ִ���������䡣');
        else
            % ��������Ϊ.mat�ļ�
            save(saveFile, 'fov','rot','sfr','offset');
            
%             if max(offset) >1 
% 
%                 plot(nor_esf(:,1),'r');
%                 hold on;
%                 plot(nor_esf(:,2),'g');
%                 hold on;
%                 plot(nor_esf(:,3),'b');
%                 hold off;
%                 1
%             end              
                 
        end
    else
    end

end

