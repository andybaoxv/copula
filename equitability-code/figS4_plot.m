%% Plots Fig. S4
clear all
close all
clc

load results/fig3_figS4_results.mat

width = 17.8;
height = 10;
font_size = 7;
letter_size = 10;
title_font_size = 8;
figure('paperpositionmode', 'auto', 'units', 'centimeters', 'position', [0 0 width height])
% Produces figure size 12.0 x 7.1 in. Shrink 2x to width of 6.0 in

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
%figure('position', [30         514        1668         799], 'paperpositionmode', 'auto')
subplot_labels = 'ABCDEFGH';
handles = [];

% Plot individual panels
for n=1:7
    subplot(2,4,n)
    for m=1:num_funcs
        fs = 14;
        xl = [0 1];
        yl = [0 1];
        marker = '+';
        t = 'N = 5000 ';
        
        switch n
            case 1,
                dependence = results_new.MIC_reshef_xy(:,m);
                noise      = results_new.MIC_reshef_self(:,m);
                x_label = 'MIC\{f(x);y\} ';
                y_label = 'MIC\{x;y\} ';
                
            case 2,
                dependence = results_new.dcor_xy(:,m);
                noise      = results_new.dcor_self(:,m);
                x_label = 'dCor\{f(x);y\} ';
                y_label = 'dCor\{x;y\} ';
                
            case 3,
                dependence = results_new.hoeffding_xy(:,m);
                noise      = results_new.hoeffding_self(:,m);
                x_label = 'Hoeffding\{f(x);y\} ';
                y_label = 'Hoeffding\{x;y\} ';
                
            case 4,
                dependence = results_mi_exact.I_xy(:,m);
                noise      = results_mi_exact.noise_rsq(:,m);
                yl = [0 2.5];
                x_label = '1 - R^2[f(X);Y] ';
                y_label = 'I[X;Y] ';
                t = 'N = \infty ';
                
            case 5,
                dependence = results_new.I01_xy(:,m);
                noise      = results_new.I01_self(:,m);
                xl = [0 2.5];
                yl = [0 2.5];
                x_label = 'I\{f(x);y\}  (k = 1)';
                y_label = 'I\{x;y\}  (k = 1) ';
                
            case 6,
                dependence = results_new.I06_xy(:,m);
                noise      = results_new.I06_self(:,m);
                xl = [0 2.5];
                yl = [0 2.5];
                x_label = 'I\{f(x);y\}  (k = 6) ';
                y_label = 'I\{x;y\}  (k = 6) ';
                
            case 7,
                dependence = results_new.I20_xy(:,m);
                noise      = results_new.I20_self(:,m);
                xl = [0 2.5];
                yl = [0 2.5];
                x_label = 'I\{f(x);y\}  (k = 20) ';
                y_label = 'I\{x;y\}  (k = 20) ';
                
            otherwise,
        end
        plot(noise, dependence, marker, 'markersize', 2, 'linewidth', 0.5, 'color', color(m,:));
        hold on
    end
    yrange = max(yl)-min(yl);
    yticks = min(yl):(yrange/5):max(yl);
    xrange = max(xl)-min(xl);
    xticks = min(xl):(xrange/5):max(xl);
    ylim(yl)
    xlim(xl)
    text(-.20*max(xl), 1.15*max(yl), subplot_labels(n), 'fontsize', letter_size)
    axis square
    set(gca, 'fontsize', font_size, 'linewidth', 0.5, 'box', 'on')
    set(gca, 'xtick', xticks, 'ytick', yticks)
    % Label plots
    xlabel(x_label);
    ylabel(y_label);
    title(t);
end

% Create legend
subplot(2,4,8)
for m=1:num_funcs;
    x = .85 - .4*floor((m-1)/7);
    y = mod((m-1),7)/7 + 1/14;
    plot(x,y,'+', 'markersize', 3, 'linewidth', 1,  'color', color(end-m+1,:))
    text(x+.025, y, labels{end-m+1}, 'fontsize', font_size)
    hold on
end
set(gca, 'fontsize', font_size);
xlim([0 1])
ylim([0 1])
axis square
axis off
title('Monotonicity ', 'fontsize', font_size)
text(-.20, 1.15, 'H', 'fontsize', letter_size)

% Save figure
saveas(gcf, 'figures/figS4.eps', 'epsc')
