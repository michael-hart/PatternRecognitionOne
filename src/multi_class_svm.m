function [ svms ] = multi_class_svm( training_data, labels, svmtrainpref)
% MULTI_CLASS_SVM: Data + Labels = 1vR SVMs
% training_data is training instance per row.
% Corresponding value in labels is class, labels is row vector.
% Arguments is svmtrain arguments.

    % Figure out how many classes there are in the data
    M = max(labels);
    N = size(labels, 2);
    
    % To hold [-1;1] values per class
    svm_labels = ones(N, 1);
    
    % Fill class label vector, 1 for class. -1 for rest.
    for j=1:N
        if labels(j) ~= M
            svm_labels(j) = -1;
        end
    end
    
    % Train SVM for that class vs. rest
    svms(M) = svmtrain(svm_labels, training_data, svmtrainpref);
    
    % Repeat for remaining classes.
    for i=1:M-1
        
        % To hold [-1;1] values per class
        svm_labels = ones(N, 1);
        
        % Fill class vector
        for j=1:N
            if labels(j) ~= i
                svm_labels(j) = -1;
            end
        end
        
        % Train SVM
        svms(i) = svmtrain(svm_labels, training_data, svmtrainpref);
    
    end
end 
   
