function [ out_classes, decision_values, votes, decision ] = one_v_one_svm_test( svm_list, data, svmtestpref )
% ONE_V_ONE_SVM_TEST:  Tests data according to various 1v1 SVMs
% svm is SVMs, in matrix. Positive class row number, negative column number
% data is testing data (instance per row)
% labels is associated labels
% svmtestpref is for arguments

    % Dimensions
    num_svms_row = size(svm_list, 1);
    num_svms_col = size(svm_list, 2);
    num_tests = size(data, 1);

    % Storage for results
    % Each row and column match corresponding SVM
    % "Depth", aka 3rd dimension is which testing picture
    out_classes = zeros(num_svms_row, num_svms_col, num_tests);
    votes = zeros(num_svms_row, num_svms_col, num_tests);
    decision_values = zeros(num_svms_row, num_svms_col, num_tests);

    % Empty test labels
    test_labels = zeros(num_tests, 1);

    for friend = 1:num_svms_row
        for foe = friend+1:num_svms_col
            % Obtain SVM
            svm = svm_list(friend, foe);

            % Run test
            [out_l, ~, dec_l] = svmpredict(test_labels, data, svm, svmtestpref);

            % Storage
            % Output decision. (x,y) refers to SVM used. z is testing case.
            out_classes(friend, foe, :) = out_l;
            % Decision values used
            decision_values(friend, foe, :) = dec_l;
            % Acquire vote for either class (1) or foe (-1).
            vote = (out_l == 1) * friend + (out_l == -1) * foe;
            votes(friend, foe, :) = vote;
        end
    end

    % No choice but to loop through each "layer"
    decision = zeros(num_tests, 1);
    for test_case = 1:num_tests
        % Acquire layer
        working_matrix = votes(:, :, test_case);
        % Votes per class
%         class_votes = [(1:num_svms_col)', zeros(num_svms_col, 1)];
        class_votes = zeros(num_svms_col, 1);
        
        % Obtain number of each class appearing, again loop, no choice?
        for count = 1:length(class_votes)
            class_votes(count) = nnz(working_matrix == count);
        end
        
        % Maximum
        [~, index] = max(class_votes);
        decision(test_case) = index;
    end

end
