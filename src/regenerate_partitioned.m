% First, load the training data using the standard function
[ X, l ] = load_data();

% Partition the data using alternation, for now
x_rows = size(X, 1);
x_cols = size(X, 2);
training_data = zeros(x_rows/2, x_cols);
test_data = zeros(x_rows/2, x_cols);
training_data(1, :) = X(1, :);
test_data(1, :) = X(2, :);

for i=3:x_rows
    if mod(i,2) == 0
        vertcat(training_data, X(i, :));
    else
        vertcat(test_data, X(i, :));
    end
end

% Get resource path
res_path = get_res_path();
part_path = strjoin({res_path 'partitioned.mat'}, filesep);

% Save the generated arrays into a known location
save(part_path, 'training_data', 'test_data', 'l');