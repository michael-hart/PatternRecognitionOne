% First, load the training data using the standard function
[ X, l ] = load_data();

% Partition the data using alternation, for now
x_rows = size(X, 1);
x_cols = size(X, 2);
training = zeros(x_rows, 3*x_cols/4);
test = zeros(x_rows, x_cols/4);
l_train = zeros(1, 3*x_cols/4);
l_test = zeros(1, x_cols/4);

track = 1;
for i=1:x_cols
    if mod(i, 4) > 0
        training(:, track) = X(:, i);
        l_train(track) = l(i);
        track = track + 1;
    else
        idx = floor(i/4);
        test(:, idx) = X(:, i);
        l_test(idx) = l(i);
    end
end

% Get resource path
res_path = get_res_path();
part_path = strjoin({res_path 'partitioned.mat'}, filesep);

% Save the generated arrays into a known location
save(part_path, 'training', 'test', 'l_train', 'l_test');