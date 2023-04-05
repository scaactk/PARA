%% User's inputs
clear all;
close all;
fclose all;
clc;
label = '40000crop'; % without .3dlp
input_folder = '/Users/Libin/Documents/LAB/DATA/STORM/hopkins'; % where .3dlp file is
output_folder = '/Users/Libin/Documents/LAB/DATA/STORM/hopkins'; % where files will be generated

power = 0.2;
threshold = 100; % distance greater than this will be treated as Inf
%minn = 4; % minimum number of points in a cluster used in pre-processing as well as after mcl algorithm
%minnth_neighbor_distance = 100;

rng('shuffle'); % Set random number generator seed

%% only for simulation
%{
xxxx1 = unifrnd(100,200,100,1);
xxxx2 = xxxx1 + 350;
xxxx3 = xxxx1 + 700;
yyyy1 = unifrnd(100,200,100,1);
yyyy2 = yyyy1 + 350;
yyyy3 = yyyy1 + 700;
x2 = vertcat(xxxx1,xxxx1,xxxx1,xxxx2,xxxx2,xxxx2,xxxx3,xxxx3,xxxx3);
y2 = vertcat(yyyy1,yyyy2,yyyy3,yyyy1,yyyy2,yyyy3,yyyy1,yyyy2,yyyy3);
m = horzcat(x2,y2);
%}

%% Crop
%
path_3dlp = fullfile(input_folder, [label,'.3dlp']);
input = load(path_3dlp);
xy_data = input(:,1:2);
x_min = min(xy_data(:,1))-1;
y_min = min(xy_data(:,2))-1;
x1 = round(xy_data(:,1) - x_min);
y1 = round(xy_data(:,2) - y_min);
scatter(x1,y1,10);
[x2,y2] = cutrec(x1,y1);
m = horzcat(x2,y2);
m = unique(m,'rows');
x = m(:,1);
y = m(:,2);
close all;
clear('x1','y1','x_min','y_min','xy_data','input','path_3dlp')
%

%% Pre-processing of the data
%{
disp('pre-processing ...');
[~, dist_neighbor] = knnsearch(m,m,'k',5);
idx_false = find(dist_neighbor(:,5) > minnth_neighbor_distance);
m(idx_false,:) = [];
x = m(:,1);
y = m(:,2);
clear('m','idx_false' ,'dist_neighbor')
disp(['done pre-processing, ',num2str(length(x2)-length(x)),' out of ',num2str(length(x2)),' points deleted']);
%}

%% Calculate pairwise distances and write into file
no_space_label = regexprep(label,' ','_');
d = zeros(length(x),length(x)-1); % no self loop
xyd = zeros(length(x),length(x)+1);
fidd = fopen(fullfile(output_folder,[no_space_label,'_mcl_dist.txt']),'w');
disp('calculating distances ...');
for i = 1:length(x)-1
    d(i+1:end,i) = ((x(i+1:end)-x(i)).^2 + (y(i+1:end)-y(i)).^2).^(0.5);
end
disp('done calculating distances');
disp('writing mcl_dist.txt ...');
fprintf(fidd,'#first two columns are coordinates of each point and the rest is a square matrix of distnaces\n');
xyd(:,1) = x;
xyd(:,2) = y;
xyd(:,3:end) = d;
d(d>threshold) = Inf;
fprintf(fidd,['%d %d ',repmat('%10.1f',1,length(x)-1),'\n'],xyd'); %first two columns are coordinates of each point
fclose(fidd);
disp('done writing mcl_dist.txt');

%% Make an input for MCL algorithm and write into file
D = zeros(length(x)*(length(x)-1)/2,3);
for i = 1:length(x)-1
    D((i-1)*length(x)-i*(i-1)/2+1:i*length(x)-i*(i+1)/2,1) = zeros(length(x)-i,1)+i-1;
    D((i-1)*length(x)-i*(i-1)/2+1:i*length(x)-i*(i+1)/2,2) = [i:length(x)-1]';
    %D((i-1)*length(x)-i*(i-1)/2+1:i*length(x)-i*(i+1)/2,3) = (d(i+1:end,i)./1000000).^(-1);
    D((i-1)*length(x)-i*(i-1)/2+1:i*length(x)-i*(i+1)/2,3) = exp(-(d(i+1:end,i)).^power + 1);
end
fid = fopen(fullfile(output_folder,[no_space_label,'_abc.txt']),'w');
disp('writing abc.txt ...');
fprintf(fid,'%d %d %f\n',D');
fclose(fid);
disp('done writing abc.txt');
clear('D','xyd','d')

