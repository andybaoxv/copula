%% Creates Fig. 1
clear all
close all
clc

% Compute true mutual information
% I[x;y] = H[y] - H[noise]
% H[noise] = 0 => I[x;y] = H[y]

% K = 100, M = 100 FOR PUBLICATION
% K = 10, M = 5 FOR TESTING
K = 10;
M = 5;

% Compute true information
N = 1E6;
n_bins = 100;

Hy = [];
mm = (n_bins - 1)/(2*N);
disp(sprintf('Miller-Maddow correction: %0.5f. Computing MI using %d simulations...', mm, K))
for k=1:K
    xs = linspace(0,1,N)';
    ys = xs.^2 + (rand(N,1)-.5) + .5;
    [ns, xcs] = hist(ys, n_bins); %floor(sqrt(N)));
    dx = xcs(2)-xcs(1);
    pys = (ns/N)/dx;
    
    % Estimate entropy using the Miller-Madow bias correction
    Hy(end+1,1) = -sum(dx.*pys.*log2(pys)) + mm;
end
I = mean(Hy);
dI = std(Hy);
disp(sprintf('Done. True mutual informaition: %0.5f +- %0.5f bits', I, dI))

% Perform simulation
N = 1000;
k = 1;
disp(sprintf('Estimating MI and MIC for %d replicates...', M));
for m=1:M
    
    disp(sprintf('Doing estimation for replicate %d...', m));
    
    % Generate xs
    x1 = sort(rand(N,1));
    x2 = -1+2*x1;
    
    % Generate noiseless ys
    y0_1 = x1.^2 + .5;
    y0_2 = x2.^2 + .5;
    
    % Add noise
    y1 = y0_1 + (rand(N,1)-.5);
    y2 = y0_2 + (rand(N,1)-.5);
    
    % Compute statistics
    rsq1(m,1) = statistic_sqcorr(x1, y1);
    rsq2(m,1) = statistic_sqcorr(x2, y2);
    mi1(m,1) = statistic_mi_kraskov(x1, y1, k);
    mi2(m,1) = statistic_mi_kraskov(x2, y2, k);
    mic1(m,1) = statistic_mic_reshef(x1, y1);
    mic2(m,1) = statistic_mic_reshef(x2, y2);
    
end

% Save results
disp('Saving results...')
save results/fig1_results.mat mi1 mi2 mic1 mic2 rsq1 rsq2 x1 x2 y1 y2 y0_1 y0_2 I dI
disp('Done.')
