function [ training, test, l ] = load_partitioned( input_args )
%LOAD_DATA Produce path relative to current file and load data from it
%   Works anywhere on the system, but expects face.mat in 
%   ..\res\partitioned.mat

% Assign default variables
training_data = [];
test_data = [];
l = [];

% Get resource path
res_path = get_res_path();

% Define matrix resource path
data_path = strjoin({res_path 'partitioned.mat'}, filesep);

% Load data and exit
load(data_path);
training = training_data;
test = test_data;

end

