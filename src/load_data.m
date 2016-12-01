function [ X I ] = load_data()
%LOAD_DATA Produce path relative to current file and load data from it
%   Works anywhere on the system, but expects face.mat in ..\res\face.mat


current_path = mfilename('fullpath');
split_path = strsplit(current_path, filesep);
root_path = split_path(1:end-2)';
res_path = cat(1, root_path, 'res');
res_path = strjoin(res_path, filesep);
data_path = strjoin({res_path 'face.mat'}, filesep);
load(data_path);


end

