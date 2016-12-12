% Load required data from task 2
clear
res_path = get_res_path();
load(strjoin({res_path 'pca.mat'}, filesep));
load(strjoin({res_path 'partitioned.mat'}, filesep));
load(strjoin({res_path 'projected.mat'}, filesep));
load(strjoin({res_path 'pca.mat'}, filesep));


% Some variables
N = size(training, 2);
P = size(test, 2);
B = test - average_face(:, ones(1,P));
total = size(S2_eig_vec_adj, 2);

for M=1:total
    % M is number of eigenvalues/vectors to use
    S2_eig_vec_sel = S2_eig_vec_adj(:, 1:M);

    % Project each face onto each eigenvector, each row is a face
    faces_coeff_training = A' * S2_eig_vec_sel;
    faces_coeff_test = B' * S2_eig_vec_sel;

    % Reconstruct each face.
    faces_reconstructed_training = repmat(average_face, 1, N) + S2_eig_vec_sel * faces_coeff_training';
    faces_reconstructed_test = repmat(average_face, 1, P) + S2_eig_vec_sel * faces_coeff_test';
    
    % Error
    error_faces_training = training - faces_reconstructed_training;
    error_faces_test = test - faces_reconstructed_test;
    % Magnitude of each column
    mag_error_faces_training = sqrt(sum(error_faces_training .^2, 1));
    mag_error_faces_test = sqrt(sum(error_faces_test .^2, 1));
    % Assign and store
    avg_error_training(M) = mean(mag_error_faces_training);
    avg_error_test(M) = mean(mag_error_faces_test);
end

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
