clear all, close all, clc;
% This script generate a synthetic dataset X1,X2,X3,X4,Y
addpath('./equitability-code/');

% number of samples
n_samples = 5000;

% randomly generate n_samples points between [0,1]
X1 = rand(n_samples,1);

% generate Y according to M function
Y = M_function(X1);

% X2 = X1 with p=0.7 and X2 = uniform noise with p=0.3
X2 = zeros(n_samples,1);
idx_sel = false(n_samples,1);
tmp = randsample(n_samples,floor(0.7*n_samples));
idx_sel(tmp) = true;
X2(idx_sel) = X1(idx_sel);
X2(~idx_sel) = rand(sum(~idx_sel),1);

% X4 = X1 with p=0.3 and X4 = uniform noise with p=0.7
X4 = zeros(n_samples,1);
idx_sel = false(n_samples,1);
tmp = randsample(n_samples,floor(0.3*n_samples));
idx_sel(tmp) = true;
X4(idx_sel) = X1(idx_sel);
X4(~idx_sel) = rand(sum(~idx_sel),1);

% X3 = X1 - (3-sqrt(3))/2 uniform 
X3 = Y - (3-sqrt(3))/2 * rand(n_samples,1);

% Compute MI and Ccor
val_mi = zeros(4,1);
val_ccor = zeros(4,1);
val_pearson = zeros(4,1);
X = [X1,X2,X3,X4];
for i = 1:4
    val_mi(i,1) = statistic_mi_kraskov(X(:,i),Y,1);
    val_ccor(i,1) = ccore_tie(X(:,i),Y);
    val_pearson(i,1) = corr(X(:,i),Y);
end

disp(val_ccor');
disp(val_mi');
% disp(val_pearson');

% disp(tiedrank(val_ccor'));
% disp(tiedrank(val_mi'));

% % scatter plot
% figure(1)
% scatter(X1,Y);
% figure(2)
% scatter(X2,Y);
% figure(3)
% scatter(X3,Y);
% figure(4);
% scatter(X4,Y);
