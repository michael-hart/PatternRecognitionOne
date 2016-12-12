% Load required data from task 2
clear
res_path = get_res_path();
load(strjoin({res_path 'pca.mat'}, filesep));
load(strjoin({res_path 'partitioned.mat'}, filesep));
load(strjoin({res_path 'atapca.mat'}, filesep));
load(strjoin({res_path 'nn.mat'}, filesep));

plot(1:length(correct_vec), correct_vec, 1:length(incorrect_vec), incorrect_vec);