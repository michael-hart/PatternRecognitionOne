% Clear all info
clear

% Retrieve important info from task 1
res_path = get_res_path();
load(strjoin({res_path 'pca.mat'}, filesep));
load(strjoin({res_path 'partitioned.mat'}, filesep));

% Create appropriate S2_eig_val that is correct from ui = A * vi
% Normalise!
S2_eig_vec_adj = A * S2_eig_vec;
S2_eig_vec_adj = normc(S2_eig_vec_adj);

% This is a trick for removing face from all columns at once
N = size(training, 2);
P = size(test, 2);
B = test - average_face(:, ones(1,P));

% % H is number of eigenvalues/vectors to use
% H = 50;
% S2_eig_vec_sel = S2_eig_vec_adj(:, 1:H);
% 
% % Project each face onto each eigenvector, each row is a face
% face_coeff_training = A' * S2_eig_vec_sel;
% face_coeff_test = B' * S2_eig_vec_sel;
% 
% % Reconstruct each face.
% face_reconstructed_training = repmat(average_face, 1, N) + S2_eig_vec_sel * face_coeff_training';
% face_reconstructed_test = repmat(average_face, 1, P) + S2_eig_vec_sel * face_coeff_test';

% Graph things
avg_error_training = zeros(N, 1);
avg_error_test = zeros(P, 1);
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

save(strjoin({res_path 'errors.mat'}, filesep), 'avg_error_training', 'avg_error_test');