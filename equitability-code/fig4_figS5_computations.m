%function run_power_calculation()
clear all
close all
clc


% USE Q = 5, c.num_trials = 20 FOR TESTING
% USE Q = 25, c.num_trials = 500 FOR PUBLICATION

relationships = {...
    'linear';
    'parabolic';
    'sinusoidal';
    'circular';
    'checkerboard'};

%Q = 25; % FOR PUBLICATION
Q = 5; % FOR TESTING

noises =  logspace(1,0,Q);

run_num = 1;
for r = 1:numel(relationships)
    for q = 1:Q
        c.N = 320;
        
        %c.num_trials = 500; % FOR PUBLICATION
        c.num_trials = 20; % FOR TESTING
        
        c.relationship = relationships{r};
        c.noise = noises(q);
        computations(run_num) = c;
        run_num = run_num + 1;
    end
end
num_runs = numel(computations);

% Save computation specifications
save results/fig4_figS5_results/computations.mat computations relationships noises

% Do computations serially
for run_num = 1:num_runs
    
    % Read in computation number
    computation = computations(run_num);
    N = computation.N;
    relationship = computation.relationship;
    noise = computation.noise;
    num_trials = computation.num_trials;
    
    % Iterate over trial
    is = randperm(N);
    for m=1:num_trials
        if mod(m,10) == 0
            disp(['run ' num2str(run_num) ' on trial ' num2str(m)])
        end
        
        switch relationship
            case 'linear',
                xs = randn(N,1);
                ys = (2/3)*xs + noise*randn(N,1);
                
            case 'parabolic',
                xs = randn(N,1);
                ys = (2/3)*(xs.^2) + noise*randn(N,1);
                
            case 'sinusoidal',
                xs = 5*pi*rand(N,1);
                ys = 2*sin(xs) + noise*randn(N,1);
                
            case 'circular',
                thetas = 2*pi*rand(N,1);
                xs = 10*cos(thetas) + noise*randn(N,1);
                ys = 10*sin(thetas) + noise*randn(N,1);
                
            case 'checkerboard',
                xcs = helper_randint(5,N);
                ycs = 2*helper_randint(2,N) + mod(xcs,2);
                xs = 10*(xcs + rand(N,1)) + noise*randn(N,1);
                ys = 10*(ycs + rand(N,1)) + noise*randn(N,1);
                
            otherwise,
                disp('PROBLEM!')
                break;
                
        end
        ys_null = ys(is);
        
        % Evaluate statistics on both positive and null data sets
        pos_stats(:,m) = helper_evaluate_statistics(xs,ys);
        [null_stats(:,m), stat_names] = helper_evaluate_statistics(xs,ys_null);
    end
    
    % Compute empirical power of all statistics tested
    thresholds = repmat(helper_quantile(null_stats,.95,2),1,num_trials);
    successes = sum((pos_stats > thresholds),2);
    power = successes/num_trials;
    dpower = sqrt(power.*(1-power)./num_trials);
    
    % Record power calculations
    results.computation = computation;
    results.power = power;
    results.dpower = dpower;
    results.thresholds = thresholds;
    results.pos_stats = pos_stats;
    results.null_stats = null_stats;
    results.xs_sample = xs;
    results.ys_sample = ys;
    results.stat_names = stat_names;
    
    % Save results for given relationship and noise level.
    save(['results/fig4_figS5_results/results_' num2str(run_num) '.mat'], 'results')
    
end
