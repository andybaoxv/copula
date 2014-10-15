% This function generate M function

function y = generate_M(x)
    idx_1 = (x>=0 & x<0.25);
    idx_2 = (x>=0.25 & x<0.50);
    idx_3 = (x>=0.50 & x<0.75);
    idx_4 = (x>=0.75 & x<1.00);
    
    N = length(x);
    y = zeros(N,1);
    y(idx_1) = 4*x(idx_1);
    y(idx_2) = -4*x(idx_2)+2;
    y(idx_3) = 4*x(idx_3)-2;
    y(idx_4) = -4*x(idx_4)+4;
end