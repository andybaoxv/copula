%% Performs computations for Fig. 1
clear all
close all
clc

width = 8.7; % 1 column; render at 2x
height = 5;
font_size = 7;
letter_size = 10;
color = [1 .5 0];
figure('paperpositionmode', 'auto', 'units', 'centimeters', 'position', [0 0 width height])
% Produces 6.81 in x 4.04 in figure. Reduce to 3.40 in width

% Load final results
load results/fig1_results

% Panel A
subplot(1,2,1)

plot(x1,y1, '.', 'linewidth', 1, 'color', color, 'markersize', 4)
axis square
set(gca, 'xtick', [0, .5, 1], 'ytick', [0 1 2], 'fontsize', font_size, 'box', 'on', 'linewidth', 0.5)
xlabel('X')
ylabel('Y')

title_top = sprintf('R^2 = %0.3f \\pm %0.3f', mean(rsq1), std(rsq1));
title_bot = sprintf('I = %0.2f \\pm %0.2f', mean(mi1), std(mi1));
title_mic = sprintf('MIC = %0.2f \\pm %0.2f', mean(mic1), std(mic1));
title({title_top, title_bot, title_mic})

% Panel B
subplot(1,2,2)

plot(x2,y2, '.', 'linewidth', 1, 'color', color, 'markersize', 4)
axis square
set(gca, 'xtick', [-1, 0, 1], 'ytick', [0 1 2], 'fontsize', font_size, 'box', 'on', 'linewidth', 0.5)
xlabel('X')
ylabel('Y')

title_top = sprintf('R^2 = %0.3f \\pm %0.3f', mean(rsq2), std(rsq2));
title_bot = sprintf('I = %0.2f \\pm %0.2f', mean(mi2), std(mi2));
title_mic = sprintf('MIC = %0.2f \\pm %0.2f', mean(mic2), std(mic2));
title({title_top, title_bot, title_mic})

% Add panel labels
annotation(gcf, 'textbox', 'String','A','fontsize',letter_size,'position',[.05   .95  .1 .1],'BackgroundColor','none', 'edgecolor', 'none');
annotation(gcf, 'textbox', 'String','B','fontsize',letter_size,'position',[.50   .95  .1 .1],'BackgroundColor','none', 'edgecolor', 'none');

% Save figure
saveas(gcf,'figures/fig1.eps','epsc')