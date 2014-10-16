% This script generate synthetic dataset X1 X2 X3 X4 Y
%clear all, close all, clc;

% compute MI using KNN
addpath('./equitability-code/');
% efficiently compute matrix inverse using Cholesky decomposition
% addpath('./invChol/');
% number of runs
n_runs = 1;
% number of samples in each run
n_samples = 1000;
%eps = n_samples^(-1/4);
eps = 1e-3;
% MI values of n_runs
val_mi = zeros(n_runs,4);
% Ccor values of n_runs
val_ccor = zeros(n_runs,4);
% HSIC values of n_runs
val_hsic = zeros(n_runs,4);
% Normalized HSIC values of n_runs
val_hsnic = zeros(n_runs,4);
% Copula distance L2
val_cd2 = zeros(n_runs,4);

for idx_run = 1:n_runs
    % randomly generate X1 by uniformly drawing points between [0,1]
    X1 = rand(n_samples,1);
    
    % Y is the M function of X1
    %Y = M_function(X1);
    Y = X1;
    %Y=4.*(X1-0.5).^2;
    
    % X2 = X1 with p=0.8 and X4 = uniform noise otherwise
    X2 = zeros(n_samples,1);
    idx_sel=datasample([false true],n_samples,'Weight',[0.3 0.7]);
    X2(idx_sel) = X1(idx_sel);
    X2(~idx_sel) = rand(sum(~idx_sel),1);
    
    % Generate X3 through inverse M function
    %X3 = inv_M_function(Y - 0.65*(rand(n_samples,1)-0.5));
    X3 = Y - 0.65*(rand(n_samples,1)-0.5);
    
    % X4 = X1 with p=0.2 and X4 = uniform noise otherwise
    X4 = zeros(n_samples,1);
    idx_sel=datasample([false true],n_samples,'Weight',[0.7 0.3]);
    X4(idx_sel) = X1(idx_sel);
    X4(~idx_sel) = rand(sum(~idx_sel),1);
    
    % Compute MI and Ccor
    X = [X1,X2,X3,X4];
    %X=tiedrank(X);
    % compute kernel matrix for each feature
    options_Y.KernelType = 'Gaussian';
    options_Y.t = optSigma(Y);
    mtr_kernel_Y = constructKernel(Y,Y,options_Y);
    for j = 1:4
        %disp(j);
        %val_mi(idx_run,j) = statistic_mi_kraskov(X(:,j),Y,5);
        %val_ccor(idx_run,j) = ccore_tie(X(:,j),Y);
        options_X.KernelType = 'Gaussian';
        options_X.t = optSigma(X(:,j));
        mtr_kernel_X = constructKernel(X(:,j),X(:,j),options_X);
        val_hsnic(idx_run,j) = compute_HSNIC(mtr_kernel_X,mtr_kernel_Y,eps);
        val_hsic(idx_run,j) = compute_HSIC(mtr_kernel_X,mtr_kernel_Y);
        %val_cd2(idx_run,j) = copula_distance_L2(X(:,j),Y);
    end
    %disp(['run->' num2str(idx_run)]);
end

%disp(val_mi);
%disp(val_ccor);
disp(['n_samples-> ' num2str(n_samples)]);
disp(['Normalized HSIC-> ' num2str(val_hsnic)]);
disp(['HSIC-> ' num2str(val_hsic)]);
%disp(val_cd2);
%disp(['MI Mean: ' num2str(mean(val_mi))]);
%disp(['MI Std: ' num2str(std(val_mi))]);
%disp(['Ccor Mean: ' num2str(mean(val_ccor))]);
%disp(['Ccor Std: ' num2str(std(val_ccor))]);
%disp(['HSNIC Mean: ' num2str(mean(val_hsnic))]);
