function [ X, l ] = load_data()
%LOAD_DATA Produce path relative to current file and load data from it
%   Works anywhere on the system, but expects face.mat in ..\res\face.mat

% Assign default X, l
X = [];
l = [];

% Get resource path
res_path = get_res_path();

% Define matrix resource path
data_path = strjoin({res_path 'face.mat'}, filesep);

% Load data and exit
load(data_path);

end
