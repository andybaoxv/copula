%% Draws Fig. 4
clear all
close all
clc

width = 17.8;
height = 4.5;
font_size = 7;
letter_size = 10;
title_font_size = 8;
figure('paperpositionmode', 'auto', 'units', 'centimeters', 'position', [0 0 width height])
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
for n=1:numel(stat_names)
    name = stat_names{n};
    switch stat_names{n}
        case 'R^2'
            stat_names{n} = '  ';
            stat_is(1) = n;
        case 'dCor' 
            stat_names{n} = 'dCor ';
            stat_is(2) = n;
        case ['Hoeffding''', 's D']
            stat_names{n} = 'Hoeffding ';
            stat_is(3) = n;
        case 'MI (Kraskov k=1)',
            stat_names{n} = 'I (k = 1) ';
            stat_is(4) = n;
        case 'MI (Kraskov k=6)',
            stat_names{n} = 'I (k = 6) ';
            stat_is(5) = n;
        case 'MI (Kraskov k=20)',
            stat_names{n} = 'I (k = 20) ';
            stat_is(6) = n;
        case 'MIC (Reshef)',
            stat_names{n} = 'MIC ';
            stat_is(7) = n;
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
    subplot(3,num_relationships,r)
    plot(xs_sample(:), ys_sample(:), '.k', 'markerfacecolor', 'k', 'markersize', 4)
    set(gca, 'box', 'on', 'xtick', [], 'ytick', [])
    title(relationships{r}, 'fontsize', title_font_size)
    axis image
    axis square
    axis off
    
    % Plot resutls of power calculation
    subplot(3,num_relationships,[num_relationships, 2*num_relationships]+r)
    imagesc(power_mat(stat_is,:))
    set(gca, 'clim', [0, 1], 'box', 'on')
    midpoint = 1 + (num_results-1)*log(3)/log(10);
    set(gca, 'xtick', [1 midpoint num_results], 'xticklabel', [1 3 10], 'clim', [0 1], 'fontsize', font_size, 'linewidth', 0.5)
    %title(relationships{r}, 'fontsize', title_font_size)
    hold on
    num_noises = size(power_mat,2);

    % Annotate heatmaps
    if r==1     % list of dependence measures
        set(gca, 'ytick', 1:num_stats, 'yticklabel', stat_names(stat_is), 'fontsize', font_size)
        
        % This is totally stupid. Matlab can't use latex on y-ticks, so we
        % have to hack the R^2 label
        h3 = ylabel('R^2', 'rot', 0);
        set(h3, 'position', [-2.1840    1.3950   17.3205]) 
    else
        set(gca, 'ytick', 1:num_stats, 'yticklabel', [])
    end
    if r == 3   % x-axis label
        xlabel('noise amplitude', 'fontsize', font_size)
    end
    if r == num_relationships % colorbar
        h = colorbar();
        set(h,'fontsize',font_size, 'ytick',[0, .5, 1], 'yticklabel', {'0%', '50%', '100%'}, 'position', [0.9256    0.2303    0.0125    0.2602], 'linewidth', 0.5);
        ylabel(h,'power')
    end
    
    % Mark columns within 25% of maximum
    % Compute noise
    nearby = .25;
    noise_amplitudes = [];
    for n=1:num_results
        noise_amplitudes(1,n) = 10*these_results(n).computation.noise;
    end
    A = (power_mat > .5).*repmat(noise_amplitudes,num_stats,1);
    max_noises = max(A')';
    ub = max(max_noises);
    lb = ub*(1 - nearby);
    stats_to_star = (max_noises <= ub) & (max_noises > lb);
    ys = find(stats_to_star(stat_is));
    xs = num_results*ones(size(ys))/10;
    hold on
    plot(xs,ys,'*k','markersize', 3, 'linewidth', 0.3)

end

% Set colormap
cmap = helper_power_colormap();
colormap(cmap)


% Save figure
saveas(gcf,'figures/fig4.eps','epsc')
