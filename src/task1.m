% Load partitioned data; to repartition, run regenerate_partitioned
[ training, test, l ] = load_partitioned();

disp(['Training length is ' num2str(size(training, 1)) ...
      '; test length is ' num2str(size(test, 1)) '.']);
  
% TODO train with data

% Calculate the covariance matrix S of the training data, 1/N A A(T)
N = 6;
S = cov(((1/N) .* training), training');
dims = size(S);
disp(['Dimensions of S are ' num2str(dims(1)) ' by ' num2str(dims(2)) ]);

% Path to custom libsvm location on windows
addpath('D:/Git/libsvm/windows');