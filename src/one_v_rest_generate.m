% For our different setups
if ispc
    addpath('D:\Git\libsvm\windows');
end

if ismac
    addpath('/Users/acrisne/git/patternone/misc/libsvm/matlab');
end

% First step is to load the data
clear

svmtrainpref = '-t 0 -s 2 -q';

res_path = get_res_path();
load(strjoin({res_path 'partitioned.mat'}, filesep));
load(strjoin({res_path 'atapca.mat'}, filesep));

% Scale raw data
max_training = max(max(training));
min_training = min(min(training));
max_test = max(max(test));
min_test = min(min(test));

max_t = max(max_training, max_test);
min_t = min(min_training, min_test);

training_scaled = (training - min_t)/(max_t - min_t);
test_scaled = (test - min_t)/(max_t - min_t);

% Scale face data
max_face_training = max(max(faces_coeff_training));
min_face_training = min(min(faces_coeff_training));
max_face_test = max(max(faces_coeff_test));
min_face_test = min(min(faces_coeff_test));

max_f = max(max_face_training, max_face_test);
min_f = min(min_face_training, min_face_test);

faces_coeff_training_scaled = (faces_coeff_training - min_f)/(max_f - min_f);
faces_coeff_test_scaled = (faces_coeff_test - min_f)/(max_f - min_f);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Train SVMs with Raw
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
one_v_rest_svm_raw = multi_class_svm(training', l_train, svmtrainpref);
one_v_rest_svm_raw_scaled = multi_class_svm(training_scaled', l_train, svmtrainpref);
one_v_rest_svm_pca = multi_class_svm(faces_coeff_training, l_train, svmtrainpref);
one_v_rest_svm_pca_scaled = multi_class_svm(faces_coeff_training_scaled, l_train, svmtrainpref);

save(strjoin({res_path 'one_v_rest.mat'}, filesep), 'faces_coeff_training_scaled', 'training_scaled', 'test_scaled', 'faces_coeff_test_scaled','one_v_rest_svm_raw', 'one_v_rest_svm_raw_scaled', 'one_v_rest_svm_pca', 'one_v_rest_svm_pca_scaled');
