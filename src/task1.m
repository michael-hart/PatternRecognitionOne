% Load partitioned data; to repartition, run regenerate_partitioned
[ training, test, l_train, l_test ] = load_partitioned();

disp(['Training length is ' num2str(size(training, 2)) ...
      '; test length is ' num2str(size(test, 2)) '.']);
  
% TODO train with data

% Calculate the covariance matrix S of the training data, 1/N A A(T)
N = 6;
S = cov(((1/N) .* training), training');
dims = size(S);
disp(['Dimensions of S are ' num2str(dims(1)) ' by ' num2str(dims(2)) ]);

% Path to custom libsvm location on windows
addpath('D:/Git/libsvm/windows');

% Display a face to test new function
show_face(training(:, 200));