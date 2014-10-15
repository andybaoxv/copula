% This script applies spline regression on the synthetic dataset

addpath('./ARESLab/');

for j = 1:4
    [xtr,order] = sort(X(:,j));
    ytr = Y(order);
    
    [model,time] = aresbuild(xtr,ytr);
    disp(['X' num2str(j) ' -> ' num2str(model.MSE)]);
    %plot(xtr,ytr);
end
