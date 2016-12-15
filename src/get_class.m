function [ class_data ] = get_class( labels, data, class_number )
% GET_CLASS Returns only class data
% Data corresponds to labels in input arguments
% class_number is the requested label
% Only return is matrix of all data associated with class
% Data has to be instance per column. 
% Labels has to be a column or row vector

    % Indices corresponding to class_number
    class_instances = labels(:) == class_number;
  
    % New matrix only columns with data points needed
    class_data = data(:, class_instances');
    
    % Return
end