% This script load Physiochemical Properties dataset

load CASP

data = CASP(:,2:10);
label_true = CASP(:,1);
clear CASP
