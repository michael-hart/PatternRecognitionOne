function [ training, test, l_train, l_test ] = load_partitioned()
%LOAD_DATA Produce path relative to current file and load data from it
%   Works anywhere on the system, but expects face.mat in 
%   ..\res\partitioned.mat

% Assign default variables
training = [];
test = [];
l_train = [];
l_test = [];

% Get resource path
res_path = get_res_path();

% Define matrix resource path
data_path = strjoin({res_path 'partitioned.mat'}, filesep);

% Load data and exit
load(data_path);

end

