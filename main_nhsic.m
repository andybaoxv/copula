% This script implements experiments in "Scale Invariant Conditional ...
% Dependence Measures"

clear all, close all, clc

n_samples = 200;
X1 = rand(n_samples*3,1)*4*pi;
V1 = rand(n_samples,1);
V2 = rand(n_samples,1);
V3 = rand(n_samples,1);
X2 = [V1;V2;V3];

Y = 1000*tanh(X1);

r1 = ccore_tie(X1,Y);
r2 = ccore_tie(X2,Y);

