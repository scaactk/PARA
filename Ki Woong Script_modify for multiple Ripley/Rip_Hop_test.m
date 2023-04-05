%% User's inputs
clear al2
clc
label = 'IgD_FO_5.9'; % Write the input file without '.3dlp'
input_folder = 'G:\Colocalization\20160114\FO\Cropped_IgD';
testptH = 5; % number of test points for each repeat for Hopkins
repeatH = 1000; % more repeats, the better
maxr = 250; % maximum radius for Ripley (the x-axis ranges from 0 to maxr)
numr = 50; % total # points per curve for Ripley 
repeatR = 10;
testptR = 500; % number of test points for each repeat for Ripley

%% Reading .3dlp
path_3dlp = fullfile(input_folder, [label,'.3dlp']);
input = load(path_3dlp);
xy_data = input(:,1:2);
x_min = min(xy_data(:,1))-1;
y_min = min(xy_data(:,2))-1;
x0 = round(xy_data(:,1) - x_min);
y0 = round(xy_data(:,2) - y_min);

% %% Crop
% f1 = figure;
% m = horzcat(x0,y0);
% m1 = unique(m,'rows');
% x1 = m1(:,1);
% y1 = m1(:,2);
% scatter(x1,y1,10);
% title(['scatterplot for ',label,' original'],'FontSize',20,'interpreter','none')
% %path_out = fullfile(output_folder,[label,'_scatterplot']);
% %saveas(f1,path_out,'tif');
% while true
%     disp(['When you crop, keep in mind that you need at least ',num2str(testptR),' data points for Ripley.']);
%     [x,y] = cutrec_2(x1,y1); % Crop a desired rectangle
%     if length(x) >= testptR,break,end
%     disp(['You only chose ',num2str(length(x)),' points.'])
% end
% 
% % Hopkins
% bin = 100;
% H = Hop_2(x,y,min(x),max(x),min(y),max(y),testptH,repeatH);
% disp('Finished calculating Hopkins');
% Hmean = ['\fontsize{13}','mean = ',num2str(mean(H))];
% Hquant = ['\fontsize{13}','25%, 50%(median), 75% quantiles = ',num2str(quantile(H,[0.25,0.5,0.75]))];
% f2 = figure;
% [f,t] = hist(H,linspace(0,1,bin));
% bar(t,f*bin/repeatH);
% xlim([0,1])
% text(0.01,0.95,Hquant,'Units', 'normalized')
% text(0.01,0.9,Hmean,'Units', 'normalized')
% title(['Hopkins for ',label,' with ',num2str(testptH),' test points, ',num2str(repeatH),' repeats'],'FontSize', 20,'interpreter','none')

% % Ripley's
b = zeros(repeatR,numr);
k = linspace(0,maxr,numr);
a = Ripknoedge_2(x,y,min(x),max(x),min(y),max(y),testptR,repeatR,maxr,numr,x1,y1);
disp('Finished calculating Ripley');
for i = 1:numr
    b(:,i) = (a(:,i)./pi).^(0.5) - (i-1)*maxr/numr;
end
f3 = figure;
plot(k,b','b-',k,0*k,'r-',k,mean(b),'g-')
title(['Ripley H for ',label,' with ',num2str(testptR),' testpoints, ',num2str(repeatR),' repeats'],'FontSize', 20,'interpreter','none')
disp('Finished!');
