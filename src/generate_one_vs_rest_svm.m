% For Michael, add path to LibSVM
addpath('D:\Git\libsvm\windows');

% First step is to load the data
clear
res_path = get_res_path();
load(strjoin({res_path 'partitioned.mat'}, filesep));

% Figure out how many classes there are in the data, M
M = max(l_train);
N = size(l_train, 2);

% Train LAST class to preallocate memory
svm_labels = ones(N, 1);
for j=1:N
    if l_train(j) ~= M
        svm_labels(j) = -1;
    end
end
one_vs_rest_svm(M) = svmtrain(svm_labels, training', '-t 0');

% Train remaining classes using the same method
for i=1:M-1
    svm_labels = ones(N, 1);
    for j=1:N
        if l_train(j) ~= i
            svm_labels(j) = -1;
        end
    end
    one_vs_rest_svm(i) = svmtrain(svm_labels, training', '-t 0');
end

% Save calculated SVM list to prevent recalculating!
save(strjoin({res_path 'one_vs_rest.mat'}, filesep), 'one_vs_rest_svm');
