%% Creates Fig. S1
clear all
close all
clc

width = 17.8; % 1.5 columns;
height = 15;
font_size = 7;
letter_size = 10;
title_font_size = 8;

% Figure shape and size
figure('units', 'centimeters', 'position', [0 0  width   height], 'paperpositionmode', 'auto')
% Produces a figure 9.0 in by 9.0 in. Shrink 2x to 4.5 in width

% Set display characteristics
tics = [];
title_x = -.2;
title_y = 1.67;
label_x = -.1;
label_y = 1.2;
sparse_color = [.5 .7 1];
dense_color = [0 0 1];
panels = 'ABCDEFGHIJ';
subplots = [1 2 3 5 6 7 9 10 11 12];
num_plots = numel(subplots);

% Load data
load results/figS1_results

% Compute mi and mic stats
mic_means = mean(mic);
mi_means = mean(mi);
mic_stds = std(mic);
mi_stds = std(mic);

% Draw each panel, panel label, and other markup
for n=1:num_plots
    
    subplot(3,4,subplots(n));
    set(gca, 'fontsize', font_size)
    x_label = 'X';
    y_label = 'Y';
    t1 = sprintf('I = %0.2f \\pm %0.2f', mi_means(n), mi_stds(n));
    t2 = sprintf('MIC = %0.2f \\pm %0.2f', mic_means(n), mic_stds(n));
    
    plot(xs(:,n),ys(:,n),'.', 'linewidth', 0.5, 'color', dense_color, 'markersize', 4)
    
    switch n
        case 1,           
            %text(title_x , title_y, 'Increasing noise', 'fontsize', title_font_size)   
            
        case 4,
            %text(title_x , title_y, 'Reparameterization invariance', 'fontsize', title_font_size)   
            
        case 7,
            x_label = 'X';
            y_label = 'W';
            %text(title_x , title_y, 'Data Processing Inequality', 'fontsize', title_font_size)
            
        case 8,
            x_label = 'Y';
            y_label = 'X';
            
        case 9,
            x_label = 'Z';
            y_label = 'Y';
            
        case 10,
            x_label = 'Z';
            y_label = 'W';
            
        otherwise,
    end
    
    set(gca, 'xtick', tics, 'ytick', tics, 'xlim', [0 1], 'ylim', [0 1], 'linewidth', 0.5, 'box', 'on')
    text(label_x , label_y, panels(n), 'fontsize', letter_size )
    axis image
    title({t1, t2})
    xlabel(x_label)
    ylabel(y_label)
end

% Save figure
saveas(gcf, 'figures/figS1.eps', 'epsc')