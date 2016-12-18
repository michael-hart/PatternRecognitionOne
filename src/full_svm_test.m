%% Clear
% Test ALL variations of SVMs and output to CSV

clear

%% Setup

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
            'Time to Test,Accuracy', sprintf('\n')];
fwrite(handle, headings);
fclose(handle);

% Split the data in the usual way; this gives 0.7 split
generate_partitioned('face.mat', false, false);
load(strjoin({res_path 'partitioned.mat'}, filesep));
part_type = '0.7';

% Scale data
N = size(training, 2);
raw_to_scale = horzcat(training, test);
raw_scaled = zscore(raw_to_scale, 0, 2);
training_scaled = raw_scaled(:, 1:N);
test_scaled = raw_scaled(:, N+1:size(raw_scaled, 2));

% SVM testing preferences
svmtestpref = '-q';

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

%% linear,1v1,unscaled,raw

% 0.7, linear, N/A, 1v1, unscaled, raw.
disp('Testing linear 1v1 unscaled raw.');
svmtrainpref = '-t 0 -s 0 -q';
tic();
svm = one_v_one_svm(training, l_train, svmtrainpref);
train_time = toc();
tic();
[~, ~, ~, answers] = one_v_one_svm_test(svm, test', svmtestpref);
test_time = toc();
acc = sum(answers == l_test')/length(l_test);
disp(['Train: ' num2str(train_time) 's; Test: ' num2str(test_time) ...
      's; Acc: ' num2str(acc)]);

data_str = [part_type, ',linear,', 'N/A,', '1v1,', 'unscaled,', 'raw,', ...
            num2str(train_time), ',', num2str(test_time), ',', ...
            num2str(acc), sprintf('\n')];
handle = fopen(csv_path, 'a');
fwrite(handle, data_str);
fclose(handle);

%% linear,1v1,scaled,raw

disp('Testing linear 1v1 scaled raw.');
svmtrainpref = '-t 0 -s 0 -q';
tic(); 
svm = one_v_one_svm(training_scaled, l_train, svmtrainpref);
train_time = toc();
tic();
[~, ~, ~, answers] = one_v_one_svm_test(svm, test_scaled', svmtestpref);
test_time = toc();
acc = sum(answers == l_test')/length(l_test);
disp(['Train: ' num2str(train_time) 's; Test: ' num2str(test_time) ...
      's; Acc: ' num2str(acc)]);

data_str = [part_type, ',linear,', 'N/A,', '1v1,', 'scaled,', 'raw,', ...
            num2str(train_time), ',', num2str(test_time), ',', ...
            num2str(acc), sprintf('\n')];
handle = fopen(csv_path, 'a');
fwrite(handle, data_str);
fclose(handle);

%% linear,1vr,unscaled,raw

disp('Testing linear 1vr unscaled raw.');
svmtrainpref = '-t 0 -s 0 -q';

tic();
svm = one_v_rest_svm(training', l_train, svmtrainpref);
train_time = toc();
tic();
[~, ~, ~, answers] = one_v_rest_svm_test(svm, test', l_test', svmtestpref);
test_time = toc();
acc = sum(answers == l_test')/length(l_test);
disp(['Train: ' num2str(train_time) 's; Test: ' num2str(test_time) ...
      's; Acc: ' num2str(acc)]);

data_str = [part_type, ',linear,', 'N/A,', '1vr,', 'unscaled,', 'raw,', ...
            num2str(train_time), ',', num2str(test_time), ',', ...
            num2str(acc), sprintf('\n')];
handle = fopen(csv_path, 'a');
fwrite(handle, data_str);
fclose(handle);

%% linear,1vr,scaled,raw

disp('Testing linear 1vr scaled raw.');
svmtrainpref = '-t 0 -s 0 -q';

tic();
svm = one_v_rest_svm(training_scaled', l_train, svmtrainpref);
train_time = toc();
tic();
[~, ~, ~, answers] = one_v_rest_svm_test(svm, test_scaled', l_test', ...
                                         svmtestpref);
test_time = toc();
acc = sum(answers == l_test')/length(l_test);
disp(['Train: ' num2str(train_time) 's; Test: ' num2str(test_time) ...
      's; Acc: ' num2str(acc)]);

data_str = [part_type, ',linear,', 'N/A,', '1vr,', 'scaled,', 'raw,', ...
            num2str(train_time), ',', num2str(test_time), ',', ...
            num2str(acc), sprintf('\n')];
handle = fopen(csv_path, 'a');
fwrite(handle, data_str);
fclose(handle);

%% polynomial,1v1,scaled,raw

disp('Testing polynomial 1v1 scaled raw.');
svmtrainpref = '-t 1 -s 0 -q';
tic(); 
svm = one_v_one_svm(training_scaled, l_train, svmtrainpref);
train_time = toc();
tic();
[~, ~, ~, answers] = one_v_one_svm_test(svm, test_scaled', svmtestpref);
test_time = toc();
acc = sum(answers == l_test')/length(l_test);
disp(['Train: ' num2str(train_time) 's; Test: ' num2str(test_time) ...
      's; Acc: ' num2str(acc)]);

data_str = [part_type, ',polynomial,', 'N/A,', '1v1,', 'scaled,', 'raw,', ...
            num2str(train_time), ',', num2str(test_time), ',', ...
            num2str(acc), sprintf('\n')];
handle = fopen(csv_path, 'a');
fwrite(handle, data_str);
fclose(handle);

%% polynomial,1vr,scaled,raw

disp('Testing polynomial 1vr scaled raw.');
svmtrainpref = '-t 1 -s 0 -q';

tic();
svm = one_v_rest_svm(training_scaled', l_train, svmtrainpref);
train_time = toc();
tic();
[~, ~, ~, answers] = one_v_rest_svm_test(svm, test_scaled', l_test', ...
                                         svmtestpref);
test_time = toc();
acc = sum(answers == l_test')/length(l_test);
disp(['Train: ' num2str(train_time) 's; Test: ' num2str(test_time) ...
      's; Acc: ' num2str(acc)]);

data_str = [part_type, ',polynomial,', 'N/A,', '1vr,', 'scaled,', 'raw,', ...
            num2str(train_time), ',', num2str(test_time), ',', ...
            num2str(acc), sprintf('\n')];
handle = fopen(csv_path, 'a');
fwrite(handle, data_str);
fclose(handle);

%% radial,1v1,scaled,raw

disp('Testing radial 1v1 scaled raw.');
svmtrainpref = '-t 2 -s 0 -q';
tic(); 
svm = one_v_one_svm(training_scaled, l_train, svmtrainpref);
train_time = toc();
tic();
[~, ~, ~, answers] = one_v_one_svm_test(svm, test_scaled', svmtestpref);
test_time = toc();
acc = sum(answers == l_test')/length(l_test);
disp(['Train: ' num2str(train_time) 's; Test: ' num2str(test_time) ...
      's; Acc: ' num2str(acc)]);

data_str = [part_type, ',radial,', 'N/A,', '1v1,', 'scaled,', 'raw,', ...
            num2str(train_time), ',', num2str(test_time), ',', ...
            num2str(acc), sprintf('\n')];
handle = fopen(csv_path, 'a');
fwrite(handle, data_str);
fclose(handle);

%% radial,1vr,scaled,raw

disp('Testing radial 1vr scaled raw.');
svmtrainpref = '-t 2 -s 0 -q';

tic();
svm = one_v_rest_svm(training_scaled', l_train, svmtrainpref);
train_time = toc();
tic();
[~, ~, ~, answers] = one_v_rest_svm_test(svm, test_scaled', l_test', ...
                                         svmtestpref);
test_time = toc();
acc = sum(answers == l_test')/length(l_test);
disp(['Train: ' num2str(train_time) 's; Test: ' num2str(test_time) ...
      's; Acc: ' num2str(acc)]);

data_str = [part_type, ',radial,', 'N/A,', '1vr,', 'scaled,', 'raw,', ...
            num2str(train_time), ',', num2str(test_time), ',', ...
            num2str(acc), sprintf('\n')];
handle = fopen(csv_path, 'a');
fwrite(handle, data_str);
fclose(handle);

%% sigmoid,1v1,scaled,raw

disp('Testing sigmoid 1v1 scaled raw.');
svmtrainpref = '-t 3 -s 0 -q';
tic(); 
svm = one_v_one_svm(training_scaled, l_train, svmtrainpref);
train_time = toc();
tic();
[~, ~, ~, answers] = one_v_one_svm_test(svm, test_scaled', svmtestpref);
test_time = toc();
acc = sum(answers == l_test')/length(l_test);
disp(['Train: ' num2str(train_time) 's; Test: ' num2str(test_time) ...
      's; Acc: ' num2str(acc)]);

data_str = [part_type, ',sigmoid,', 'N/A,', '1v1,', 'scaled,', 'raw,', ...
            num2str(train_time), ',', num2str(test_time), ',', ...
            num2str(acc), sprintf('\n')];
handle = fopen(csv_path, 'a');
fwrite(handle, data_str);
fclose(handle);

%% sigmoid,1vr,scaled,raw

disp('Testing sigmoid 1vr scaled raw.');
svmtrainpref = '-t 3 -s 0 -q';

tic();
svm = one_v_rest_svm(training_scaled', l_train, svmtrainpref);
train_time = toc();
tic();
[~, ~, ~, answers] = one_v_rest_svm_test(svm, test_scaled', l_test', ...
                                         svmtestpref);
test_time = toc();
acc = sum(answers == l_test')/length(l_test);
disp(['Train: ' num2str(train_time) 's; Test: ' num2str(test_time) ...
      's; Acc: ' num2str(acc)]);

data_str = [part_type, ',sigmoid,', 'N/A,', '1vr,', 'scaled,', 'raw,', ...
            num2str(train_time), ',', num2str(test_time), ',', ...
            num2str(acc), sprintf('\n')];
handle = fopen(csv_path, 'a');
fwrite(handle, data_str);
fclose(handle);