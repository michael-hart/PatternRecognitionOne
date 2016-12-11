% Either use raw x OR PCA coefficients. Try both and compare.

% Load raw data and 1vsRest SVMs
clear
res_path = get_res_path();
load(strjoin({res_path 'partitioned.mat'}, filesep));
load(strjoin({res_path 'one_vs_rest.mat'}, filesep));

% For Michael, add path to LibSVM
addpath('D:\Git\libsvm\windows');

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
%     disp(['Correct class is ' num2str(l_I) ...
%           ' and guessed ' num2str(index)]);
end

correct = sum(correct_guesses);
incorrect = N - correct;
percentage = 100 * correct/N;
disp(['Guessed ' num2str(correct) ' correctly and ' num2str(incorrect) ...
      ' incorrectly; Success rate is ' num2str(percentage) '%.']);