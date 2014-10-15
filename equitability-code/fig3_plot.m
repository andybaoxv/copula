%% Plots Fig. 3
clear all
close all
clc

width = 8.7; 
height = 15;
font_size = 7;
letter_size = 10;
title_font_size = 8;
figure('paperpositionmode', 'auto', 'units', 'centimeters', 'position', [0 0 width height])
% Produces a figure 6.79 x 10.06 in. Reduce 2x to width of 3.40 in

load results/fig3_figS4_results.mat

% Get monotonicities and assign colors
all_colors = helper_simulation_colormap();
num_colors = size(all_colors,1);
func_colors = [];
monotonicities = results_new.monotonicity;
num_funcs = numel(monotonicities);
for m=1:num_funcs
    c_index = ceil(monotonicities(m)*num_colors);
    color(m,:) = all_colors(c_index,:);
    labels{m,1} = sprintf('%0.2f', monotonicities(m));
end

% Plot results
%figure('position', [331         169         757        1030], 'paperpositionmode', 'auto')
subplot_labels = 'ABCDE';
handles = [];

% Set variables shared across plots
x_label = 'noise (1-R^2)';
xl = [0 1];
xticks = [0 .2 .4 .6 .8 1];
for n=1:4
    subplot(3,2,n)
    for m=1:num_funcs
        switch n
            case 1,
                dependence = results_reshef.MIC_reshef_xy(:,m);
                noise      = results_reshef.noise_rsq(:,m);
                yl = [0 1];
                y_label = 'MIC';
                yticks = 0:.2:1;
                t = 'N \leq 1000';
                
            case 2,
                dependence = results_new.MIC_reshef_xy(:,m);
                noise      = results_new.noise_rsq(:,m);
                yl = [0 1];
                y_label = 'MIC';
                yticks = 0:.2:1;
                t = 'N = 5000';
                
            case 3,
                dependence = results_reshef.I06_xy(:,m);
                noise      = results_reshef.noise_rsq(:,m);
                yl = [0 2.5];
                y_label = 'I (k = 6)';
                yticks = 0:.5:3;
                t = 'N \leq 1000';
                
            case 4,
                dependence = results_new.I01_xy(:,m);
                noise      = results_new.noise_rsq(:,m);
                yl = [0 2.5];
                y_label = 'I (k = 1)';
                yticks = 0:.5:3;
                t = 'N = 5000';
            otherwise,
        end
        plot(noise, dependence, '+', 'markersize', 2, 'linewidth', 0.5, 'color', color(m,:));
        hold on
    end
    ylim(yl)
    xlim(xl)
    text(-.30, 1.15*max(yl), subplot_labels(n), 'fontsize', letter_size)
    axis square
    set(gca, 'fontsize', font_size, 'linewidth', 0.5, 'box', 'on')
    set(gca, 'xtick', xticks, 'ytick', yticks)
    % Label plots
    xlabel(x_label);
    ylabel(y_label);
    title(t);
end

% Create legend
subplot('position', [0.1300    0.1696    0.7750    0.1442])
for m=1:num_funcs;
    x = .05 + .2*floor((m-1)/5);
    y = .9 - .6*mod(m-1,5)/5;
    plot(x,y,'+', 'markersize', 3, 'linewidth', 1.0,  'color', color(m,:))
    text(x+.025, y, labels{m}, 'fontsize', font_size)
    hold on
end
xlim([0 1])
ylim([0 1])
axis off
title('Monotonicity of noiseless relationships  ', 'fontsize', title_font_size)
text(-.04, 1.15, 'E', 'fontsize', letter_size)

% Save figure
saveas(gcf, 'figures/fig3.eps', 'epsc')

% Compute the fraction of time that MIC == I_MIC


