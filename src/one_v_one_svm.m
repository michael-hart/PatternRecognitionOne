function [ svms ] = one_v_one_svm( data, labels, svmtrainpref)
% ONE_V_ONE_SVM Produces an M x M matrix, upper triangular, with the SVMs
% Row number is class, column number is foe class.
% Training data is instance per column

    % Figure out how many classes there are in the data
    M = max(labels);

    % Matrix has positive class as row number, negative class as column
    % Start from bottom row to start (M-1, until 1)
    for friend = (M-1):-1:1
        % Right most column, M until class+1 (i.e. M, M-1, ... 2)
        for foe = M:-1:(friend + 1)

            % Obtain data for classes in question, and sizes
            correct = get_class(labels, data, friend);
            incorrect = get_class(labels, data, foe);
            size_correct = size(correct, 2);
            size_incorrect = size(incorrect, 2);

            % Construct training data
            training_data = [correct, incorrect];
            training_labels = [ones(size_correct, 1); ones(size_incorrect, 1) * -1];

            % Actually train
            svms(friend, foe) = svmtrain(training_labels, training_data', svmtrainpref);
        end
    end

end
