% Load australian dataset

%addpath('./dataset/');
load australian

[n_instances,n_features] = size(data);
label_true = data(:,1);
tmp = (label_true == 1);
label_true(~tmp) = 0;
data = data(:,2:n_features);