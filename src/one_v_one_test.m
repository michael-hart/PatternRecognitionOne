% Do Task 3 using 1vsRest SVMs
clear
res_path = get_res_path();
load(strjoin({res_path 'partitioned.mat'}, filesep));
load(strjoin({res_path 'atapca.mat'}, filesep));

% For our different setups
if ispc
    addpath('D:\Git\libsvm\windows');
end

if ismac
    addpath('/Users/acrisne/git/patternone/misc/libsvm/matlab');
end

% Added scaling to test

% Load one vs rest data
load(strjoin({res_path 'one_v_one.mat'}, filesep));
svmtestpref = '-q';

disp('RAW WITH TESTING UNSCALED')
[~, ~, ~, answers1] = one_v_one_svm_test(one_v_one_svm_raw, training', svmtestpref);
[wrong1, ~, ~] = results(answers1, l_train', 'One-v-One Raw Data Unscaled', 'onevoneraw');

disp('RAW WITH TESTING SCALED')
[classes, decision_values, votes, answers2] = one_v_one_svm_test(one_v_one_svm_raw_scaled, training_scaled', svmtestpref);
[wrong2, ~, ~] = results(answers2, l_train', 'One-v-One Raw Data Scaled', 'onevonerawscaled');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('PCA WITH TESTING UNSCALED')
[~, ~, ~, answers3] = one_v_one_svm_test(one_v_one_svm_pca, faces_coeff_training, svmtestpref);
[wrong3, ~, ~] = results(answers3, l_train', 'One-v-One PCA Data Unscaled', 'onevonepca');


disp('PCA WITH TESTING SCALED')
[~, ~, ~, answers4] = one_v_one_svm_test(one_v_one_svm_pca_scaled, faces_coeff_training_scaled, svmtestpref);
[wrong4, ~, ~] = results(answers4, l_train', 'One-v-One PCA Data Scaled', 'onevonepcascaled');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


