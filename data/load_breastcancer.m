% Load Breast Cancer Dataset

% MATLAB version
% load cancer_dataset
% 
% data = cancerInputs';
% [n_instances,n_features] = size(data);
% % construct breastcancer label
% label_true = ones(n_instances,1)*999;
% for i = 1:n_instances
%     label_true(i) = find(cancerTargets(:,i) == 1);
% end


% http://www.cais.ntu.edu.sg/~chhoi/OMKC/
% addpath('./dataset/');
load breast
[n_instances,n_features] = size(data);
label_true = data(:,1);
tmp = (label_true == 1);
label_true(~tmp) = 0;
data = data(:,2:n_features);