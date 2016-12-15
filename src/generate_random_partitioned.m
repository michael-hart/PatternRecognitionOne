function generate_random_partitioned( data_filename, new_vector )
%GENERATE_RANDOM_PARTITIONED Saves randomised data in partitioned.mat
%   If new_vector is false, reads the vector file at rand_indices.mat and 
%   creates the partitioned data
%   If new_vector is true, shuffles data and randomly selects 3/4 training
%   and 1/4 test data

res_path = get_res_path();
load(strjoin({res_path data_filename}, filesep));

N = size(X, 2);
training_indices = zeros(1, (3/4)*N);
test_indices = zeros(1, (1/4)*N);

if new_vector
    % Label original positions
    data = vertcat(1:N, X);
    % Shuffle
    data = data(:, randperm(N));
    
    % Partition data
    training = data(:, 1:(3/4)*N);
    test = data(:, (3/4)*N+1:end);
    
    
    % Remove indices
    training_indices = training(1, :);
    test_indices = test(1, :);
    training = training(2:end, :);
    test = test(2:end, :);
    
    % Save indices
    save(strjoin({res_path 'rand_indices.mat'}, filesep), ...
         'training_indices', 'test_indices');
    
else
    % Load old vectors
    load(strjoin({res_path 'rand_indices.mat'}, filesep));
    
    % Select those vectors
    training = X(:, training_indices);
    test = X(:, test_indices);
end

% Always select labels using indices from file
l_train = l(training_indices);
l_test = l(test_indices);

% Save the generated arrays into a known location
save(strjoin({res_path 'partitioned.mat'}, filesep), 'training', ...
     'test', 'l_train', 'l_test');

end

