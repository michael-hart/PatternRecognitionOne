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
load(strjoin({res_path 'one_v_rest.mat'}, filesep));
svmtestpref = '-q';

disp('RAW WITH TESTING UNSCALED')
[~, ~, ~, answers1] = one_v_rest_svm_test(one_v_rest_svm_raw, test', l_test', svmtestpref);
results(answers1, l_test', 'RAW WITH TESTING UNSCALED', 'svm_raw');

disp('RAW WITH TESTING SCALED')
[~, ~, ~, answers2] = one_v_rest_svm_test(one_v_rest_svm_raw_scaled, test_scaled', l_test', svmtestpref);
results(answers2, l_test', 'RAW WITH TESTING SCALED', 'svm_raw_scaled');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp('PCA WITH TESTING UNSCALED')
[~, ~, ~, answers3] = one_v_rest_svm_test(one_v_rest_svm_pca, faces_coeff_test, l_test', svmtestpref);
results(answers3, l_test', 'PCA WITH TESTING UNSCALED', 'svm_pca');


disp('PCA WITH TESTING SCALED')
[~, ~, ~, answers4] = one_v_rest_svm_test(one_v_rest_svm_pca_scaled, faces_coeff_test_scaled, l_test', svmtestpref);
results(answers4, l_test', 'PCA WITH TESTING SCALED', 'svm_pca_scaled');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


