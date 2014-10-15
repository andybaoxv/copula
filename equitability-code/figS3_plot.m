clear all
close all
clc

width = 17.8; % 1 column; render at 2x
height = 10;
font_size = 7;
letter_size = 10;
title_font_size = 8;
figure('paperpositionmode', 'auto', 'units', 'centimeters', 'position', [0 0 width height])

% Evaluate functions at N points along the curve
N = 300;
funcs = helper_define_functions([0],N);
num_funcs = size(funcs,1);
rho = [];
labels = {};

% Set colormap
color = helper_simulation_colormap();
num_colors = size(color,1);

% Plot each funciton labeled with monotonicity
for m=1:num_funcs   
    subplot(3,7,m)

    % Get x and f(x)
    name = funcs{m,4};
    x = funcs{m,5};
    y = funcs{m,6};
    rho_sq = funcs{m,8};
    
    % Print monotonicity
    label = sprintf('%0.2f', rho_sq); 
    disp([num2str(rho_sq) ' == monotonicity of ' funcs{m,4}])
    
    % Assign color to function
    c_index = ceil(rho_sq*num_colors);
    
    % Plot function
    plot(x,y,'-', 'color', color(c_index,:), 'linewidth', 1)
    
    % Adjust display settings
    dx = max(x)-min(x);
    xl = [min(x) - .1*dx, max(x) + .1*dx];
    dy = max(y)-min(y);
    yl = [min(y) - .1*dy, max(y) + .1*dy];
    set(gca, 'box', 'on', 'xtick', [], 'ytick', [], 'linewidth', 0.5, 'fontsize', font_size)
    set(gca, 'xlim', xl, 'ylim', yl)
    title({name,[label '  ']})
    axis square
    axis off
end

% Save figure
saveas(gcf, 'figures/figS3.eps', 'epsc')