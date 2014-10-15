% This function rewrite main_fs.m as a function
function [feature_sel,error_rate,rmse] = func_feature_selection(flag_data,...
    flag_missing,feat_list,percent_missing,flag_normalization,flag_task,flag_metric)

% Parameters
% ----------
% flag_data: int
%            choose which dataset to use
% flag_missing: boolean
%            whether to create dataset with missing values from the
%            original dataset
% feat_list: vector
%            indices of features to create missing values
% percent_missing: float
%            the percentage of missing values
% flag_normalization: boolean
%            whether to normalize the dataset
% flag_task: string
%            depend on dataset: 'classification' or 'regression'
% flag_metric: int
%            choose metric to use for feature selection, 1 -> copula L1
%            2 -> Mutual Information, 3 -> Binary copula L1

% Returns
% -------
% feature_sel: vector
%              indices of selected features
% error_rate: vector
%               error rates of SVM classification in multiple runs, only
%               valide when flag_task == 'classification'
% rmse: vector
%               RMSE of regression in multiple runs, onl valide when
%               flag_taks == 'regression'

% select dataset
if flag_data == 1
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
elseif flag_data == 17
    % Size: 1000 x 11, for regression
    load_M_function
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

% keep a copy of dataset without missing values
data_c = data;

if flag_missing
   % generate indices of samples containing missing values, we assume the
    % high-ranking features will have the same set of indices of missing
    tmp = randi([1,n_instances],1,round(n_instances*percent_missing));
    idx_instance_sel = false(n_instances,1);
    idx_instance_sel(tmp) = true;
    % create dataset with missing values, we replace missing values with -999
    data(idx_instance_sel,feat_list) = -999;
end

% % Display Parameter Settings
% if flag_metric == 1
%     disp(['Task->' flag_task '  Metric->' 'Copula L1']);
% elseif flag_metric == 2
%     disp(['Task->' flag_task '  Metric->' 'Mutual Information']);
% elseif flag_metric == 3
%     disp(['Task->' flag_task '  Metric->' 'Binary Copula L1']);
% else
%     disp('error')
% end

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
            sim_fea(i,j) = ccore_tie(feat_i_use,feat_j_use,100);
        elseif flag_metric == 2
            sim_fea(i,j) = statistic_mi_kraskov(feat_i_use',feat_j_use',5);
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
        rel_fea(i) = ccore_tie(feat_i_use,label_true_use,100);
    elseif flag_metric == 2
        rel_fea(i) = statistic_mi_kraskov(feat_i_use',label_true_use',5);
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
% use complete dataset for evaluation
data_sel = data_c(:,feature_sel);
% Choose the top 5 features for subsequent task in order to achieve fair
% comparison
if strcmp(flag_task,'classification')
    data_use = data_sel(:,1:5);
else
    data_use = data_sel(:,1);
end
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
        train = true(n_instances,1);
        train(tmp) = false;
        % choose the remaining 10% as testing set
        test = ~train;
        
        % Linear Regression
        %mdl = fitlm(data_use(train,:),label_true(train),'linear');
        %ypred = predict(mdl,data_use(test,:));
        %[tmp_1,tmp_2] = rsquare(label_true(test),ypred,false);
        %error_rate(i) = 1-tmp_1;
        %rmse(i) = tmp_2;
        
        % Kernel Regression
        tmp_y = label_true(train,:);
        tmp_x = data_use(train,:);
        tmp_n = sum(train);
        [tmp_x_sort,tmp_idx] = sort(tmp_x);
        tmp_y_sort = tmp_y(tmp_idx);
        tmp_h = 0.25*tmp_n^(-1/4);
        r = ksr(tmp_x_sort,tmp_y_sort,tmp_h,tmp_n);
        rmse(i) = sqrt(sum((r.f'-tmp_y_sort).^2)/tmp_n);
    end
else
    disp(['Error: flag_task']);
end

% disp(['error_rate: ' 'mean->' num2str(mean(error_rate)) ' std->' num2str(std(error_rate))]);
% disp(['RMSE: ' 'mean->' num2str(mean(rmse)) ' std->' num2str(std(rmse))]);

end