% Load hepatitis dataset

% Load the data into a file named hepatitis.txt:
s = urlread(['http://archive.ics.uci.edu/ml/' ...
  'machine-learning-databases/hepatitis/hepatitis.data']);
fid = fopen('hepatitis.txt','w');
fwrite(fid,s);
fclose(fid);

% Load the data hepatitis.txt into a table, with variable names describing 
% the fields in the data:
VarNames = {'die_or_live' 'age' 'sex' 'steroid' 'antivirals' 'fatigue' ...
    'malaise' 'anorexia' 'liver_big' 'liver_firm' 'spleen_palpable' ...
    'spiders' 'ascites' 'varices' 'bilirubin' 'alk_phosphate' 'sgot' ...
    'albumin' 'protime' 'histology'};
Tbl = readtable('hepatitis.txt','Delimiter',',',....
    'ReadVariableNames',false,'TreatAsEmpty','?',...
    'Format','%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f%f');
Tbl.Properties.VariableNames = VarNames;

% Convert the data in the table to the format for ensembles: a numeric matrix
% of predictors, and a cell array with outcome names: 'Die' or 'Live'. 
% The first variable in the table contains the outcomes.
X = table2array(Tbl(:,2:end));
ClassNames = {'Die' 'Live'};
Y = ClassNames(Tbl.die_or_live);