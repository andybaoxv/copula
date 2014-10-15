%% Creates Fig. S2
clear all
close all
clc

width = 9.5;
height = 3.3;
font_size = 7;
letter_size = 10;
title_font_size = 8;
figure('paperpositionmode', 'auto', 'units', 'centimeters', 'position', [0 0 width height])

% Set display characteristics
tics = [];
title_x = -.2;
title_y = 1.67;
label_x = -.2;
label_y = 1.4;
sparse_color = [.5 .7 1];
dense_color = [0 0 1];
panels = 'ABCD';
subplots = [1 2 3 4];
num_plots = numel(subplots);

% Draw each panel, panel label, and other markup
for n=1:num_plots
    
    subplot(1,4,subplots(n));
    set(gca, 'fontsize', font_size)
    switch n
        case 1,
            fill(.25*[0 1  1  0], .25*[0 0 1 1], dense_color, 'linestyle', 'none')
            hold on
            fill(.25+.25*[0 1  1  0], .75+.25*[0 0 1 1], dense_color , 'linestyle', 'none')
            fill(.5+.5*[0 1  1  0], .25+.5*[0 0 1 1], sparse_color, 'linestyle', 'none')
            t = {'I = 1.5','MIC = 1.0'};
            x_label = 'X';
            y_label = 'Y';
            
        case 2,
            fill(.25*[0 1  1  0], .25*[0 0 1 1], dense_color, 'linestyle', 'none')
            hold on
            fill(.25+.5*[0 1  1  0], .25+.5*[0 0 1 1], sparse_color, 'linestyle', 'none')
            fill(.75+.25*[0 1  1  0], .75+.25*[0 0 1 1], dense_color , 'linestyle', 'none')
            t = {'I = 1.5','MIC = 0.95'};
            x_label = 'f(X)';
            y_label = 'Y';
            
        case 3,
            x = [0 1];
            y = [0 1];
            plot(.25*x, .25*y, '-b', 'linewidth', 1)
            hold on
            plot(.25+.25*x, .75+.25*y, '-b', 'linewidth', 1)
            plot(.5+.5*x, .25+.5*y, '-b', 'linewidth', 1)
            t = ' ';
            x_label = 'X';
            y_label = 'f(X)';
            
        case 4,
            fill(.25*[0 0 1 1], .5+.25*[0 1 0 -1], dense_color, 'linestyle', 'none')
            hold on
            fill(.25+.5*[0 0 1 1], .5+.5*[0 1 0 -1], sparse_color, 'linestyle', 'none')
            fill(.75+.25*[0 0 1 1], .5+.25*[0 1 0 -1], dense_color, 'linestyle', 'none')
            t = ' ';
            x_label = 'f(X)';
            y_label = '\eta';
            
        otherwise,
    end
    
    set(gca, 'xtick', tics, 'ytick', tics, 'xlim', [0 1], 'ylim', [0 1], 'linewidth', 0.5, 'box', 'on')
    text(label_x , label_y, panels(n), 'fontsize', letter_size )
    axis image
    title(t);
    xlabel(x_label)
    ylabel(y_label)
end


% Save figure
saveas(gcf, 'figures/figS2.eps', 'epsc')