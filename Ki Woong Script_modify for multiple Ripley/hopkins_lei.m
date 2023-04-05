clear all
close all
clc

A=load('Alexa647_20161111_5_W.3dlp');
B=[A(:,1),A(:,2),A(:,3)];
clear A

testptH = 5; % number of test points for each repeat for Hopkins
repeatH = 1000; % more repeats, the better
maxr = 250; % maximum radius for Ripley (the x-axis ranges from 0 to maxr)
numr = 50; % total # points per curve for Ripley
repeatR = 10;
testptR = 100; % number of test points for each repeat for Ripley
listOfDlpPath = 'C:\Users\user\Desktop\Nature_Comm_3dlp';
HP='test';%file name

yminn= 1*10;
ymaxn= 2000*10;   
xminn= 1*10; 
xmaxn= 2000*10;   

j=1;%figurecut
for i=1:1:length(B(:,1))
   if B(i,1)>xminn && B(i,1)<xmaxn && B(i,2)>yminn && B(i,2)<ymaxn
       for k=1:1:3
           D(j,k)=B(i,k);
       end
           j=j+1;
   end
end  
clear i j

listOfxy4Hop=[D(:,1),D(:,2)];
sizeOfxyHop = max(size(listOfxy4Hop));
for i = 1: sizeOfxyHop
    % Hopkins
    bin = 100;
    H = Hop_2(listOfxy4Hop(:,1),listOfxy4Hop(:,2),min(listOfxy4Hop(:,1)),max(listOfxy4Hop(:,1)),min(listOfxy4Hop(:,2)),max(listOfxy4Hop(:,2)),testptH,repeatH);
    disp('Finished calculating Hopkins');
    Hmean = ['\fontsize{13}','mean = ',num2str(mean(H))];
    Hquant = ['\fontsize{13}','25%, 50%(median), 75% quantiles = ',num2str(quantile(H,[0.25,0.5,0.75]))];
    f2 = figure;
    [f,t] = hist(H,linspace(0,1,bin));
    bar(t,f*bin/repeatH);
    xlim([0,1])
    text(0.01,0.95,Hquant,'Units', 'normalized')
    text(0.01,0.9,Hmean,'Units', 'normalized')
    title(['Hopkins with ',num2str(testptH),' test points, ',num2str(repeatH),' repeats'],'FontSize', 20,'interpreter','none')
    
    %%print Hopkins output to csv as mean, 25%, 50%, 75%  %MOD by tim
    summary_stat = [mean(H), quantile(H,[0.25,0.5,0.75])];
    %filename = strcat(label(1:end-5),'.csv');
    %filename = strcat (listOfDlp{i}(1:end-8),'hop.csv');
    content = strcat('num2str(summary_stat(1)),',',num2str(summary_stat(2)),',',num2str(summary_stat(3)),',', num2str(summary_stat(4))');
    dlmwrite(fullfile(listOfDlpPath,'Hop_file.csv'),content,'delimiter','','-append');

    path_out_jpeg = fullfile(listOfDlpPath,strcat(HP,'.jpg'));
    path_out_fig = fullfile(listOfDlpPath,strcat(HP,'.fig'));
    saveas(f2,path_out_jpeg,'jpeg');
    saveas(f2,path_out_fig,'fig');
end