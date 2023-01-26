path = "C:\Users\tjut_\Desktop\PARA\Clus\20220911\test\DBSCAN Results\Ch1\";
raw_file = load(strcat(path,'DBSCAN_Cluster_Result.mat'));
inner1 = raw_file.ClusterSmoothTable; % cell
inner2 = inner1{1,1}; % arrary

% build new array
ClusterID = [];
Number = [];
Area = [];
Circularity = [];



for i = 1:length(inner2) % traverse array
    temp = inner2(i);
    temp = temp{1,1};
    ClusterID(i) = temp.ClusterID;
    Number(i) = temp.Nb;
    Area(i) = temp.Area;
    Circularity(i) = temp.Circularity;
    TotalAreaDensity(i) = temp.TotalAreaDensity;
    Density_Nb_A(i) = temp.Density_Nb_A;

    Density = temp.Density;
    Density_list_to_str(i) = convertCharsToStrings(num2str(reshape(Density, 1, [])));
    RelativeDensity = temp.RelativeDensity;
    RelativeDensity_list_str(i) = convertCharsToStrings(num2str(reshape(RelativeDensity, 1, [])));

    Mean_Density(i) = temp.Mean_Density;
    AvRelativeDensity(i) = temp.AvRelativeDensity;

end


VariableNames = ["ClusterID", "Number", "Area", "Circularity", "TotalAreaDensity", "Density_Nb_A", "Density", "RelativeDensity", "Mean_Density", "AvRelativeDensity"];
total_table = table(ClusterID', Number', Area', Circularity', TotalAreaDensity', Density_Nb_A', Density_list_to_str', RelativeDensity_list_str', Mean_Density', AvRelativeDensity', VariableNames=VariableNames);


writetable(total_table, strcat(path, 'result_ch1.csv'), Delimiter=',')
