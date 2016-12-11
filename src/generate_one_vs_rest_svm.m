% For Michael, add path to LibSVM
addpath('D:\Git\libsvm\windows');

% First step is to load the data
res_path = get_res_path();
load(strjoin({res_path 'partitioned.mat'}, filesep));

% Figure out how many classes there are in the data, M
M = max(l_train);

% Train LAST class to preallocate memory
[ current, rest ] = get_class_and_rest(l_train, training, M);
one_vs_rest_svm(M) = svmtrain(current, rest);

% Iterate over rest of classes and train an SVM of 1 vs rest for each
for i=1:M-1
    [ current, rest ] = get_class_and_rest(l_train, training, i);
    one_vs_rest_svm(i) = svmtrain(current, rest);
end

% Save calculated SVM list to prevent recalculating!
save(strjoin({res_path 'one_vs_rest.mat'}, filesep), 'one_vs_rest_svm');
