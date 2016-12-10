% Load required data from task 2
clear
res_path = get_res_path();
load(strjoin({res_path 'pca.mat'}, filesep));
load(strjoin({res_path 'partitioned.mat'}, filesep));
load(strjoin({res_path 'projected.mat'}, filesep));

N = size(training, 2);

% Take a test face, index 23 for now to test theory
guesses = zeros(size(test, 2), 1);
for n=1:size(test, 2)
    l = l_test(n);
    test_face = test(:, n);

    % Remove average face
    test_face = test_face - average_face;

    % Project face onto chosen eigen bases, M=100(random pick)
    M = 100;
    sub_eig_vec = S_eig_vec(:, 1:M);
    pca_face = zeros(size(test_face, 1), 1);
    for j=1:M
        pca_face = pca_face + (test_face' * sub_eig_vec(:, j) * ...
            sub_eig_vec(:, j));
    end

    % Calculate error
    error = sum(abs(projected_faces - pca_face(:, ones(1,N))));

    % Find the index of the minimum value
    [minimum, index] = min(error);

    % Look up the index from l_train
    guess = l_train(index);
    if l == guess
        guesses(n) = 1;
    else
        guesses(n) = 0;
    end

%     disp(['Correct class is ' num2str(l) ' and guessed ' num2str(guess)]);
end

correct = sum(guesses);
incorrect = size(test, 2) - correct;
disp(['Guessed ' num2str(correct) ' correctly and ' num2str(incorrect) ...
      ' incorrectly; Success rate is ' ...
      num2str(100*correct/(correct + incorrect)) '%.']);
