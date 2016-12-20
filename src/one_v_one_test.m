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
[~, ~, ~, answers1] = one_v_one_svm_test(one_v_one_svm_raw, test', svmtestpref);
[wrong1, ~, ~, ~] = results(answers1, l_test', 'Unscaled Raw Data', '1v1_raw_unscaled');

disp('RAW WITH TESTING SCALED')
[classes, decision_values, votes, answers2] = one_v_one_svm_test(one_v_one_svm_raw_scaled, test_scaled', svmtestpref);
[wrong2, ~, ~, ~] = results(answers2, l_test', 'Scaled Raw Data', '1v1_raw_scaled');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('PCA WITH TESTING UNSCALED')
[~, ~, ~, answers3] = one_v_one_svm_test(one_v_one_svm_pca, faces_coeff_test, svmtestpref);
[wrong3, ~, ~, ~] = results(answers3, l_test', 'Unscaled PCA Data', '1v1_pca_unscaled');


disp('PCA WITH TESTING SCALED')
[~, ~, ~, answers4] = one_v_one_svm_test(one_v_one_svm_pca_scaled, faces_coeff_test_scaled, svmtestpref);
[wrong4, ~, ~, ~] = results(answers4, l_test', 'Scaled PCA Data', '1v1_pca_scaled');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


