% Load required data from task 2
clear
res_path = get_res_path();
load(strjoin({res_path 'pca.mat'}, filesep));
load(strjoin({res_path 'partitioned.mat'}, filesep));
load(strjoin({res_path 'atapca.mat'}, filesep));

% Some variables
N = size(training, 2);
P = size(test, 2);
B = test - average_face(:, ones(1,P));

% Initialise for speed
all_guesses = zeros(P, 3, N);
correct_vec = zeros(N, 1);
incorrect_vec = zeros(N, 1);
timings = zeros(N, 1);

for M = 1:N
    % M is number of eigenvalues/vectors to use
    % Project each face onto each eigenvector, each row is a face
    faces_coeff_training_sel = faces_coeff_training(:, 1:M);
    faces_coeff_test_sel = faces_coeff_test(:, 1:M);
    
    % Initialise for speed
    guesses = zeros(P, 3);
    tic;
    for H = 1:P
        % For each face in testing set.
        l = l_test(H);
        test_face = faces_coeff_test_sel(H, :);
        
        % Calculate errors of test face to each training face projection
        error = faces_coeff_training_sel - test_face(ones(1,N), :);
        error_mag = sum(error .^2, 2);
        % Find the index of the minimum value
        [minimum, index] = min(error_mag);
        % Look up the index from l_train
        guess = l_train(index);
        
        % Check
        if l == guess
            guesses(H, :) = [1, guess, l];
        else
            guesses(H, :) = [0, guess, l];
        end
    
    end
    
     % Keep
    timings(M) = toc;
    all_guesses(:, :, M) = guesses;
    correct = sum(guesses(:, 1));
    incorrect = P - correct;
    correct_vec(M) = correct;
    incorrect_vec(M) = incorrect;
end

save(strjoin({res_path 'nn.mat'}, filesep), 'correct_vec', 'incorrect_vec', 'all_guesses', 'timings');
