% Load partitioned data; to repartition, run regenerate_partitioned
[ training, test, l_train, l_test ] = load_partitioned();

disp(['Training length is ' num2str(size(training, 2)) ...
      '; test length is ' num2str(size(test, 2)) '.']);
  
% TODO train with data

% Find average face
N = size(training, 2);
average_face = sum(training, 2) ./ N;
% show_face(average_face);

% Remove the average face from the training set
D = size(training, 1);
% This is a trick for removing face from all columns at once
A = training - average_face(:, ones(1,N));

% Compute covariance matrix; First we're using S = (1/N) A A(T)
S = (1/N) * A * A';

% Calculate the eigenvectors of this matrix
[S_eig_vec, S_eig_val] = eig(S);

% Eigenvalues are aleady in descending order!
disp(S_eig_val(1:10, 1:10));
% disp(S_eig_val(2566:2576, 2566:2576));
disp(S_eig_vec(1:10, 1:10));

% We want to work out how many non-zero eigenvalues there are
% size(S_eig_val); TODO Meng why are there 2576 nonzero?!
nonzero = nnz(S_eig_val);
disp(['Number of nonzero elements is ' num2str(nonzero)]);

% Repeat the above process for S = (1/N) A(T) A
S2 = (1/N) * A' * A;
[S2_eig_vec, S2_eig_val] = eig(S2);
nonzero2 = nnz(S_eig_val);

% Now compare 1:M of each matrix TODO
