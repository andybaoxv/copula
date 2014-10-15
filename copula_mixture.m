% This script generates synthetic data for feature selection with Ccor
% Mixture of copulas: C = p*C_s + (1-p)*\Pi, where C_s is a singular copula
% representing the deterministic relationship so that its support S has
% Lebesgue measure zero, \Pi corresponds to the independent copula \Pi(u,v)
% = uv (the uniform distribution on the unit square)

% Number of samples
n_samples = 10000;

% Generate samples for random variable Y
y = rand(n_samples,1);
% vary the proportion of deterministic signals and generate samples for
% random variable X accordingly
x = zeros(n_samples,11);
index_col_x = 0;
for p = 0:0.1:1
    index_col_x = index_col_x + 1;
    % generate n_samples uniformly distributed pseudorandom numbers
    tmp = rand(n_samples,1);
    % indices of deterministic signal
    idx_d = (tmp <= p);
    % indices of random signal
    idx_r = (tmp > p);
    tmp_x = zeros(n_samples,1);
    tmp_x(idx_r,:) = rand(sum(idx_r),1);
    tmp_x(idx_d,:) = generate_M(y(idx_d));
    x(:,index_col_x) = tmp_x;
    
    % visualization
    figure(index_col_x);
    hold on
    scatter(y(idx_d),tmp_x(idx_d),'r');
    scatter(y(idx_r),tmp_x(idx_r),'b');
    hold off
end

