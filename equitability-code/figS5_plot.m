%% Draws Fig. 4
clear all
close all
clc

width = 17.8; 
height = 7;
font_size = 7;
letter_size = 10;
title_font_size = 8;
figure('paperpositionmode', 'auto', 'units', 'centimeters', 'position', [0 0 width height])
% Produces a figure 11.86 x 4.75. Reduce 2x to a width of 5.9 in

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
        case 'MIC (Reshef)',
            stat_names{n} = 'MIC (Reshef)    ';
            stat_is(1) = n;
        case 'MIC (Albanese)',
            stat_names{n} = 'MIC (Albanese) ';
            stat_is(2) = n;
        case 'MI (MIC Albanese)',
            stat_names{n} = '  ';
            stat_is(3) = n;
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
        stats_thresholds = repmat(quantile(null_stats,.95,2),1,num_trials);
        successes = sum((pos_stats > stats_thresholds),2);
        power_mat(:,n) = successes/num_trials;
    end
    
    % Get sample resultionship
    xs_sample = these_results(1).xs_sample;
    ys_sample = these_results(1).ys_sample;
    
    % Make sure number of rows matches number of stats
    assert(size(power_mat,1) == num_stats)
    
    % Plot example relationship with nosie = 0.1    
    subplot(4,num_relationships,r)
    plot(xs_sample(:), ys_sample(:), '.k', 'markerfacecolor', 'k', 'markersize', 4)
    set(gca, 'box', 'on', 'xtick', [], 'ytick', [])
    axis image
    axis square
    axis off
    
    % Plot resutls of power calculation
    subplot(3,num_relationships, num_relationships+r)
    imagesc(power_mat(stat_is,:))
    set(gca, 'clim', [0, 1], 'box', 'on')
    midpoint = 1 + (num_results-1)*log(3)/log(10);
    set(gca, 'xtick', [], 'clim', [0 1], 'fontsize', font_size)
    title(relationships{r}, 'fontsize', title_font_size)
    hold on
    num_noises = size(power_mat,2);
    
    for n=1:sum(stat_is)
        plot([.5 num_noises+.5], (n-.5)*[1 1], '-k', 'linewidth', 0.5);  
    end
    
    % Annotate heatmaps
    if r==1     % list of dependence measures
        set(gca, 'ytick', 1:num_stats, 'yticklabel', stat_names(stat_is), 'fontsize', font_size)
        
        % This is totally stupid. Matlab can't use latex on y-ticks, so we
        % have to hack the R^2 label
        h3 = ylabel('I_{MIC} (Albanese)', 'rot', 0);
        set(h3, 'position', [ -10.6196    3.4186   17.3205])
    else
        set(gca, 'ytick', 1:num_stats, 'yticklabel', [])
    end
    if r == num_relationships % colorbar
        h = colorbar();
        set(h,'fontsize',font_size, 'ytick',[0, .5, 1], 'yticklabel', {'0%', '50%', '100%'}, 'position', [0.92    0.4106    0.0114    0.2161], 'linewidth', 0.5);
        ylabel(h,'power')
    end
    
    % Compute the fraction of time that MIC uses 2 bins on one of the axes
    % Note: MIC is pos_stats(2,:), while I_MIC is pos_stats(3,:);
    bin_nums = (2:5)';
    for n=1:num_results
        pos_stats = these_results(n).pos_stats;
        null_stats = these_results(n).null_stats;
        num_bins_used(:,n) = round(2.^(log2(exp(1))*pos_stats(3,:) ./ pos_stats(2,:)));
        bin_tally(:,n) = hist(num_bins_used(:,n),bin_nums)/numel(num_bins_used(:,n));
    end
    disp([relationships{r} ': max num bins used: ' num2str(max(num_bins_used(:)))])  
    
    disp([relationships{r} ': 2 bins used ' num2str(sum(num_bins_used(:) == 2)) ' times out of ' num2str(numel(num_bins_used(:)))])
   
    
    % Plot MIC (Albanese) bin usage
    subplot(3,num_relationships, 2*num_relationships + r)
    imagesc(bin_tally)
    set(gca, 'clim', [0, 1], 'box', 'on', 'linewidth', 0.5)
    midpoint = 1 + (num_results-1)*log(3)/log(10);
    set(gca, 'xtick', [1 midpoint num_results], 'xticklabel', [1 3 10], 'clim', [0 1], 'fontsize', font_size)
    hold on
    num_noises = size(power_mat,2);
    for n=1:size(bin_tally,1)
        plot([.5 num_noises+.5], (n-.5)*[1 1], '-k', 'linewidth', 0.5);  
    end    
    if r==1     % list of dependence measures
        set(gca, 'ytick', 1:numel(bin_nums), 'yticklabel', [2,3,4,5], 'fontsize', font_size)
        ylabel('min(n_i, n_j) ');
    else
        set(gca, 'ytick', 1:numel(bin_nums), 'yticklabel', [])
    end    
    if r == 3   % x-axis label
        xlabel('noise amplitude ', 'fontsize', font_size)
    end
    if r == num_relationships % colorbar
        h2 = colorbar();
        set(h2,'fontsize',font_size, 'ytick',[0, .5, 1], 'position', [0.92    0.1081    0.0114    0.2161], 'linewidth', 0.5);
        ylabel(h2,'fraction')
    end

end

% Label panels
annotation(gcf, 'textbox', 'String','A','fontsize',letter_size,'position',[0   .62  .1 .1],'BackgroundColor','none', 'edgecolor', 'none');
annotation(gcf, 'textbox', 'String','B','fontsize',letter_size,'position',[0   .27  .1 .1],'BackgroundColor','none', 'edgecolor', 'none');

% Set colormap
cmap = helper_power_colormap();
colormap(cmap)

% Save figure
saveas(gcf,'figures/figS5.eps','epsc')
