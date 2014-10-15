% Load Madelon dataset

%addpath('./dataset/');
load madelon_train_data
load madelon_train_label

data = data_madelontrain;
label_true = label_madelontrain;
tmp = (label_true == 1);
label_true(~tmp) = 0;