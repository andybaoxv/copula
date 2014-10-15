% This script implements MRMR feature selection

% clear all, close all, clc;

% code of computing mutual information
addpath('./mi/');
% dataset folder
addpath('./data/');
%% Prepare data
% Choose which dataet to use
flag_data = 0;
% Choose whether to normalize data
flag_normalization = 1;
% Choose task: 'classification' or 'regression'
flag_task = 'classification';
% Choose dependency metric: 1->copula; 2->mutual information, 3-> binary
% copula L1(Y is binary)
flag_metric = 3;

% select dataset
if flag_data == 0
    load data_missing
    data = data_missing;
elseif flag_data == 1
    % Size: 351 x 34, for binary classification
    load_ionosphere;
elseif flag_data == 2
    % Size: 130 x 13, for binary classification
    load_wine;
elseif flag_data == 3
    % Size: 683 x 9, for binary classification
    % https://archive.ics.uci.edu/ml/datasets/Breast+Cancer+Wisconsin+(Original)
    load_breastcancer
elseif flag_data == 4
    % Size: 569 x 30, for binary classification
    % https://archive.ics.uci.edu/ml/datasets/Breast+Cancer+Wisconsin+(Diagnostic)
    load_wdbc
elseif flag_data == 5
    % Size: 2000 x 500, for binary classification
    load_madelon
elseif flag_data == 6
    % Size: 1000 x 60, for binary classification
    load_splice
elseif flag_data == 7
    % Size; 1000 x 24, for binary classification
    load_german
elseif flag_data == 8
    % Size: 208 x 60, for binary classification
    load_sonar
elseif flag_data == 9
    % Size: 690 x 14, for binary classification
    load_australian
elseif flag_data == 10
    % Size: 1243 x 22, for binary classification
    load_svmguide3
elseif flag_data == 11
    % Size: 506 x 13, for regression
    load_housing
elseif flag_data == 12
    % Size: 4177 x 8, for regression
    load_abalone
elseif flag_data == 13
    % Size: 252 x 13, for regression
    load_bodyfat
elseif flag_data == 14
    % Size: 498 x 8, for regression
    load_chemical
elseif flag_data == 15
    % Size: 264 x 21, for regression
    load_cho
elseif flag_data == 16
    % Size: 4208 x 14, for regression
    load_building
else
    disp('Error: flag_data');
end

% normalization of the selected dataset
if flag_normalization
    data = normalization(data);
    if strcmp(flag_task,'regression')
        label_true = normalization(label_true);
    end
end

% obtain size of the selected dataset
[n_instances,n_features] = size(data);

% Display Parameter Settings
if flag_metric == 1
    disp(['Task->' flag_task '  Metric->' 'Copula L1']);
elseif flag_metric == 2
    disp(['Task->' flag_task '  Metric->' 'Mutual Information']);
elseif flag_metric == 3
    disp(['Task->' flag_task '  Metric->' 'Binary Copula L1']);
else
    disp('error')
end

%% Feature Selection based on MRMR(Minimize Redundancy Maximize Relevance)
% Redundancy: compute pairwise dependency between features
% Here we assume all the features are continuous variables
sim_fea = zeros(n_features,n_features);
for i = 1:n_features
    % disp(['sim_fea_iter->',num2str(i)])
    feat_i = data(:,i)';
    % indices of existing values for feature i
    idx_feat_i = ~(feat_i==-999);
    for j = i:n_features   
        feat_j = data(:,j)';
        % indices of existing values for feature j
        idx_feat_j = ~(feat_j==-999);
        % compute overlap of indices between feat_i and feat_j
        idx_feat_ij = idx_feat_i & idx_feat_j;
        feat_i_use = feat_i(idx_feat_ij);
        feat_j_use = feat_j(idx_feat_ij);
        if flag_metric == 1 | flag_metric == 3
            sim_fea(i,j) = ccore(feat_i_use,feat_j_use);
        elseif flag_metric == 2
            sim_fea(i,j) = mutualinfo(feat_i_use',feat_j_use');
        else
            disp(['flag_metric']);
        end
        sim_fea(j,i) = sim_fea(i,j);
    end
end
% Relevance: compute dependency between features and the ground truth
% Here if the task is regression, label_true is a continuous variable.
% While if the task is classification, label_true is a binary variable.
rel_fea = zeros(1,n_features);
for i = 1:n_features
    feat_i = data(:,i)';
    % indices of existing values for feature i
    idx_feat_i = ~(feat_i==-999);
    % indices of existing values for label_true
    idx_label_true = ~(label_true'==-999);
    idx_feat_i_label = idx_feat_i & idx_label_true;
    feat_i_use = feat_i(idx_feat_i_label);
    label_true_use = label_true(idx_feat_i_label)';
    % disp(['rel_fea_iter->',num2str(i)])
    if flag_metric == 1
        rel_fea(i) = ccore(feat_i_use,label_true_use);
    elseif flag_metric == 2
        rel_fea(i) = mutualinfo(feat_i_use',label_true_use');
    elseif flag_metric == 3
        rel_fea(i) = ccor01(feat_i_use,label_true_use);
    else
        disp(['flag_metric']);
    end
end

% Find the most relevant feature and add it to the feature set
idx = find(rel_fea == max(rel_fea));
feature_sel = [idx(1)];

% S store the score values
S = [];
% Iteratively add features based on relevance and redundancy
while length(feature_sel) < n_features
    % score of each feature
    score = ones(1,n_features)*(-1)*inf;
    for i = 1:n_features
        % Feature i is not in the selected list, compute score
        if sum(find(i == feature_sel)) == 0
            tmp = [feature_sel,i];
            n_feature_sel = length(tmp);
            score(i) = sum(rel_fea(tmp))/n_feature_sel - ...
                1./(n_feature_sel^2)*sum(sum(sim_fea(tmp,tmp)));
        end
    end
    idx = find(score == max(score));
    feature_sel = [feature_sel,idx];
    S = [S,score(idx)];
end

% Find the number of top features giving highest score
idx_max = find(S == max(S))+1;

% Choose the top ranking features according to score
feature_sel_top = feature_sel(1:idx_max);

%% Evaluation by SVM
fold = 10;
data_sel = data(:,feature_sel_top);
% Choose the top 5 features for subsequent task in order to achieve fair
% comparison
data_use = data_sel(:,1:5);
% indices = crossvalind('Kfold', n_instances, fold);
% the number of SVM runs to overcome randomness
n_run = 100;
% error rate for SVM classification
error_rate = zeros(1,n_run);
% RMSE for regression
rmse = zeros(1,n_run);

% Classification
if strcmp(flag_task,'classification')
    for i = 1:n_run
        %test = (indices == i);
        %train = ~test;
        % choose 90% as training set
        tmp = randi([1,n_instances],1,round(n_instances*0.9));
        train = false(n_instances,1);
        train(tmp) = true;
        % choose the remaining 10% as testing set
        test = ~train;
        sigma = optSigma(data_use(train,:));
        svmStruct = svmtrain(data_use(train,:),label_true(train,:),...
            'boxconstraint',100,'kernel_function','rbf','rbf_sigma',sigma);
        label_pred = svmclassify(svmStruct,data_use(test,:));
        error_rate(i) = 1 - sum(label_pred == label_true(test,:))/length(label_pred);
    end
% Regression
elseif strcmp(flag_task,'regression')
    for i = 1:n_run
        %test = (indices == i);
        %train = ~test;
        tmp = randi([1,n_instances],1,round(n_instances*0.9));
        train = false(n_instances,1);
        train(tmp) = true;
        % choose the remaining 10% as testing set
        test = ~train;
        mdl = fitlm(data_use(train,:),label_true(train),'linear');
        ypred = predict(mdl,data_use(test,:));
        [tmp_1,tmp_2] = rsquare(label_true(test),ypred,false);
        error_rate(i) = 1-tmp_1;
        rmse(i) = tmp_2;
    end
else
    disp(['Error: flag_task']);
end

disp(['error_rate: ' 'mean->' num2str(mean(error_rate)) ' std->' num2str(std(error_rate))]);
disp(['RMSE: ' 'mean->' num2str(mean(rmse)) ' std->' num2str(std(rmse))]);
