% For Michael, add path to LibSVM
addpath('D:\Git\libsvm\windows');

% First step is to load the data
res_path = get_res_path();
load(strjoin({res_path 'partitioned.mat'}, filesep));

% Figure out how many classes there are in the data, M
M = max(l_train);
N = size(training, 2);

% Clear previous SVM, as we allocate it by assigning to it
clear one_vs_one_svm

% Preallocate for efficiency
correct = get_class(l_train, training, M);
incorrect = get_class(l_train, training, M-1);
train_data = horzcat(correct, incorrect);
train_labels = horzcat(ones(1, size(correct, 2)), ...
                       ones(1, size(incorrect, 2)) .* -1);
one_vs_one_svm(M*(M-1)) = svmtrain(train_labels', train_data', '-t 0');

current = 1;

for class=1:M
    disp(['Creating all SVMs for class ' num2str(class)]);
    for foe=1:M
        if class==foe || current == M*(M-1)
            % Either it's the same class or it's already been done
            continue
        end
        correct = get_class(l_train, training, class);
        incorrect = get_class(l_train, training, foe);
        train_data = horzcat(correct, incorrect);
        train_labels = horzcat(ones(1, size(correct, 2)), ...
                               ones(1, size(incorrect, 2)) .* -1);
        one_vs_one_svm(current) = svmtrain(train_labels', train_data', ...
                                           '-t 0');
        current = current + 1;
    end
end

% Save calculated SVM list to prevent recalculating!
save(strjoin({res_path 'one_vs_one.mat'}, filesep), 'one_vs_one_svm');
