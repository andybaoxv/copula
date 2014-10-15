% This function compute HSIC given two kernel matrices

function val_hsic = compute_HSIC(mtr_sim_1,mtr_sim_2)
% Parameters
% -----------
% mtr_sim_1: matrix, shape(n_instances,n_instances)
%           similarity matrice for feature 1
% mtr_sim_2: matrix, shape(n_instances,n_instances)
%           similarity matrice for feature 2
% 
% Returns
% --------
% val_hsic: float
%           HSIC values between feature 1 and feature 2

% number of samples
n = size(mtr_sim_1,1);

% centering matrix
H = eye(n) - 1/n*ones(n);

val_hsic = 1/(n-1)^2 * trace(mtr_sim_1*H*mtr_sim_2*H);

end