function [ class_data ] = get_class( labels, data, class_number )
%GET_CLASS Returns only class data
%   Data corresponds to labels in input arguments
%   i is the requested label
%   Only return is matrix of all data associated with class i

% Instantiate output variable
N = size(labels,2);
class_instances = sum(labels(:) == class_number);
class_data = zeros(size(data, 1), class_instances);

% Variable to track number
class = 1;

% Loop through all labels
for index=1:N
    if labels(index) == class_number
        % Record in class_data
        class_data(:, class) = data(:, index);
        class = class + 1;
    end
end

% Return

end