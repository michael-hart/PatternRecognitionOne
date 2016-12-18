% Test ALL variations of SVMs and output to CSV

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

% First test is raw, unscaled, linear.
% 0.7, linear, N/A, 1v1, unscaled, raw.
% 0.7, linear, N/A, 1v1, scaled, raw.
% 0.7, linear, N/A, 1vr, unscaled, raw.
% 0.7, linear, N/A, 1vr, scaled, raw.
% 0.7, linear, N/A, 1v1, scaled, pca.
% 0.7, linear, N/A, 1vr, scaled, pca.
% Same, but with other kernels
%    0.7, <others>, <some_params>, 1v1, scaled, raw.
%    0.7, <others>, <some_params>, 1vr, scaled, pca.

% How to use cross validation on these? This seems to be a parameter of the
% training, such that adding -v n will cross-validate.
% It appears to be that if we vary the parameters ourselves, we can cross
% validate by looking at the results of the experiment

% Kernel types: 
%  Linear
%  Polynomial (uses gamma, degree)
%  Radial Basis (uses gamma)
%  Sigmoid (uses gamma, coef0)
%  Precomputed (uses training_set_file)
% -c is cost, which is used in C-SVC, epsilon-SVR, nu-SVR