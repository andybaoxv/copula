% Load ionosphere dataset

% MATLAB version
% load ionosphere
% data = X;
% [n_instances,n_features] = size(data);
% 
% % transform label from char to double
% label_true = ones(n_instances,1)*999;
% for i = 1:n_instances
%     if strcmp(Y(i),'g')
%         label_true(i) = 1;
%     elseif strcmp(Y(i),'b')
%         label_true(i) = 0;
%     end
% end

%addpath('./dataset/');
load iono

[n_instances,n_features] = size(data);
label_true = data(:,1);
tmp = (label_true == 1);
label_true(~tmp) = 0;
data = data(:,2:n_features);