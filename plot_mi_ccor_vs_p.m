addpath('./equitability-code/');
addpath('./data/')

load M_function_X
load M_function_Y
X = x;
Y = y;

% Mutual Information Measurement
mi_xy = [];
% Copula Measurement
ccor_xy = [];

for j = 1:11
    mi_xy = [mi_xy statistic_mi_kraskov(Y,X(:,j),5)];
    ccor_xy = [ccor_xy ccore(Y,X(:,j))];
end

% Display results
disp(['mi_xy:   ' num2str(mi_xy)]);
disp(['ccor_xy: ' num2str(ccor_xy)]);

figure(1)
hold on
plot(0:0.1:1,mi_xy,'b');
plot(0:0.1:1,ccor_xy,'r');
xlabel('p: Deterministic Signal Proportion');
ylabel('Value of Dependency Measures');
hleg1 = legend('MI','Ccor');
set(hleg1,'Location','NorthWest');
hold off

figure(2)
hold on
[Y_sort,tmp_idx] = sort(Y);
X_sort = X(tmp_idx,11);
r = ksr(Y_sort,X_sort,0.001,length(X_sort));
scatter(Y_sort,X_sort,'b');
scatter(Y_sort,r.f,'r');
hold off



