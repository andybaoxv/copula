% compare values of ccore and ccore_tie

addpath('./data/')

load M_function_X
load M_function_Y
X = M_function_X;
Y = M_function_Y;

[n_samples,n_features] = size(X);
val_ccore = zeros(n_features,1);
val_ccore_tie = zeros(n_features,1);
for j = 1:n_features
    val_ccore(j) = ccore(X(:,j),Y);
    val_ccore_tie(j) = ccore_tie(X(:,j),Y);
end

figure(1)
hold on
plot(val_ccore,'r');
plot(val_ccore_tie,'b');
hold off
