%% Creates Fig. 2
clear all
close all
clc

width = 9.5; % 1 column; render at 2x
height = 9;
font_size = 7;
letter_size = 10;
title_font_size = 8;
figure('paperpositionmode', 'auto', 'units', 'centimeters', 'position', [0 0 width height])
% Produces a figure 6.39 x 7.69 in. Reduce 2x to width of 3.2 in

% Set display characteristics
tics = [];
title_x = -.2;
title_y = 1.67;
label_x = -.2;
label_y = 1.4;
sparse_color = [.5 .7 1];
dense_color = [0 0 1];
panels = 'ABCDEFGHIJ';
subplots = [1 2 3 5 6 7 9 10 11 12];
num_plots = numel(subplots);

% Draw each panel, panel label, and other markup
for n=1:num_plots
    
    subplot(3,4,subplots(n));
    set(gca, 'fontsize', font_size)
    x_label = 'X';
    y_label = 'Y';
    switch n
        case 1,
            x = [0 1];
            y = [0 1];
            plot(x, y, '-b', 'linewidth', 1)
            t = {'I = \infty ','MIC = 1.0 '};
            
            %text(title_x , title_y, 'Increasing noise', 'fontsize', title_font_size)
            
        case 2,
            fill(.25*[0 1  1  0], .25*[0 0 1 1], dense_color, 'linestyle', 'none')
            hold on
            fill(.25+.25*[0 1  1  0], .25+.25*[0 0 1 1], dense_color , 'linestyle', 'none')
            fill(.5+.25*[0 1  1  0], .5+.25*[0 0 1 1], dense_color , 'linestyle', 'none')
            fill(.75+.25*[0 1  1  0], .75+.25*[0 0 1 1], dense_color , 'linestyle', 'none')
            t = {'I = 2.0 ','MIC = 1.0 '};
            
        case 3,
            fill([0 .5  .5  0], [0 0 .5 .5], sparse_color, 'linestyle', 'none')
            hold on
            fill(.5+[0 .5  .5  0], .5+[0 0 .5 .5], sparse_color, 'linestyle', 'none')
            t = {'I = 1.0 ','MIC = 1.0 '};
            
        case 4,
            fill(.75+.25*[0 1  1  0], .75+.25*[0 0 1 1], dense_color, 'linestyle', 'none')
            hold on
            fill(.5+.25*[0 1  1  0], .5+.25*[0 0 1 1], dense_color , 'linestyle', 'none')
            fill(.5*[0 1  1  0], .5*[0 0 1 1], sparse_color, 'linestyle', 'none')
            t = {'I = 1.5 ','MIC = 1.0 '};
            
            %text(title_x , title_y, 'Reparameterization invariance', 'fontsize', title_font_size)
            
        case 5,
            fill(.25*[0 1  1  0], .25*[0 0 1 1], dense_color, 'linestyle', 'none')
            hold on
            fill(.25+.5*[0 1  1  0], .25+.5*[0 0 1 1], sparse_color, 'linestyle', 'none')
            fill(.75+.25*[0 1  1  0], .75+.25*[0 0 1 1], dense_color , 'linestyle', 'none')
            t = {'I = 1.5 ','MIC = 0.95 '};
            
        case 6,
            fill(.25*[0 1  1  0], .25*[0 0 1 1], sparse_color, 'linestyle', 'none')
            hold on
            fill(.5+.25*[0 1  1  0], .25*[0 0 1 1], sparse_color, 'linestyle', 'none')
            fill(.25*[0 1  1  0], .5+.25*[0 0 1 1], sparse_color, 'linestyle', 'none')
            fill(.5+.25*[0 1  1  0], .5+.25*[0 0 1 1], sparse_color, 'linestyle', 'none')
            fill(.25+.25*[0 1  1  0], .25+.25*[0 0 1 1], dense_color, 'linestyle', 'none')
            fill(.75+.25*[0 1  1  0], .75+.25*[0 0 1 1], dense_color , 'linestyle', 'none')
            t = {'I = 1.5 ','MIC = 0.75 '};
            
        case 7,
            fill(.25*[0 1  1  0], .5*[0 0 1 1], sparse_color, 'linestyle', 'none')
            hold on
            fill(.25+.5*[0 1  1  0], .5+.5*[0 0 1 1], sparse_color, 'linestyle', 'none')
            fill(.75+.25*[0 1  1  0], .5*[0 0 1 1], sparse_color, 'linestyle', 'none')
            t = {'I = 1.0 ',' MIC = 1.0 '};
            x_label = 'X';
            y_label = 'W';
            
            %text(title_x , title_y, 'Data Processing Inequality', 'fontsize', title_font_size)
            
        case 8,
            fill(.25*[0 1  1  0], .25*[0 0 1 1], dense_color, 'linestyle', 'none')
            hold on
            fill(.25+.5*[0 1  1  0], .25+.5*[0 0 1 1], sparse_color, 'linestyle', 'none')
            fill(.75+.25*[0 1  1  0], .75+.25*[0 0 1 1], dense_color , 'linestyle', 'none')
            t = {'I = 1.5 ', 'MIC = 0.95 '};
            x_label = 'Y';
            y_label = 'X';
            
        case 9,
            fill(.5*[0 0 1 1], .25*[0 1  1  0],  sparse_color, 'linestyle', 'none')
            hold on
            fill(.5+.5*[0 0 1 1], .25+.5*[0 1  1  0],  sparse_color, 'linestyle', 'none')
            fill(.5*[0 0 1 1], .75+.25*[0 1  1  0],  sparse_color, 'linestyle', 'none')
            t = {'I = 1.0 ', 'MIC = 1.0 '};
            x_label = 'Z';
            y_label = 'Y';
            
        case 10,
            fill([0 .5  .5  0], [0 0 .5 .5], sparse_color, 'linestyle', 'none')
            hold on
            fill(.5+[0 .5  .5  0], .5+[0 0 .5 .5], sparse_color, 'linestyle', 'none')
            t = {'I = 1.0 ','MIC = 1.0 '};
            x_label = 'Z';
            y_label = 'W';
            
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
saveas(gcf, 'figures/fig2.eps', 'epsc')