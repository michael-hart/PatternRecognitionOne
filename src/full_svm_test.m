% Test ALL variations of SVMs and output to CSV

clear

% We want to write each line to a CSV
% First we're going to write the columns
% partition-type, kernel-type, kernel-param, 1vWhat, scaling, raw/pca, 
% time_train, time_test, accuracy

res_path = get_res_path();
csv_path = strjoin({res_path 'results.csv'}, filesep);

% Because MATLAB is shit, we need to write the headers in manually
handle = fopen(csv_path, 'w');
headings = ['Partition Type,Kernel Type,Kernel Parameter,' ...
            'Multi-class Type,Scaling,Raw/PCA,Time to Train,' ...
            'Time to Test,Accuracy\n'];
fwrite(handle, headings);
fclose(handle);

% Split the data in the usual way; this gives 0.7 split
generate_partitioned('face.mat', false, false);
load(strjoin({res_path 'partitioned.mat'}, filesep));
part_type = '0.7';

% Test list is as follows
% 0.7, linear, N/A, 1v1, unscaled, raw.
% 0.7, linear, N/A, 1v1, scaled, raw.
% 0.7, linear, N/A, 1vr, unscaled, raw.
% 0.7, linear, N/A, 1vr, scaled, raw.
% Find the BEST kernel with default params
%    0.7, <others>, <default_params>, 1v1, scaled, raw.
%    0.7, <others>, <default_params>, 1vr, scaled, raw.
% Choose the best kernel and test the best params
%    0.7, <best_kernel>, <various_params>, 1v1, scaled, raw.
%    0.7, <best_kernel>, <various_param>, 1vr, scaled, raw.
%    NOTE that we don't know what params to test until best_kernel is
%    determined.
%
% PCA is considered to be a desparate set of tests
% 0.7, linear, N/A, 1v1, scaled, pca.
% 0.7, linear, N/A, 1vr, scaled, pca.
%
% Same, but with other kernels
%    0.7, <others>, <default_params>, 1v1, scaled, pca.
%    0.7, <others>, <default_params>, 1vr, scaled, pca.
% Again, choose the best kernel and test for the best params
%    0.7, <best_kernel>, <various_params>, 1v1, scaled, pca.
%    0.7, <best_kernel>, <various_param>, 1vr, scaled, pca.
%    NOTE that we don't know what params to test until best_kernel is
%    determined.

% Cross validation - we're NOT doing it for the moment, but we will discuss
% it in the results as to why (not)

% Other kernel types list: 
%  Polynomial (uses gamma, degree)
%  Radial Basis (uses gamma)
%  Sigmoid (uses gamma, coef0)
% -c is cost, which is used in C-SVC, epsilon-SVR, nu-SVR

% 0.7, linear, N/A, 1v1, unscaled, raw.
