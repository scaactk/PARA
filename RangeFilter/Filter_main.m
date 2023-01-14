FWT_raw  = xlsread("Dataset\NIV-F-WT.xlsx");

% modify the input file path & name here
Input_raw_list = [
    "Dataset\NIV-F-L53D.xlsx",...
    "Dataset\NIV-F-L53D2.xlsx",...
    "Dataset\NIV-F-L53D3.xlsx"
]

% ouput path
output_path = "D:\GithubRepository\PARA\RangeFilter\Output";

for i=1:length(Input_raw_list)
    Input_raw_path = Input_raw_list{i};
    Input_raw = xlsread(Input_raw_path);
    [filepath,name,ext] = fileparts(Input_raw_path);

    % % remove NAN column
    % FWT_raw(: , 6) = [ ]
    % Input_raw(:, 6) = [ ]
    
    % remove NAN Row
    FWT = FWT_raw(~all(isnan(FWT_raw), 2) , :);
    Input = Input_raw(~all(isnan(Input_raw), 2), :);
    
    FWT_mean = mean(FWT(:, 16), 1);
    FWT_var = var(FWT(:,16), 0, 1);
    
    
    disp(length(Input))
    % if you want to change the range of threshold, just change the coefficient of FWT_var
    % such as FWT_var * 1.0 >> FWT_var * 1.2
    after_filter = filter_by_std_mean(FWT_mean, FWT_var * 1.0, Input);
    disp(length(after_filter))
    
    title = {'Cell', 'ROI', 'x bottom corner', 'y bottom corner', 'Size of ROI (nm)', 	'Comments',...
    'Percentage of molecules in clusters',	'Average number of molecules per cluster', ...
    'Average cluster area (nm^2)', 'Abslute density in clusters (molecules / um^2)', ...
    'Relative density in clusters', 'Total number of molecules in ROI', 'Circularity', ...
    'Number of clusters in ROI',	'Density of clusters (clusters / um^2)', 'TAD'
    };
    T = array2table(after_filter);
    T.Properties.VariableNames(1:16) = title;
    str = [string(name) + '_after_filter.csv'];  % in matlab it do not have the function in connect char with string
    final_out_path = fullfile(output_path, str);
    writetable(T, final_out_path);

    %% plot
    figure(1)
    h1 = histfit(FWT(:, 16), 20);
    hold on
    h2 = histfit(Input(:, 16), 20);
    hold off
    
    figure(2)
    h3 = histogram(after_filter(:, 16), 20);

end


%% below are function define

function after_filter = filter_by_std_mean ( ...
    std_mean, ...
    threshold, ...
    data)
    
    % create empty matrix for storage data after filtering
    after_filter = [];
    
    i = 1;
    for row = 1:length(data)
        dis = (data(row, 16) - std_mean)^2;
        if (dis <= threshold)
            after_filter(i, :) = data(row, :);
            i = i+1;
        end
    end
    % after_filter
end


