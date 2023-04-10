%%Rip_hop_modification: allow multiple inputs and export mean, 25%, 50%,
%%75% quantile as .csv file
%% User's inputs
clear

%% do not support multi-input now -2023/04/09
%select multiple 3dlp for cropping
[listOfDlp, listOfDlpPath] = uigetfile('F:\QW\20230131QW\3\Red.3dlp', 'Select a 3dlp file for cropping', 'MultiSelect', 'on');
resultPath = fullfile(listOfDlpPath, "result");
if ~exist(resultPath, 'dir')
    mkdir(resultPath);
end

if ~iscell(listOfDlp)
    listOfDlp = cellstr(listOfDlp); % convert str list to cell array
end
testptH = 5; % number of test points for each repeat for Hopkins
repeatH = 1000; % more repeats, the better
maxr = 250; % maximum radius for Ripley (the x-axis ranges from 0 to maxr)
numr = 50; % total # points per curve for Ripley
repeatR = 10;
testptR = 100; % number of test points for each repeat for Ripley
listOfxy4Hop= {}; %cell array containing the[x,y] of each .3dlp
listOfx1y14Rip = {};

%% Going through the list of DLP and ask User to crop all of .3dlp, and stored [x,y] of each .3dlp
% in listOfxy4Hop cell array.
sizeOfLOD = max(size(listOfDlp));
for i = 1:sizeOfLOD
    disp(strcat('Reading file :', listOfDlp{i}));
    %%reading .3dlp
    path_3dlp = fullfile(listOfDlpPath, listOfDlp{i});
    input = importdata(path_3dlp); % import as an array
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
    scatter(x1,y1,10, ".")
    title(['scatterplot for ',listOfDlp{i},' original'],'FontSize',10,'interpreter','none')

    % Prompt the user to enter a number
    answer = inputdlg('Enter a number for how many ROIs do you need:');

    % Convert the user's input to a number
    number = str2double(answer{1});

    % Check if the user entered a valid number
    if isnan(number)
        error('Invalid input: not a number');
    end

    % Use the number in your code
    disp(['The number you entered is ' num2str(number)]);

    j = 0;
    while j<number
        disp(['When you crop, keep in mind that you need at least ',num2str(testptR),' data points for Ripley.']);
        [x,y] = cutrec_2(x1,y1); % Crop a desired rectangle
        if length(x) >= testptR
            j = j+1
            disp(["You have choose ", j, "valid ROI, totally needs ", number])
            xy4Hop = [x,y];
            listOfxy4Hop{j} = xy4Hop;
            listOfx1y14Rip{j} = [x1,y1];
        else
            disp(['You only chose ',num2str(length(x)),' points.'])
        end
    end
end

%% Go through the listOfxy4Hop (containing [x,y] of each 3dlp), and do Hopkins' analysis,
% and the value of Mean, 25%, 50%, 75% quantiles are stored in ...._hop.csv
sizeOfxyHop = max(size(listOfxy4Hop));
for i = 1: sizeOfxyHop
    % Hopkins
    bin = 100;
    H = Hop_2(listOfxy4Hop{i}(:,1),listOfxy4Hop{i}(:,2),min(listOfxy4Hop{i}(:,1)),max(listOfxy4Hop{i}(:,1)),min(listOfxy4Hop{i}(:,2)),max(listOfxy4Hop{i}(:,2)),testptH,repeatH);
    disp('Finished calculating Hopkins');
    Hmean = ['\fontsize{13}','mean = ',num2str(mean(H))];
    Hquant = ['\fontsize{13}','25%, 50%(median), 75% quantiles = ',num2str(quantile(H,[0.25,0.5,0.75]))];
    f2 = figure;
    [f,t] = hist(H,linspace(0,1,bin));
    bar(t,f*bin/repeatH);
    xlim([0,1])
    text(0.01,0.95,Hquant,'Units', 'normalized')
    text(0.01,0.9,Hmean,'Units', 'normalized')
    title(['Hopkins for ',listOfDlp{1},' with ',num2str(testptH),' test points, ',num2str(repeatH),' repeats'],'FontSize', 10,'interpreter','none')

    %%print Hopkins output to csv as mean, 25%, 50%, 75%  %MOD by tim
    summary_stat = [mean(H), quantile(H,[0.25,0.5,0.75])];
    %filename = strcat(label(1:end-5),'.csv');
    %filename = strcat (listOfDlp{i}(1:end-8),'hop.csv');
    content = strcat(listOfDlp{1}(1:end-5),',',num2str(summary_stat(1)),',',num2str(summary_stat(2)),',',num2str(summary_stat(3)),',', num2str(summary_stat(4)));
    dlmwrite(fullfile(resultPath, strcat('Hop_file_', num2str(i), '.csv')),content,'delimiter','','-append');

    path_out_jpeg = fullfile(resultPath, strcat(listOfDlp{1}(1:end-5), "_Hopkins_", num2str(i), '.jpg'));
    path_out_fig = fullfile(resultPath, strcat(listOfDlp{1}(1:end-5), "_Hopkins_", num2str(i), '.fig'));
    saveas(f2,path_out_jpeg,'jpeg');
    saveas(f2,path_out_fig,'fig');
    close(f2)
end

% Ripley's
for j = 1:number
    x = listOfxy4Hop{j}(:,1);
    y = listOfxy4Hop{j}(:,2);
    x1 = listOfx1y14Rip{j}(:,1);
    y1 = listOfx1y14Rip{j}(:,2);

    b = zeros(repeatR,numr);
    k = linspace(0,maxr,numr);
    a = Ripknoedge_2(x,y,min(x),max(x),min(y),max(y),testptR,repeatR,maxr,numr,x1,y1);
    disp(['Finished calculating Ripley', num2str(j)]);
    for i = 1:numr
        b(:,i) = (a(:,i)./pi).^(0.5) - (i-1)*maxr/numr;
    end
    f3 = figure;
    plot(k,b','b-',k,0*k,'r-',k,mean(b),'g-')
    title(['Ripley H for ',listOfDlp{1}(1:end-5),' with ',num2str(testptR),' testpoints, ',num2str(repeatR),' repeats'],'FontSize', 10,'interpreter','none')
    disp(['Finished plotting the graph!', num2str(j)]);
    path_out_jpeg = fullfile(resultPath,strcat(listOfDlp{1}(1:end-5), "_Ripley_", num2str(j), '.jpg'));
    path_out_fig = fullfile(resultPath,strcat(listOfDlp{1}(1:end-5), "_Ripley_", num2str(j), '.fig'));
    saveas(f3,path_out_jpeg,'jpeg');
    saveas(f3,path_out_fig,'fig');
    disp('END');
    close(f3)
end
close(f1)