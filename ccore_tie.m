% Deal with ties in ccore

function score = ccore_tie(x,y,ntry)
n = length(x);
maxc = ccore0(1:n,1:n,200);
minc = minfc(n);

ccor_ave = 0;
% x has ties
if length(unique(x))<n
    delta_x = min(diff(sort(unique(x))));
    for i = 1:ntry
        % small perturbation
        newx = x+(rand(1,n)-0.5)*delta_x/5;
        % y has ties
        if length(unique(y)) < n
            delta_y = min(diff(sort(unique(y))));
            newy = y+(rand(1,n)-0.5)*delta_y/5;
        % y has no ties
        else
            newy = y;
        end
        ccor_ave = ccor_ave + ccore0(newx,newy,200)/ntry;
    end
% x has no tie, y has ties
elseif length(unique(y)) < n
        delta_y = min(diff(sort(unique(y))));
        for i = 1:ntry
            newy = y+(rand(1,n)-0.5)*delta_y/5;
            ccor_ave = ccor_ave + ccore0(x,newy,200)/ntry;
        end
% x has no tie, y has no tie
else
    ccor_ave = ccore0(x,y,200);
end

score = (ccor_ave-minc)/(maxc-minc);

end

% This script translates two functions 'ccore0.p' and 'ccore0' from 
% R code in 'ccore.R' into MATLAB code
function [s2,s1] = ccore0(x,y,m)
% Parameters
% ----------
% x: observations of the first random variable
% y: observations of the second random variable
% m: the number of observations
% 
% Returns
% -------
% s1: output of ccore0.p in ccore.R
% s2: output of ccore0 in ccore.R

% the number of bins
m = 200;

% the number of observations
n = length(x);

% get the ranks of each element in the vector
u = tiedrank(x);
v = tiedrank(y);
u = u/(n+1);
v = v/(n+1);

% bandwidth of u and v
h = 0.25*n^(-1/4);
l = 0.25*n^(-1/4);

% Calculating the density on a m by m grid
A = zeros(m,m);
pos = (1:m)/(m+1);

for k = 1:n
    ind_u = (abs(u(k)-pos) <= h);
    ind_v = (abs(v(k)-pos) <= l);
    A(ind_u,ind_v) = A(ind_u,ind_v)+1;
end
A = A/(n*h*l*4);

% output of ccore0.p in ccore.R
s1 = mean(mean(A.*((1-A)>=0)));
% output of ccore0 in ccore.R
s2 = sum(sum(abs(A-1)))/(2*m^2);

end

% ======================================================================
% This function translate function 'minfc.p' in 'ccore.R' from R code to
% MATLAB code
% NOTE: this function calls ccore0.m
function s3 = minfc(n)

bw = 0.25*n^(-1/4);
h = bw;
k = ceil(2*h*(n+1));
x0 = floor(n/k);
xin = 1:n;
yin = [];
for i = 1:k
    yin = [yin,i+k*(0:x0)];
end
yin = yin(yin<=n);
s3 = ccore0(xin,yin,200);

end
