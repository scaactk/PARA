%%Rip_hop_modification: allow multiple inputs and export mean, 25%, 50%,
%%75% quantile as .csv file
%% User's inputs
clear al2
clc

%select multiple 3dlp for cropping
[listOfDlp, listOfDlpPath] = uigetfile('G:\.3dlp', 'Select a 3dlp file for cropping', 'MultiSelect', 'on');
if ~iscell(listOfDlp)
    listOfDlp = cellstr(listOfDlp);
end
testptH = 5; % number of test points for each repeat for Hopkins
repeatH = 1000; % more repeats, the better
maxr = 250; % maximum radius for Ripley (the x-axis ranges from 0 to maxr)
numr = 50; % total # points per curve for Ripley
repeatR = 10;
testptR = 500; % number of test points for each repeat for Ripley
listOfxy4Hop= {}; %cell array containing the[x,y] of each .3dlp
listOfx1y14Rip = {};



%% Going through the list of DLP and ask User to crop all of .3dlp, and stored [x,y] of each .3dlp
% in listOfxy4Hop cell array.
sizeOfLOD = max(size(listOfDlp));
for j = 1:sizeOfLOD
    disp(strcat('Reading file', listOfDlp{j}));
    %%reading .3dlp
    path_3dlp = fullfile(listOfDlpPath, listOfDlp{j});
    input = importdata(path_3dlp);
    xy_data = input(:,1:2);
    x_min = min(xy_data(:,1))-1;
    y_min = min(xy_data(:,2))-1;
    x0 = round(xy_data(:,1) - x_min);
    y0 = round(xy_data(:,2) - y_min);
    
    %% Crop
    f1 = figure;
    m = horzcat(x0,y0);
    m1 = unique(m,'rows');
    x1 = m1(:,1);
    y1 = m1(:,2);
    scatter(x1,y1,10);
    title(['scatterplot for ',listOfDlp{j},' original'],'FontSize',20,'interpreter','none')
    %path_out = fullfile(output_folder,[label,'_scatterplot']);
    %saveas(f1,path_out,'tif');
    while true
        disp(['When you crop, keep in mind that you need at least ',num2str(testptR),' data points for Ripley.']);
        [x,y] = cutrec_2(x1,y1); % Crop a desired rectangle
        if length(x) >= testptR,break,end
        disp(['You only chose ',num2str(length(x)),' points.'])
    end
    xy4Hop = [x,y];
    listOfxy4Hop{j} = xy4Hop;
    listOfx1y14Rip{j} = [x1,y1];
end

% Ripley's
%for j = 1:sizeOfLOD
%x = listOfxy4Hop{j}(:,1);
%y = listOfxy4Hop{j}(:,2);
%x1 = listOfx1y14Rip{j}(:,1);
%y1 = listOfx1y14Rip{j}(:,2);

%b = zeros(repeatR,numr);
%k = linspace(0,maxr,numr);
%a = Ripknoedge_2(x,y,min(x),max(x),min(y),max(y),testptR,repeatR,maxr,numr,x1,y1);
%disp('Finished calculating Ripley');
%for i = 1:numr
 %   b(:,i) = (a(:,i)./pi).^(0.5) - (i-1)*maxr/numr;
%end
%f3 = figure;
%plot(k,b','b-',k,0*k,'r-',k,mean(b),'g-')
%title(['Ripley H for ',listOfDlp{j}(1:end-5),' with ',num2str(testptR),' testpoints, ',num2str(repeatR),' repeats'],'FontSize', 12,'interpreter','none')
%disp('Finished plotting the graph!');
%path_out_jpeg = fullfile(listOfDlpPath,strcat(listOfDlp{j}(1:end-5),'.jpg'));
%path_out_fig = fullfile(listOfDlpPath,strcat(listOfDlp{j}(1:end-5),'.fig'));
%saveas(f3,path_out_jpeg,'jpeg');
%savefig(path_out_fig);
%fprintf(strcat('Finished saving ',listOfDlp{j}(1:end-5),' as .mat and .jpeg\n'));
%end
