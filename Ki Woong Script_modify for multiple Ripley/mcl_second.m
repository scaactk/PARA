%% User's inputs
% label, input_folder and output_folder must be the same as in mcl_first.m
label = '40000crop'; % without .3dlp
input_folder = '/Users/Libin/Documents/LAB/DATA/STORM/hopkins'; % where .3dlp file is
output_folder = '/Users/Libin/Documents/LAB/DATA/STORM/hopkins'; % where files will be generated
inflation = 1.2; % inflation parameter
bin = 10; % number of bins for mcl histogram

num_del = 3; % exclude clusters with less than 3 number of points in order to draw polygons around

%% Write in terminal (for Mac)
no_space_output_folder = regexprep(output_folder,' ','\\ ');
setenv('PATH',[getenv('PATH') ':/usr/local/bin']);
system(['cd ',no_space_output_folder,'; mcl ',no_space_label,'_abc.txt --abc -I ',num2str(inflation),' -o ',no_space_label,'_mcl_I',num2str(inflation*10),'_abc_dump.txt']); % run mcl
pause(1);

%% Read output from MCL
FID = fopen(fullfile(output_folder,[no_space_label,'_mcl_I',num2str(inflation*10),'_abc_dump.txt']),'r');
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
out_cluster = out;
out_cluster(isnan(out_cluster(:,num_del)),:) = []; 
out_del = out(isnan(out(:,num_del)),:);
out_del = out_del(:,1:num_del-1);
out_del = reshape(out_del,[numel(out_del),1]);
out_del(isnan(out_del)) = [];

%% plot
num_cluster = size(out_cluster,1);
A = zeros(1,num_cluster);
Cx = zeros(num_cluster,1);
Cy = zeros(num_cluster,1);
figure(1) 
hold on;
for i = 1:num_cluster
    idx_cluster = out_cluster(i,:);
    idx_cluster(isnan(idx_cluster)) = [];
    xx = double(x(idx_cluster));
    yy = double(y(idx_cluster));
    [k,A(i)] = convhull(xx,yy,'simplify',true);
    color = rand(1,3);
    sumx = 0;
    sumy = 0;
    Cx(i) = sum(xx)/length(xx);
    Cy(i) = sum(yy)/length(xx);
    plot(xx(k),yy(k),'color',color)
    plot(xx,yy,'.',Cx(i),Cy(i),'*','color',color)
end
hold on
plot(double(x(out_del)),double(y(out_del)),'.','color',[.5 .5 .5])
title(['MCL for ',num2str(label),' with inflation = ',num2str(inflation)],'FontSize', 20,'interpreter','none')
hold off;
mclmean = ['\fontsize{13}','mean = ',num2str(mean(A))];
mclquant = ['\fontsize{13}','25%, 50%(median), 75% quantiles = ',num2str(quantile(A,[0.25,0.5,0.75]))];

figure(2)
[f,position] = hist(A,bin);
%bar(position,f);
plot(position,f)
text(0.01,0.95,mclquant,'Units', 'normalized')
text(0.01,0.9,mclmean,'Units', 'normalized')
title(['MCL line graph for ',num2str(label),' with inflation = ',num2str(inflation)],'FontSize', 20,'interpreter','none')
xlabel('approximate cluster area')
ylabel('number of clusters')
