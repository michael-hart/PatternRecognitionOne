% Load partitioned data; to repartition, run regenerate_partitioned
[ training, test, l_train, l_test ] = load_partitioned();

disp(['Training length is ' num2str(size(training, 2)) ...
      '; test length is ' num2str(size(test, 2)) '.']);
  
% TODO train with data

% Find average face
N = size(training, 2);
average_face = sum(training, 2) ./ N;
show_face(average_face);

% Remove the average face from the training set
D = size(training, 1);
% This is a trick for removing face from all columns at once
A = training - average_face(:, ones(1,N));

% Compute covariance matrix; First we're using S = (1/N) A A(T)
S = (1/N) * A * A';

% Calculate the eigenvectors of this matrix
[S_eig_vec, S_eig_val] = eig(S);

% We want to work out how many non-zero eigenvalues there are
nonzero = nnz(round(S_eig_val, 10));
disp(['Number of nonzero elements in AAT is ' num2str(nonzero)]);

% Repeat the above process for S = (1/N) A(T) A
S2 = (1/N) * A' * A;
[S2_eig_vec, S2_eig_val] = eig(S2);
nonzero2 = nnz(round(S2_eig_val, 10));
disp(['Number of nonzero elements in ATA is ' num2str(nonzero2)]);

% Save PCA data in a file called pca.mat
res_path = get_res_path();
part_path = strjoin({res_path 'pca.mat'}, filesep);
save(part_path, 'average_face', 'S2_eig_vec', 'S2_eig_val', 'A');

% Now compare 1:M of each matrix
M = 20;
r = 6;
sub_eig_val = sum(S_eig_val(1:M, 1:M), 2);
sub2_eig_val = sum(S2_eig_val(1:M, 1:M), 2);
sub_eig_val = round(sub_eig_val, r);
sub2_eig_val = round(sub2_eig_val, r);

disp(['Identical elements: ' ...
      num2str(sum(sum(sub_eig_val == sub2_eig_val))) ...
      '; Expected: ' num2str(M)]);
