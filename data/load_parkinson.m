% load parkinson dataset

load parkinson

% column 5, 6 could be labels
label_true = parkinson(:,6);

data = parkinson(:,7:22);

clear parkinson