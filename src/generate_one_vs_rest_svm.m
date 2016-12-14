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

scaled_training = (training - min(min(training)))/(max(max(training)) - min(min(training)));
scaled_test = (test - min(min(test)))/(max(max(test)) - min(min(test)));

% Figure out how many classes there are in the data, M
M = max(l_train);
N = size(l_train, 2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Train SVMs with Raw
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Train LAST class to preallocate memory
svm_labels = ones(N, 1);
for j=1:N
    if l_train(j) ~= M
        svm_labels(j) = -1;
    end
end
one_vs_rest_svm(M) = svmtrain(svm_labels, training', svmtrainpref);

% Train remaining classes using the same method
for i=1:M-1
    svm_labels = ones(N, 1);
    for j=1:N
        if l_train(j) ~= i
            svm_labels(j) = -1;
        end
    end
    one_vs_rest_svm(i) = svmtrain(svm_labels, training', svmtrainpref);
end

% Train LAST class to preallocate memory
svm_labels = ones(N, 1);
for j=1:N
    if l_train(j) ~= M
        svm_labels(j) = -1;
    end
end
one_vs_rest_svm_scaled(M) = svmtrain(svm_labels, scaled_training', svmtrainpref);

% Train remaining classes using the same method
for i=1:M-1
    svm_labels = ones(N, 1);
    for j=1:N
        if l_train(j) ~= i
            svm_labels(j) = -1;
        end
    end
    one_vs_rest_svm_scaled(i) = svmtrain(svm_labels, scaled_training', svmtrainpref);
end

% Save calculated SVM list to prevent recalculating!
save(strjoin({res_path 'one_vs_rest.mat'}, filesep), 'one_vs_rest_svm', 'scaled_training', 'scaled_test', 'one_vs_rest_svm_scaled');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Train SVMs with PCA Coefficients
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Clear any existing SVMs
clear one_vs_rest_svm_pca

scaled_faces_training = (faces_coeff_training - min(min(faces_coeff_training)))/(max(max(faces_coeff_training)) - min(min(faces_coeff_training)));
scaled_faces_test = (faces_coeff_test - min(min(faces_coeff_test)))/(max(max(faces_coeff_test)) - min(min(faces_coeff_test)));

% Train LAST class to preallocate memory
svm_labels_pca= ones(N, 1);
for j=1:N
    if l_train(j) ~= M
        svm_labels_pca(j) = -1;
    end
end
one_vs_rest_svm_pca(M) = svmtrain(svm_labels_pca, faces_coeff_training, ...
                                  svmtrainpref);

% Train remaining classes using the same method
for i=1:M-1
    svm_labels_pca = ones(N, 1);
    for j=1:N
        if l_train(j) ~= i
            svm_labels_pca(j) = -1;
        end
    end
    one_vs_rest_svm_pca(i) = svmtrain(svm_labels_pca, ...
                                      faces_coeff_training, svmtrainpref);
end

% Train LAST class to preallocate memory
svm_labels_pca= ones(N, 1);
for j=1:N
    if l_train(j) ~= M
        svm_labels_pca(j) = -1;
    end
end
one_vs_rest_svm_pca_scaled(M) = svmtrain(svm_labels_pca, scaled_faces_training, ...
                                  svmtrainpref);
[out_l] = svmpredict(svm_labels_pca, scaled_faces_training, ...
                            one_vs_rest_svm_pca_scaled(M));
disp(out_l == svm_labels_pca);
% Train remaining classes using the same method
for i=1:M-1
    svm_labels_pca = ones(N, 1);
    for j=1:N
        if l_train(j) ~= i
            svm_labels_pca(j) = -1;
        end
    end
    one_vs_rest_svm_pca_scaled(i) = svmtrain(svm_labels_pca, ...
                                      scaled_faces_training, svmtrainpref);
end

% Save calculated SVM list to prevent recalculating!
save(strjoin({res_path 'one_vs_rest_pca.mat'}, filesep), ...
             'one_vs_rest_svm_pca', 'scaled_faces_training', 'scaled_faces_test', 'one_vs_rest_svm_pca_scaled');
