% This function compute HSNIC between two random variables
% Hilbert-Schmidt Normalized Information Criterion

function val_hsnic = compute_HSNIC(K,L,eps)

% Number of Samples
n = size(K,1);

% centering matrix
H = eye(n)-1/n*ones(n);

% center two kernel matrices
K_cent = H*K*H;
L_cent = H*L*H;

val_hsnic = trace(K_cent*inv(K_cent+eps*n*eye(n))*...
    L_cent*inv(L_cent+eps*n*eye(n)));

end