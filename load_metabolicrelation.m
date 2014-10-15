clear all, close all, clc;
addpath('./data/');
addpath('./equitability-code/');

load metabolicrelation

idx = [8,9,13,15,19,21,22,23,24];
data = metabolicrelation(:,idx);
clear metabolicrelation
clear idx

flag_randomsample = false;
[n_instances,n_features] = size(data);
if flag_randomsample
    idx_sel = randsample(n_instances,1000);
    data = data(idx_sel,:);
end

n_features = size(data,2);
val_ccor = zeros(n_features);
val_mi = zeros(n_features);

for i = 1:n_features-1
    for j = i+1:n_features
        val_ccor(i,j) = ccore(data(:,i),data(:,j));
        val_mi(i,j) = statistic_mi_kraskov(data(:,i),data(:,j),5);
        disp([i,j]);
    end
end

val_ccor = (val_ccor+val_ccor');
val_mi = (val_mi + val_mi');
figure(1)
subplot(2,1,1),plot(val_ccor(8,:)),ylabel('ccor');
subplot(2,1,2),plot(val_mi(8,:)),ylabel('MI');
figure(6)
scatter(data(:,6),data(:,8));
figure(7)
scatter(data(:,7),data(:,8));
