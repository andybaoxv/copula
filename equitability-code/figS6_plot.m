%% Draws Fig. S6
clear all
close all
clc

width = 10;
height = 15;
font_size = 7;
letter_size = 10;
title_font_size = 8;
figure('paperpositionmode', 'auto', 'units', 'centimeters', 'position', [0 0 width height])
%figure('paperpositionmode', 'auto', 'units', 'centimeters', 'position', [1.3536    1.9177   20.7840   20.1636])
% Produces a figure 13.56 x 4.08. Reduce 2x to a width of 6.8 in

% Get list of files containing power calculation results
files = dir('results/fig4_figS5_results/results*.mat');
num_files = numel(files);

% Read in unordered results
for n=1:num_files
    full_file_name = ['results/fig4_figS5_results/' files(n).name];
    load(full_file_name)
    unordered_results(n) = results;
end

% Define order of noisy relationships
relationships = {'linear', 'parabolic', 'sinusoidal', 'circular', 'checkerboard'};
num_relationships = numel(relationships);

% Alter stat names for display purposes
% And set order in which to plot them
stat_names = results.stat_names;
num_stats = numel(stat_names);
stat_is = [];
stat_colors = [];
for n=1:numel(stat_names)
    name = stat_names{n};
    switch stat_names{n}
        case 'R^2'
            stat_names{n} = '  ';
            stat_is(1) = n;
            stat_colors(1,:) = [0, 0, 0];
        case 'dCor' 
            stat_names{n} = 'dCor ';
            stat_is(2) = n;
            stat_colors(2,:) = [.5, .5, .5];
        case ['Hoeffding''', 's D']
            stat_names{n} = 'Hoeffding ';
            stat_is(3) = n;
            stat_colors(3,:) = [.2, .8, .2];
        case 'MI (Kraskov k=1)',
            stat_names{n} = 'I (k = 1) ';
            stat_is(4) = n;
            stat_colors(4,:) = [.6, .6, 1];
        case 'MI (Kraskov k=6)',
            stat_names{n} = 'I (k = 6) ';
            stat_is(5) = n;
            stat_colors(5,:) = [.3, .3, 1];
        case 'MI (Kraskov k=20)',
            stat_names{n} = 'I (k = 20) ';
            stat_is(6) = n;
            stat_colors(6,:) = [.1, .1, 1];
        case 'MIC (Reshef)',
            stat_names{n} = 'MIC ';
            stat_is(7) = n;
            stat_colors(7,:) = [1, .2, .2];
        case 'MI (MIC Albanese)'
            stat_names{n} = 'I_MIC ';
            stat_is(8) = n;
            stat_colors(8,:) = [.5, 0, .5];
        otherwise,
    end
end


% Order all results by realtionship, then by noise
for r=1:num_relationships
    
    % For each relationship, gather all results that share that relationships    
    this_relationship = relationships{r};
    k=1;
    for n=1:num_files
        if strcmp(this_relationship, unordered_results(n).computation.relationship)
            these_results(k) = unordered_results(n);
            these_noises(k) = unordered_results(n).computation.noise;
            k = k+1;
        end
    end
    
    % Order results by ascending noise
    noise_order = helper_rankorder(these_noises);
    these_results(noise_order) = these_results;
    ordered_results{r} = these_results;
end

% Plot results for each relationship
%figure('position', [113         649        1311         509], 'paperpositionmode', 'auto');
for r=1:num_relationships
    
    % For each relationship, get results
    these_results = ordered_results{r};
    num_results = numel(these_results);
    
    % For each results (i.e. given noise value), get power of all
    % statistics
    power_mat = [];
    for n=1:numel(these_results)
        pos_stats = abs(these_results(n).pos_stats);
        null_stats = abs(these_results(n).null_stats);
        num_trials = size(null_stats,2);
        stats_thresholds = repmat(helper_quantile(null_stats,.95,2),1,num_trials);
        successes = sum((pos_stats > stats_thresholds),2);
        power_mat(:,n) = successes/num_trials;
    end
    
    % Get sample resultionship
    xs_sample = these_results(1).xs_sample;
    ys_sample = these_results(1).ys_sample;
    
    % Make sure number of rows matches number of stats
    assert(size(power_mat,1) == num_stats)
    
    % Plot example relationship with nosie = 0.1    
    %subplot(num_relationships,3,(r-1)*3+1)
    %plot(xs_sample(:), ys_sample(:), '.k', 'markerfacecolor', 'k', 'markersize', 6)
    %set(gca, 'box', 'on', 'xtick', [], 'ytick', [])
    %axis image
    %axis square
    %axis off
    
    % Compute noise amplitudes
    noise_amplitudes = [];
    for n=1:num_results
        noise_amplitudes(1,n) = 10*these_results(n).computation.noise;
    end
    
    % Plot resutls of power calculation
    subplot(num_relationships,1,r)
    %subplot(num_relationships,3,(r-1)*3+[2, 3])
    %semilogx(noise_amplitudes, power_mat(stat_is,:)', 'linewidth', 2)
    xs = noise_amplitudes;
    for i = fliplr(1:numel(stat_is))
        semilogx(noise_amplitudes, power_mat(stat_is(i),:), 'linewidth', 2, 'color', stat_colors(i,:))
        hold on
    end
    ylim([0, 1])
    xlim([1, 10])
    title(relationships{r}, 'fontsize', title_font_size)
    hold on
    num_noises = size(power_mat,2);

    if r == num_relationships
        xlabel('noise amplitude', 'fontsize', font_size)
    end
    ylabel('power', 'fontsize', font_size)
    set(gca, 'box', 'on', 'fontsize', font_size)

end

% Set colormap
cmap = helper_power_colormap();
colormap(cmap)


% Save figure
saveas(gcf,'figures/figS6.eps','epsc')
