
clc
clear

demo1 = 'Index	First Frame	Number Frames	Frames Missing	Position X [nm]	Position Y [nm]	Precision [nm]	Number Photons	Background variance	Chi square	PSF width [nm]	Channel	Z Slice\n';
demo2 = '\nVoxelSizeX : 0.0970873786 祄\nVoxelSizeY : 0.0970873786 祄\nResolutionX : 0.1000000000\nResolutionY : 0.1000000000\nSizeX : 2560\nSizeY : 2560\nROI List : ';

input_address = 'C:\Users\tjut_\Desktop\Clus\convert\';%%example: C:\Users\ubc\Desktop\cluster analysis\AI2\code2D\Data_20190712\original_data\
list=dir(fullfile(input_address));


fileNum=size(list,1)-2;
for kk = 3:size(list,1)
    CalFileName = strcat(input_address, list(kk).name);
    position = load(CalFileName);
    cache = zeros(length(position),13);
    cache(:,5) = position(:, 1);
    cache(:,6) = position(:, 2);
    
    newStr = extractAfter(CalFileName, input_address);% factor
    newStr = extractBefore(newStr, ".3dlp");

    
    txtfname = strcat(newStr, '.txt');
    fid = fopen(txtfname,'wt');
    fprintf(fid,demo1);
    fprintf(fid,'%d %d %d %d %d %d %d %d %d %d %d %d %d\n',round(cache'));
    %fprintf(fid,'%t %t %t %t %t %t %t %t %t %t %t %t %t\n',round(cache'));
    fprintf(fid,demo2);
    fclose(fid);

%     clear cache
end
    