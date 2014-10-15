% Load wine dataset

load wine_dataset
data = wineInputs';
[n_instances,n_features] = size(data);
% construct wine label
label_true = ones(n_instances,1)*999;
for i = 1:n_instances
    label_true(i) = find(wineTargets(:,i) == 1);
end

class_1 = (label_true == 1);
class_2 = (label_true == 2);

class_use = class_1 | class_2;

data = data(class_use,:);
label_true = label_true(class_use,:);
tmp = (label_true == 1);
label_true(~tmp) = 0;