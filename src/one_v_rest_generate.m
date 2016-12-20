% For our different setups
if ispc
    addpath('D:\Git\libsvm\windows');
end

if ismac
    addpath('/Users/acrisne/git/patternone/misc/libsvm/matlab');
end

% First step is to load the data
clear

svmtrainpref = '-t 0 -s 0 -q';

res_path = get_res_path();
load(strjoin({res_path 'partitioned.mat'}, filesep));
load(strjoin({res_path 'atapca.mat'}, filesep));

% Scale raw data
N = size(training, 2);
raw_to_scale = horzcat(training, test);
raw_scaled = zscore(raw_to_scale, 0, 2);
training_scaled = raw_scaled(:, 1:N);
test_scaled = raw_scaled(:, N+1:size(raw_scaled, 2));

% Scale face data
pca_to_scale = vertcat(faces_coeff_training, faces_coeff_test);
pca_scaled = zscore(pca_to_scale, 0, 1);
faces_coeff_training_scaled = pca_scaled(1:N, :);
faces_coeff_test_scaled = pca_scaled(N+1:size(pca_scaled, 1), :);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Train SVMs (raw unscaled, raw scaled, pca unscaled, pca scaled)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
one_v_rest_svm_raw = one_v_rest_svm(training', l_train, svmtrainpref);
one_v_rest_svm_raw_scaled = one_v_rest_svm(training_scaled', l_train, svmtrainpref);
one_v_rest_svm_pca = one_v_rest_svm(faces_coeff_training, l_train, svmtrainpref);
one_v_rest_svm_pca_scaled = one_v_rest_svm(faces_coeff_training_scaled, l_train, svmtrainpref);

% Save
save(strjoin({res_path 'one_v_rest.mat'}, filesep), 'faces_coeff_training_scaled', 'training_scaled', 'test_scaled', 'faces_coeff_test_scaled','one_v_rest_svm_raw', 'one_v_rest_svm_raw_scaled', 'one_v_rest_svm_pca', 'one_v_rest_svm_pca_scaled');
