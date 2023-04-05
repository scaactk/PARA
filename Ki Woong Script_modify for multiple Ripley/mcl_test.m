%% User's inputs
clear all;
close all;
fclose all;
clc;
label = 'FO crop a'; %without .3dlp
input_folder = '/Users/Libin/Documents/LAB/DATA/STORM/Box/20150410/FO crop'; % where .3dlp file is
output_folder = '/Users/Libin/Documents/LAB/DATA/STORM/Box/20150410/FO crop'; % where files will be generated
inflation = 1.3; % inflation parameter
minn = 3; % minimum number of points in a cluster

%% Crop
path_3dlp = fullfile(input_folder, [label,'.3dlp']);
input = load(path_3dlp);
xy_data = input(:,1:2);
x_min = min(xy_data(:,1))-1;
y_min = min(xy_data(:,2))-1;
x0 = round(xy_data(:,1) - x_min);
y0 = round(xy_data(:,2) - y_min);
m = horzcat(x0,y0);
m1 = unique(m,'rows');
x1 = m1(:,1);
y1 = m1(:,2);
scatter(x1,y1,10);
[x,y] = cutrec(x1,y1);
close all;
clear('x1','y1')

%% Calculate pairwise distances and write into file
d = zeros(length(x),length(x));
D = zeros(length(x),2*length(x));
xyd = zeros(length(x),length(x)+2);
fidd = fopen(fullfile(output_folder,[label,'_mcl_dist.txt']),'w');
disp('calculating distances ...');
for i = 1:length(x)
    d(i:end,i) = ((x(i:end)-x(i)).^2 + (y(i:end)-y(i)).^2).^(0.5);
    d(i,i:end) = d(i:end,i);
    D(:,2*i-1) = zeros(length(x),1) + i-1;
end
disp('done calculating distances');
disp('writing mcl_dist.txt ...');
fprintf(fidd,'#first two columns are coordinates of each point and the rest is a square matrix of distnaces\n');
xyd(:,1) = x;
xyd(:,2) = y;
xyd(:,3:end) = d;
fprintf(fidd,['%d %d ',repmat('%10.1f',1,length(x)),'\n'],xyd'); %first two columns are coordinates of each point
fclose(fidd);
disp('done writing mcl_dist.txt');

%% Make an input for MCL algorithm and write into file
no_space_label = regexprep(label,' ','_');
iD = zeros(length(x),2*length(x)+1);
for i = 1:length(x)
    D(:,2*i) = (d(:,i)).^(-1); % -1 power
end
D(D == Inf) = 0;
fid = fopen(fullfile(output_folder,[no_space_label,'_mcl.mci']),'w');
fprintf(fid,['(mclheader\nmcltype matrix\ndimensions ',num2str(length(x)),'x',num2str(length(x)),'\n)\n(mclmatrix\nbegin\n']);
disp('writing mcl.mci ...');
iD(:,1) = [0:length(x)-1]';
iD(:,2:end) = D;
fprintf(fid,['%d ', repmat('%d:%d ',1,length(x)),'$','\n'],iD');
fprintf(fid,'%s',')');
fclose(fid);
disp('done writing mcl.mci');

%% Write in terminal (for Mac)
pause(1);
no_space_output_folder = regexprep(output_folder,' ','\\ ');
setenv('PATH',[getenv('PATH') ':/usr/local/bin']);
system(['cd ',no_space_output_folder,'; mcl ',no_space_label,'_mcl.mci -I ',num2str(inflation),' -o ',no_space_label,'_mcl_I',num2str(inflation*10),'.txt; mcxdump -icl ',no_space_label,'_mcl_I',num2str(inflation*10),'.txt -o ',no_space_label,'_mcl_I',num2str(inflation*10),'_dump.txt']); % run mcl
pause(1);

%% Read output from MCL
FID = fopen(fullfile(output_folder,[no_space_label,'_mcl_I',num2str(inflation*10),'_dump.txt']),'r');
c = textscan(FID,'%s','delimiter', '','whitespace','');
fclose(FID);
C = c{1};
C = cellfun(@(x) textscan(x,'%s','Delimiter', '\t'),C ,'UniformOutput',false);
Y = vertcat(C{:}); 
X = cellfun(@transpose,Y,'UniformOutput',false);
Z = cellfun(@str2double,X,'UniformOutput',false);
ZZ = cell(length(X),1);
for i = 1:length(X)
    ZZ{i} = Z{i} + ones(size(Z{i})); % add 1 to all elements
end
maxL = max(cellfun(@(x)numel(x),ZZ));
out = cell2mat(cellfun(@(x)cat(2,x,zeros(1,maxL-length(x))),ZZ,'UniformOutput',false));
out(out == 0) = NaN; % convert all 0 to nan
out(isnan(out(:,minn)),:) = []; % exclude clusters with less than minn number of points

%% plot
figure(1) 
hold on;
for i = 1:size(out,1)
    ind = out(i,:);
    ind(isnan(ind)) = [];
    xx = x(ind);
    yy = y(ind);
    [k,A] = convhull(xx,yy);
    plot(xx(k),yy(k),'-',xx,yy,'.')
    %scatter(xx,yy,10)
end
hold off;

