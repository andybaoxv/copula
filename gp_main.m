% This function apply gaussian process on the dataset and return negative
% likelihood function

% training data [xtr,ytr]
[xtr,idx] = sort(X2);
ytr = Y(idx);

% set up covariance function
cov = {@covSEiso}; sf = 1; ell = 0.4;
hyp0.cov  = log([ell;sf]);
% set up mean function
mean = {@meanSum,{@meanLinear,@meanConst}}; a = 1/5; b = 1;       
hyp0.mean = [a;b];
% number of conjugate gradient steps
Ncg = 100;
% set up likelihood function
sn = 0.2;
hyp0.lik  = log(sn);
% inference algorithm
inf = 'infVB';
% likelihood function
lik = 'likSech2';

% optimal hyperparameters
hyp = minimize(hyp0,'gp', -Ncg, inf, mean, cov, lik, xtr, ytr);

% apply gaussian process
score = gp(hyp, inf, mean, cov, lik, xtr, ytr);

