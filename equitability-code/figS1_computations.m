%% Performs computations for Fig. S1
clear all
close all
clc

% M = 100, N = 1000 FOR PUBLICATION
% M = 5, N = 100 FOR TESTING
M = 5;     % Number of trials to run
N = 100;    % Number of datapoints to draw

k = 1;    % KNN algorithm paramter

disp('Perfoming simulations for Fig. S1: samples drawn from theoretical distributions in Fig. 2')

xs = [];
ys = [];
for m=1:M
    disp(['On replicate ' num2str(m) ' of ' num2str(M) '...'])
    for n=1:10
        x = rand(N,1);
        r = rand(N,1);
        s = rand(N,1);
        
        mics = [];
        mis = [];
        
        switch n
            case 1,
                lb = x;
                amp = 0;
            case 2,
                lb = .25*floor(4*x);
                amp = .25*ones(size(x));
            case 3,
                lb = .5*floor(2*x);
                amp = .5*ones(size(x));
            case 4,
                lb = .5*(x>=.5).*(x<.75) + .75*(x>=.75);
                amp = .5*(x < .5) + .25*(x >= .5);
            case 5,
                lb = .25*(x>=.25).*(x<.75) + .75*(x>=.75);
                amp = .25*(x<.25) + .5*(x>=.25).*(x<.75) + .25*(x >= .75);
            case 6,
                lb = .5*(s>=.5).*((x<=.25) + (x>=.5).*(x<.75))+ .25*(x>=.25).*(x<.5) + .75*(x>=.75);
                amp = .25;
            case 7,
                lb = .5*(x>=.25).*(x<.75);
                amp = .5;
            case 8,
                lb = .25*(x>=.25).*(x<.75) + .75*(x>=.75);
                amp = .25*(x<.25) + .5*(x>=.25).*(x<.75) + .25*(x >= .75);
            case 9,
                lb = .25*(x>=.5) + .75*(x<.5).*(s>=.5);
                amp = .25*(x<.5) + .5*(x>=.5);
            case 10,
                lb = .5*floor(2*x);
                amp = .5*ones(size(x));
            otherwise,
        end
        y = lb + amp.*r;
        
        % Compute MIC
        mic(m,n) = statistic_mic_reshef(x,y);
        
        % Compute MI
        mi(m,n) = statistic_mi_kraskov(x,y,k);
        
        % Save xs and ys for last replicate, as an example
        xs(:,n) = x;
        ys(:,n) = y;
    end
end

% Save results
disp('Saving results...')
save results/figS1_results.mat mic mi xs ys M N k
disp('Done.')
