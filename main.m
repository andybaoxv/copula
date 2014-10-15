% main function
clear all, close all, clc;

% code of computing mutual information
% addpath('./mi/');
% dataset folder
addpath('./data/');

score = [];
% feature ranking
feature_list = [];

[feature_sel,error_rate,rmse] = func_feature_selection(10,false,[1],0.1,true,...
    'classification',2);
disp(['error_rate: ' 'mean->' num2str(mean(error_rate)) ' std->' num2str(std(error_rate))]);
%disp(['RMSE: ' 'mean->' num2str(mean(rmse)) ' std->' num2str(std(rmse))]);
disp(feature_sel);

% score = [score,mean(error_rate)];
% feature_list = [feature_list;feature_sel];
% 
% % vary the percent of missing values in top 5 ranking features
% for percent_missing = 0.1:0.1:0.9
%     [feature_sel_m,error_rate_m,rmse_m] = func_feature_selection(11,true,...
%     feature_sel(1),percent_missing,true,'regression',2);
%     %disp(['error_rate_m: ' 'mean->' num2str(mean(error_rate_m)) ' std->' num2str(std(error_rate_m))]);
%     disp(num2str(percent_missing));
%     score = [score,mean(error_rate_m)];
%     feature_list = [feature_list;feature_sel_m];
% end
% 
% %plot(0:0.1:0.9,score);

