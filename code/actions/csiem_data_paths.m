datapath = '/GIS_DATA/csiem-data-hub/';
marvldatapath = '/GIS_DATA/csiem-data-hub/marvl';

% I have written python code that searches for datapath and takes the first hit,
% This is to not also grab marvldatapath too
% my code requires '' quotes, if the quotes are changed to ""
% my code will break (/GIS_DATA/csiem-data-hub/csiem-data/code/import/GenericS3Bucket/ImportS3BucketIntoDavy.py)
% The dependance is in and only in the function GetCsiemDataPath()
