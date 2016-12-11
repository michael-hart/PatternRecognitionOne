% For Michael, add path to LibSVM
addpath('D:\Git\libsvm\windows');

% First step is to load the data
res_path = get_res_path();
load(strjoin({res_path 'partitioned.mat'}, filesep));

% Figure out how many classes there are in the data, M
M = max(l_train);
M = 3;

% For now, forget preallocation, because it's so fast compared to SVM
% training

for class=1:M
    clear one_vs_one
    correct = get_class(l_train, training, class);
    if class < M
        incorrect = get_class(l_train, training, M);
    else
        incorrect = get_class(l_train, training, M-1);
    end
    one_vs_one(M-1) = svmtrain(correct, incorrect);
    current = 1;
    for foe=1:M-1
        if class==foe
            continue
        end
        if class==M && foe == M-1
            % Already calculated
            continue
        end
        correct = get_class(l_train, training, class);
        incorrect = get_class(l_train, training, foe);
        one_vs_one(current) = svmtrain(correct, incorrect);
        current = current + 1;
    end
    one_vs_one_svm(class) = one_vs_one;
end

% Save calculated SVM list to prevent recalculating!
save(strjoin({res_path 'one_vs_one.mat'}, filesep), 'one_vs_one_svm');
