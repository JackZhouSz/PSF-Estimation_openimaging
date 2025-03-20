% test_sfrmat5
% Peter Burns, 27 Feb 2023
dir_path = 'E:\Code\Optical_aberration_estimation1\dataset\54854_rgb\crop\shot0_read0';
save_path = 'E:\Code\Optical_aberration_estimation1\dataset\54854_rgb\mat\shot0_read0';
% dir_path = 'E:\Code\Optical_aberration_estimation1\dataset\54854_rgb\crop\shot0_read0';
% save_path = 'E:\Code\Optical_aberration_estimation1\dataset\54854_rgb\mat\shot0_read0';

if exist(save_path, 'dir') == 0
    % ����ļ��в����ڣ��򴴽����ļ���
    mkdir(folderPath);
end
% ��ȡ�ļ����е������ļ�
fileList = dir(fullfile(dir_path, '*.tif'));

io = 1;
del = 1;
npol = 5;
wflag = 0;
% ѭ����ȡÿ���ļ�
for i = 1:numel(fileList)
    filename = fileList(i).name;
    filepath = fullfile(dir_path, filename);
    pattern = 'fov(-?\d+\.\d+)_angle(-?\d+\.\d+)';
    tokens = regexp(filename, pattern, 'tokens', 'once');

    % ��ȡ������
    fov = str2double(tokens{1});
    rot = str2double(tokens{2});
    
    
    % ��ȡtifͼ��
    image = imread(filepath);
      
     [status, sfr, e, sfr50, fitme, esf, nbin, del2] = sfrmat5(io, del, image, npol);
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
            save(saveFile, 'fov','rot','sfr');
        end
    else
        filename
    end

end

