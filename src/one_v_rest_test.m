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

disp('RAW UNSCALED WITH TRAINING UNSCALED')
[correct, incorrect] = svm_test(one_v_rest_svm_raw, training', l_train', svmtestpref);

percentage = 100 * correct/(correct + incorrect);
disp(['Guessed ' num2str(correct) ' correctly and ' num2str(incorrect) ...
' incorrectly; Success rate is ' num2str(percentage) '%.']);

disp('RAW SCALED WITH TESTING UNSCALED')
[correct, incorrect] = svm_test(one_v_rest_svm_raw, test', l_test', svmtestpref);

percentage = 100 * correct/(correct + incorrect);
disp(['Guessed ' num2str(correct) ' correctly and ' num2str(incorrect) ...
' incorrectly; Success rate is ' num2str(percentage) '%.']);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% disp('PCA SCALED WITH TRAINING')
% [correct, incorrect] = svm_test(one_v_rest_svm_pca_scaled, faces_coeff_training, l_train', svmtestpref);
% 
% percentage = 100 * correct/(correct + incorrect);
% disp(['Guessed ' num2str(correct) ' correctly and ' num2str(incorrect) ...
% ' incorrectly; Success rate is ' num2str(percentage) '%.']);
% 
% disp('PCA SCALED WITH TESTING')
% [correct, incorrect] = svm_test(one_v_rest_svm_pca_scaled, faces_coeff_test_scaled, l_test', svmtestpref);
% 
% percentage = 100 * correct/(correct + incorrect);
% disp(['Guessed ' num2str(correct) ' correctly and ' num2str(incorrect) ...
% ' incorrectly; Success rate is ' num2str(percentage) '%.']);
