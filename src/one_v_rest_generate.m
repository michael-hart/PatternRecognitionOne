% For our different setups
if ispc
    addpath('D:\Git\libsvm\windows');
end

if ismac
    addpath('/Users/acrisne/git/patternone/misc/libsvm/matlab');
end

% First step is to load the data
clear

svmtrainpref = '-t 0 -s 0 -q -c 1 -e 0.001';

res_path = get_res_path();
load(strjoin({res_path 'partitioned.mat'}, filesep));
load(strjoin({res_path 'atapca.mat'}, filesep));

% Scale raw data
training_scaled = normc(training);
test_scaled = normc(test);

% Scale face data
faces_coeff_training_scaled = normr(faces_coeff_training);
faces_coeff_test_scaled = normr(faces_coeff_test);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Train SVMs (raw unscaled, raw scaled, pca unscaled, pca scaled)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
one_v_rest_svm_raw = one_v_rest_svm(training', l_train, svmtrainpref);
one_v_rest_svm_raw_scaled = one_v_rest_svm(training_scaled', l_train, svmtrainpref);
one_v_rest_svm_pca = one_v_rest_svm(faces_coeff_training, l_train, svmtrainpref);
one_v_rest_svm_pca_scaled = one_v_rest_svm(faces_coeff_training_scaled, l_train, svmtrainpref);

% Save
save(strjoin({res_path 'one_v_rest.mat'}, filesep), 'faces_coeff_training_scaled', 'training_scaled', 'test_scaled', 'faces_coeff_test_scaled','one_v_rest_svm_raw', 'one_v_rest_svm_raw_scaled', 'one_v_rest_svm_pca', 'one_v_rest_svm_pca_scaled');