function [ correct, incorrect ] = svm_test( svm_list, data, labels, svmtestpref )
% SVM_TEST:  Tests data according to various 1vR SVMs
% svm is SVMs
% data is testing data (instance per row)
% labels is associated labels
% svmtestpref is for arguments

    % Global variables
    num_svms = size(svm_list, 2);
    num_tests = size(data, 1);

    % Storage for results
    out_classes = zeros(num_tests, num_svms);
    decision_values = zeros(num_tests, num_svms);
    acc_total = zeros(3, num_svms);

    % For each SVM, put in all test cases
    for svm_n = 1:num_svms
        test_labels = 2 * (labels(:) == svm_n) - 1;
        svm = svm_list(svm_n);
        [out_l, acc , dec_l] = svmpredict(test_labels, data, svm, svmtestpref);

        % Storage
        % Output decision. Column n refers to nth SVM's decisions
        out_classes(:, svm_n) = out_l;
        % Decision values used
        decision_values(:, svm_n) = dec_l;
        % Accuracy values, just for fun.
        acc_total(:, svm_n) = acc;
    end

    % Each row of out_classes gives the 52 SVMs' outputs for that test pic
    % Either 1 for yes or -1 for no. Acquire only 1's, rest will be 0's
    out_class_yes = out_classes == 1;

    % Element-wise multiplications. Only 1 values' decision value will stay
    final_class = out_class_yes .* decision_values;

    % Maximum index is the class of highest likelihood
    [~, max_index] = max(final_class, [], 2);

    % Check back
    correct_vec = max_index == labels;
    correct = sum(correct_vec);
    incorrect = num_tests - correct;
end

