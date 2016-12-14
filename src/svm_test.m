function [ out_classes, decision_values, acc_total, max_index, correct, incorrect, indices ] = svm_test( svm_list, data, labels, svmtestpref )
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
    
    % Actually useful stuff. Select best guess per row.
    % Most likely class per picture.
    
    [~, max_index] = max(decision_values, [], 2);
    incorrect_vec = (max_index ~= labels);
    incorrect = sum(incorrect_vec);
    correct = length(incorrect_vec) - incorrect;
    indices = find(incorrect_vec);
end

