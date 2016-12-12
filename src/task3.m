% Either use raw x OR PCA coefficients. Try both and compare.

% Load raw data and 1vsRest SVMs
clear
res_path = get_res_path();
load(strjoin({res_path 'partitioned.mat'}, filesep));

% For Michael, add path to LibSVM
addpath('D:\Git\libsvm\windows');

% Just create a boolean value of which to run
run_one_vs_rest = 0;
run_one_vs_one = 1;

if run_one_vs_rest > 0
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

if run_one_vs_one > 0
    % Load one vs one data
    load(strjoin({res_path 'one_vs_one.mat'}, filesep));

    % Global variables
    M = size(one_vs_one_svm, 2);
    real_M = ceil(sqrt(M));
    N = size(test, 2);

    % Work out guesses by allowing each SVM to "vote" for the class it
    % thinks the image belongs to
%     guesses = zeros(N, 1);
%     sum_votes = zeros(N, real_M);
%     for n=1:M
%         svm = one_vs_one_svm(n);
%         [out_l, acc, dec_l] = svmpredict(ones(N, 1), test', svm);
%         sum_votes(:,ceil(n/real_M)) = sum_votes(:,ceil(n/real_M)) + ...
%                                       (out_l+1)./2;
%     end
%     
%     % The guessed class is the index of the maximum of each row
%     for i=1:N
%         [val, guesses(i)] = max(sum_votes(i, :));
%     end
%     
%     % Compare with real labels to determine the number of correct guesses
%     correct = sum(guesses == l_test');
%     incorrect = N - correct;
%     percentage = 100 * correct/N;
%     disp(['Guessed ' num2str(correct) ' correctly and ' num2str(incorrect) ...
%           ' incorrectly; Success rate is ' num2str(percentage) '%.']);

    % Test each image in turn
    for n=1:N

        
        % Report number to user for progress
        disp(['Testing image ' num2str(n)]);

        % Variables in use during loop
        I = test(:, n);
        l_I = l_test(n);
        accuracies = zeros(1, real_M);
        
        % Generate test labels in [1, -1]
        test_labels = ones(N, 1);
        for i=1:N
            if l_test(i) ~= l_I
                test_labels(i) = -1;
            end
        end
        
        % Test image in all SVMs and record accuracy
        votes = 0;
        for i=1:M
            if mod(i, real_M) == 0
                accuracies(i/real_M) = votes;
                votes = 0;
            end
            svm = one_vs_one_svm(i);
            [out_l, acc, dec_l] = svmpredict(1, I', svm);
            votes = votes + (out_l(1)+1)/2;
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
