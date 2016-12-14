% Do Task 3 using 1vsRest SVMs
clear
res_path = get_res_path();
load(strjoin({res_path 'partitioned.mat'}, filesep));
load(strjoin({res_path 'atapca.mat'}, filesep));

% For our different setups
if ispc
    addpath('D:\Git\libsvm\windows');
end

if ismac
    addpath('/Users/acrisne/git/patternone/misc/libsvm/matlab');
end

% Use raw or pca data
use_raw = 0;
use_pca = 1;

if use_raw > 0

    % Load one vs rest data
    load(strjoin({res_path 'one_vs_rest.mat'}, filesep));

    % Global variables
    num_classes = size(one_vs_rest_svm, 2);
    num_test_pics = size(test, 2);
    
    % Storage for results
    out_classes = zeros(num_test_pics, num_classes);
    decision_value = zeros(num_test_pics, num_classes);
    acc_total = zeros(3, num_classes);
    
    % For each SVM, put in all test cases
    for svm_num = 1:num_classes
        test_labels = 2 * (l_test(:) == svm_num) - 1;
        svm = one_vs_rest_svm(svm_num);
        [out_l, acc , dec_l] = svmpredict(test_labels, test', svm, '-q');
        
        % Storage
        % Output decision. Column n refers to nth SVM's decisions
        out_classes(:, svm_num) = out_l;
        % Decision values used
        decision_value(:, svm_num) = dec_l;
        % Accuracy values, just for fun.
        acc_total(:, svm_num) = acc;
    end
    
    % Each row of out_classes gives the 52 SVMs' outputs for that test pic
    % Either 1 for yes or -1 for no. Acquire only 1's, rest will be 0's
    out_class_yes = out_classes == 1;
    
    % Element-wise multiplications. Only 1 values' decision value will stay
    final_class = out_class_yes .* decision_value;
    
    % Maximum
    [maximum, class_choice] = max(final_class, [], 2);
    
    % Check back
    correct_vec = class_choice == l_test';
    correct = sum(correct_vec);
    incorrect = num_test_pics - correct;
    
    percentage = 100 * correct/num_test_pics;
    disp(['Guessed ' num2str(correct) ' correctly and ' num2str(incorrect) ...
          ' incorrectly; Success rate is ' num2str(percentage) '%.']);
end

if use_pca > 0

    % Load one vs rest data
    load(strjoin({res_path 'one_vs_rest_pca.mat'}, filesep));

    % Global variables
    num_classes_pca = size(one_vs_rest_svm_pca, 2);
    num_test_pics_pca = size(faces_coeff_test, 1);
    
    % Storage for results
    out_classes_pca = zeros(num_test_pics_pca, num_classes_pca);
    decision_value_pca = zeros(num_test_pics_pca, num_classes_pca);
    acc_total_pca = zeros(3, num_classes_pca);
    
    % For each SVM, put in all test cases
    for svm_num_pca = 1:num_classes_pca
        test_labels_pca = 2 * (l_test(:) == svm_num_pca) - 1;
        svm_pca = one_vs_rest_svm_pca(svm_num_pca);
        [out_l_pca, acc_pca , dec_l_pca] = svmpredict(test_labels_pca, faces_coeff_test, svm_pca, '-q');
        
        % Storage
        % Output decision. Column n refers to nth SVM's decisions
        out_classes_pca(:, svm_num_pca) = out_l_pca;
        % Decision values used
        decision_value_pca(:, svm_num_pca) = dec_l_pca;
        % Accuracy values, just for fun.
        acc_total_pca(:, svm_num_pca) = acc_pca;
    end
    
    % Each row of out_classes gives the 52 SVMs' outputs for that test pic
    % Either 1 for yes or -1 for no. Acquire only 1's, rest will be 0's
    out_class_yes_pca = out_classes_pca == 1;
    
    % Element-wise multiplications. Only 1 values' decision value will stay
    final_class_pca = out_class_yes_pca .* decision_value_pca;
    
    % Maximum
    [maximum_pca, class_choice_pca] = max(final_class_pca, [], 2);
    
    % Check back
    correct_vec_pca = class_choice_pca == l_test';
    correct_pca = sum(correct_vec_pca);
    incorrect_pca = num_test_pics_pca - correct_pca;
    
    percentage_pca = 100 * correct_pca/num_test_pics_pca;
    disp(['Guessed ' num2str(correct_pca) ' correctly and ' num2str(incorrect_pca) ...
          ' incorrectly; Success rate is ' num2str(percentage_pca) '%.']);
end

if use_raw > 0

    % Load one vs rest data
    load(strjoin({res_path 'one_vs_rest.mat'}, filesep));

    % Global variables
    num_classes = size(one_vs_rest_svm_scaled, 2);
    num_test_pics = size(scaled_test, 2);
    
    % Storage for results
    out_classes = zeros(num_test_pics, num_classes);
    decision_value = zeros(num_test_pics, num_classes);
    acc_total = zeros(3, num_classes);
    
    % For each SVM, put in all test cases
    for svm_num = 1:num_classes
        test_labels = 2 * (l_test(:) == svm_num) - 1;
        svm = one_vs_rest_svm_scaled(svm_num);
        [out_l, acc , dec_l] = svmpredict(test_labels, scaled_test', svm, '-q');
        
        % Storage
        % Output decision. Column n refers to nth SVM's decisions
        out_classes(:, svm_num) = out_l;
        % Decision values used
        decision_value(:, svm_num) = dec_l;
        % Accuracy values, just for fun.
        acc_total(:, svm_num) = acc;
    end
    
    % Each row of out_classes gives the 52 SVMs' outputs for that test pic
    % Either 1 for yes or -1 for no. Acquire only 1's, rest will be 0's
    out_class_yes = out_classes == 1;
    
    % Element-wise multiplications. Only 1 values' decision value will stay
    final_class = out_class_yes .* decision_value;
    
    % Maximum
    [maximum, class_choice] = max(final_class, [], 2);
    
    % Check back
    correct_vec = class_choice == l_test';
    correct = sum(correct_vec);
    incorrect = num_test_pics - correct;
    
    percentage = 100 * correct/num_test_pics;
    disp(['Guessed ' num2str(correct) ' correctly and ' num2str(incorrect) ...
          ' incorrectly; Success rate is ' num2str(percentage) '%.']);
end

if use_pca > 0

    % Load one vs rest data
    load(strjoin({res_path 'one_vs_rest_pca.mat'}, filesep));

    % Global variables
    num_classes_pca = size(one_vs_rest_svm_pca_scaled, 2);
    num_test_pics_pca = size(scaled_faces_training, 1);
    
    % Storage for results
    out_classes_pca = zeros(num_test_pics_pca, num_classes_pca);
    decision_value_pca = zeros(num_test_pics_pca, num_classes_pca);
    acc_total_pca = zeros(3, num_classes_pca);
    
    % For each SVM, put in all test cases
    for svm_num_pca = 1:num_classes_pca
        test_labels_pca = 2 * (l_train(:) == svm_num_pca) - 1;
        svm_pca = one_vs_rest_svm_pca_scaled(svm_num_pca);
        [out_l_pca, acc_pca , dec_l_pca] = svmpredict(test_labels_pca, scaled_faces_training, svm_pca, '-q');
    
        % Storage
        % Output decision. Column n refers to nth SVM's decisions
        out_classes_pca(:, svm_num_pca) = out_l_pca;
        % Decision values used
        decision_value_pca(:, svm_num_pca) = dec_l_pca;
        % Accuracy values, just for fun.
        acc_total_pca(:, svm_num_pca) = acc_pca;
    end
    
    % Each row of out_classes gives the 52 SVMs' outputs for that test pic
    % Either 1 for yes or -1 for no. Acquire only 1's, rest will be 0's
    out_class_yes_pca = out_classes_pca == 1;
    
    % Element-wise multiplications. Only 1 values' decision value will stay
    final_class_pca = out_class_yes_pca .* decision_value_pca;
    
    % Maximum
    [maximum_pca, class_choice_pca] = max(final_class_pca, [], 2);
    
    % Check back
    correct_vec_pca = class_choice_pca == l_train';
    correct_pca = sum(correct_vec_pca);
    incorrect_pca = num_test_pics_pca - correct_pca;
    
    percentage_pca = 100 * correct_pca/num_test_pics_pca;
    disp(['Guessed ' num2str(correct_pca) ' correctly and ' num2str(incorrect_pca) ...
          ' incorrectly; Success rate is ' num2str(percentage_pca) '%.']);
end