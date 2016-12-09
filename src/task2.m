% Clear all info
clear

% Retrieve important info from task 1
res_path = get_res_path();
load(strjoin({res_path 'pca.mat'}, filesep));
load(strjoin({res_path 'partitioned.mat'}, filesep));

% Reduce dimensionality to M, where M can vary
M = 100;
sub_eig_vec = S2_eig_vec(1:M, 1:M);
sub_eig_val = S2_eig_val(1:M, 1:M);

% For all faces in the set, reconstruct using PCA and calculate the error

% Just do one for now
correct_face = training(:,1);
% Reproduce face
phi_1_T = A(:,1)';
u = zeros(2576, 1);
test1 = (phi_1_T * sub_eig_vec(1) * sub_eig_vec(1));
for i=1:M
    u = u + (phi_1_T * sub_eig_vec(i) * sub_eig_vec(i))';
end
test = average_face + u;
show_face(test);
error = sum(sum(abs(correct_face - test)))

% Do the same thing again, but this time calculate all of them at once!
N = size(training, 2);
u = zeros(2576, N);
for i=1:N
    phi = A(:, i)';
    for j=1:M
        u(:, i) = u(:, i) + (phi * sub_eig_vec(j) * sub_eig_vec(j))';
    end
end
test = average_face(:, ones(1,N)) + u;
show_face(test(:, 20));
return
