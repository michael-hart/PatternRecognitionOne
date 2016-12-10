% Clear all info
clear

% Retrieve important info from task 1
res_path = get_res_path();
load(strjoin({res_path 'pca.mat'}, filesep));
load(strjoin({res_path 'partitioned.mat'}, filesep));

% Reduce dimensionality to M, where M can vary
N = size(training, 2);
av_error = zeros(N/10, 1);
for M=10:10:N
    sub_eig_vec = S_eig_vec(:, 1:M);

    % For all faces in the set, reconstruct using PCA and calculate the error
    u = zeros(2576, N);
    for i=1:N
        phi = A(:, i)';
        for j=1:M
            u(:, i) = u(:, i) + (phi * sub_eig_vec(:, j) * sub_eig_vec(:, j));
        end
    end
    test = average_face(:, ones(1,N)) + u;
    error = sum(abs(training - test));
    av_error(M/10) = sum(error)/M;
end

plot(10:10:N, av_error);
projected_faces = u;
save(strjoin({res_path 'projected.mat'}, filesep), 'projected_faces');