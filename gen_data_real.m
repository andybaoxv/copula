clear all, close all, clc;

addpath('./data/');
addpath('./equitability-code/');

flag_dataset = 10;
flag_normalization = true;
flag_randomsample = false;

if flag_dataset == 1
    load_casp;
elseif flag_dataset == 2
    load_cccp;
elseif flag_dataset == 3
    load_parkinson;
elseif flag_dataset == 4
    load_calhousing;
elseif flag_dataset == 5
    load_ailerons;
elseif flag_dataset == 6
    load_deltaailerons;
elseif flag_dataset == 7
    load_frieddelve;
elseif flag_dataset == 8
    load_kin8nm;
elseif flag_dataset == 9
    load_puma32H;
elseif flag_dataset == 10
    load_TomsHardware;
end

if flag_normalization
    data = normalization(data);
    label_true = normalization(label_true);
end
[n_instances,n_features] = size(data);

if flag_randomsample
    idx_sel = randsample(n_instances,1000);
    data = data(idx_sel,:);
    label_true = label_true(idx_sel,:);
end

val_mi = zeros(n_features,1);
val_ccor = zeros(n_features,1);

for j = 1:n_features
    disp(j);
    val_mi(j) = statistic_mi_kraskov(data(:,j),label_true,5);
    val_ccor(j) = ccore(data(:,j),label_true);
end

subplot(2,1,1),plot(val_mi),ylabel('MI');
subplot(2,1,2),plot(val_ccor),ylabel('Ccor');

figure(3)
scatter(data(:,3),label_true);
figure(4)
scatter(data(:,4),label_true);
