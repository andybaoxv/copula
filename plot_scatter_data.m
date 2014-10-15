clear all, close all, clc;

addpath('./data/');

load_building

flag_normalization = true;
if flag_normalization
    data = normalization(data);
    label_true = normalization(label_true);
end

[n_instances,n_features] = size(data);

for j = 1:n_features
    figure(j)
    a = scatter(data(:,j),label_true);
    xlabel([num2str(j) '-th Feature']);
    ylabel('Y: Response Variable');
    saveas(a, ['./' num2str(j) '.png'],'png');
end

