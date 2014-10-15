% This function translate function 'ccore.p' in 'ccore.R' from R code to
% MATLAB code
% NOTE: this function calls functions 'ccore0.m' and 'minfc.m'
function s4 = ccore(xin,yin)
% Parameters
% ----------
% xin: observations for random variable X
% yin: observations for random variable Y
%
% Returns
% -------
% s4: Copula correlation coefficient between random variables X, Y
% according to their observations in xin, yin

n = length(xin);
maxc = ccore0(1:n,1:n,200);
minc = minfc(n);
s4 = (ccore0(xin,yin,200)-minc)/(maxc-minc);

end

% =======================================================================

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
s1 = mean(mean(max(1-A,0)));
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