% Either use raw x OR PCA coefficients. Try both and compare.

% Load raw data and 1vsRest SVMs
clear
res_path = get_res_path();
load(strjoin({res_path 'partitioned.mat'}, filesep));

% For Michael, add path to LibSVM
addpath('D:\Git\libsvm\windows');

% Load one vs one data
load(strjoin({res_path 'one_vs_one.mat'}, filesep));

% Global variables
M = size(one_vs_one_svm, 2);
real_M = ceil(sqrt(2*M));
N = size(test, 2);

% Generate matrix of friend/foe for the SVMs
friend_foe = zeros(M, 2);
current = 1;
for i=1:real_M
    for j=i+1:real_M
        friend_foe(current, 1) = i;
        friend_foe(current, 2) = j;
        current = current + 1;
    end
end

% Work out guesses by allowing each SVM to "vote" for the class it
% thinks the image belongs to
guesses = zeros(N, 1);
sum_votes = zeros(N, real_M);
% n is SVM number
for n=1:M
    svm = one_vs_one_svm(n);
    friend = friend_foe(n, 1);
    foe = friend_foe(n, 2);
    sub_index = friend;
    [out_l, acc, dec_l] = svmpredict(ones(N, 1), test', svm);
    
    % Iterate over out_l and vote for class or foe depending on n
    % i is image number
    for i=1:N
        if out_l(i) == 1
            sum_votes(i, friend) = ...
                sum_votes(i, friend) + 1;
        else
            sum_votes(i, foe) = ...
                sum_votes(i, foe) + 1;
        end
    end
end

% The guessed class is the index of the maximum of each row
for i=1:N
    [val, guesses(i)] = max(sum_votes(i, :));
end

% Compare with real labels to determine the number of correct guesses
correct = sum(guesses == l_test');
incorrect = N - correct;
percentage = 100 * correct/N;
disp(['Guessed ' num2str(correct) ' correctly and ' num2str(incorrect) ...
      ' incorrectly; Success rate is ' num2str(percentage) '%.']);
