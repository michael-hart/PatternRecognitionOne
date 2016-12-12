% Do task 3 using 1vsRest SVMs
clear
res_path = get_res_path();
load(strjoin({res_path 'partitioned.mat'}, filesep));
load(strjoin({res_path 'atapca.mat'}, filesep));

% For Michael, add path to LibSVM
addpath('D:\Git\libsvm\windows');

% Use raw or pca data
use_raw = 0;
use_pca = 1;

if use_raw > 0

    % Load one vs rest data
    load(strjoin({res_path 'one_vs_rest.mat'}, filesep));

    % Global variables
    M = size(one_vs_rest_svm, 2);
    N = size(test, 2);

    correct_guesses = zeros(N, 1);

    % Test each image in turn
    for n=1:N
        % Report number to user for progress
        disp(['Testing image ' num2str(n)]);

        % Variables in use during loop
        I = test(:, n);
        l_I = l_test(n);
        accuracies = zeros(1, M);

        % Generate test labels in [1, -1]
        test_labels = ones(N, 1);
        for i=1:N
            if l_test(i) ~= l_I
                test_labels(i) = -1;
            end
        end

        % Test image in all SVMs and record accuracy
        for i=1:M
            svm = one_vs_rest_svm(i);
            [out_l, acc, dec_l] = svmpredict(test_labels, test', svm);
            accuracies(i) = acc(1);
        end

        % Find most confident evaluation and record if correct
        [val, index] = max(accuracies);

        % Check if guess is correct
        if index == l_I
            correct_guesses(n) = 1;
        end

    end

    correct = sum(correct_guesses);
    incorrect = N - correct;
    percentage = 100 * correct/N;
    disp(['Guessed ' num2str(correct) ' correctly and ' num2str(incorrect) ...
          ' incorrectly; Success rate is ' num2str(percentage) '%.']);
end

if use_pca > 0
    
    % Load one vs rest data
    load(strjoin({res_path 'one_vs_rest_pca.mat'}, filesep));

    % Global variables
    M = size(one_vs_rest_svm_pca, 2);
    N = size(test, 2);

    correct_guesses = zeros(N, 1);

    % Test each image in turn
    for n=1:N
        % Report number to user for progress
        disp(['Testing image ' num2str(n)]);

        % Variables in use during loop
        I = faces_coeff_test(:, n);
        l_I = l_test(n);
        accuracies = zeros(1, M);

        % Generate test labels in [1, -1]
        test_labels = ones(N, 1);
        for i=1:N
            if l_test(i) ~= l_I
                test_labels(i) = -1;
            end
        end

        % Test image in all SVMs and record accuracy
        for i=1:M
            svm = one_vs_rest_svm_pca(i);
            [out_l, acc, dec_l] = svmpredict(test_labels, ...
                                             faces_coeff_test, svm);
            accuracies(i) = acc(1);
        end

        % Find most confident evaluation and record if correct
        [val, index] = max(accuracies);

        % Check if guess is correct
        if index == l_I
            correct_guesses(n) = 1;
        end

    end

    correct = sum(correct_guesses);
    incorrect = N - correct;
    percentage = 100 * correct/N;
    disp(['Guessed ' num2str(correct) ' correctly and ' num2str(incorrect) ...
          ' incorrectly; Success rate is ' num2str(percentage) '%.']);
end