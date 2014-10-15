%% Performs computations for Figs. 3 and S4
clear all
close all
clc

% For testing, use (100, 200) for 2nd argument in two calls to 'helper_analyze_noisy_functions'
% For publication, use (<nothing>,5000) for 2nd argument in two calls to
% 'helper_analyze_noisy_functions'

% These are the noise amplitudes we use
noise_amps = [0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.15 1.3 1.45 1.60 1.8 2.1 2.5 3.1 4.5 6 8 10 20];

% Compute results for N = 250, 500, or 1000 data points
results_reshef = helper_analyze_noisy_functions(noise_amps, 100); % FOR TESTING
%results_reshef = helper_analyze_noisy_functions(noise_amps); % FOR PUBLICATION

% Compute results for N = 5000 data points
results_new = helper_analyze_noisy_functions(noise_amps, 200); % FOR TESTING
%results_new = helper_analyze_noisy_functions(noise_amps, 5000); % FOR PUBLICATION

% Compute MI values in the for the alrge data limit
results_mi_exact = helper_exact_mi_noisy_functions(noise_amps);

% Save results
save results/fig3_figS4_results.mat results_reshef results_new results_mi_exact;
