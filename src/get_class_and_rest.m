function [ class_data, rest_data ] = get_class_and_rest( labels, data, i )
%GET_CLASS_AND_REST Separates class data from rest data
%   Data corresponds to labels in input arguments
%   i is the requested label
%   Left return is matrix of all data associated with class i
%   Right return is matrix of the REST of the data

% Instantiate output variables
N = size(labels,2);
class_instances = sum(labels(:) == i);
class_data = zeros(size(data, 1), class_instances);
rest_data = zeros(size(data, 1), N - class_instances);

% Variables to track number of each
class = 1;
rest = 1;

% Loop through all labels
for index=1:N
    if labels(index) == i
        % Record in class_data
        class_data(:, class) = data(:, index);
        class = class + 1;
    else
        % Do something else
        rest_data(:, rest) = data(:, index);
        rest = rest + 1;
    end
end

% Return

end

