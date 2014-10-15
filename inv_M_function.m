% This function is the inverse of M_function

function x = inv_M_function(y)
    x1 = 0.25*y;
    x2 = -0.25*(y-2);
    x3 = 0.25*(y+2);
    x4 = -0.25*(y-4);
    
    % number of points
    n_samples = length(y);
    x = zeros(n_samples,1);
    tmp = [x1,x2,x3,x4];
    idx = randi([1,4],n_samples,1);
    for i = 1:n_samples
        x(i) = tmp(i,idx(i));
    end
end