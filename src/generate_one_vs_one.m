% For Michael, add path to LibSVM
addpath('D:\Git\libsvm\windows');

% First step is to load the data
res_path = get_res_path();
load(strjoin({res_path 'partitioned.mat'}, filesep));

% Figure out how many classes there are in the data, M
M = max(l_train);

% For now, forget preallocation, because it's so fast compared to SVM
% training

clear one_vs_one_svm

% Preallocate for efficiency
correct = get_class(l_train, training, M);
incorrect = get_class(l_train, training, M-1);
one_vs_one_svm(M*(M-1)) = svmtrain(correct, incorrect);
current = 1;

for class=1:M
    for foe=1:M
        if class==foe || current == M*(M-1)
            % Either it's the same class or it's already been done
            continue
        end
        correct = get_class(l_train, training, class);
        incorrect = get_class(l_train, training, foe);
        one_vs_one_svm(current) = svmtrain(correct, incorrect);
        current = current + 1;
    end
end

% Save calculated SVM list to prevent recalculating!
save(strjoin({res_path 'one_vs_one.mat'}, filesep), 'one_vs_one_svm', ...
                                                    '-v7.3');
