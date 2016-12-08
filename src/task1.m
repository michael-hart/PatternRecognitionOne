% Load partitioned data; to repartition, run regenerate_partitioned
[ training, test, l_train, l_test ] = load_partitioned();

disp(['Training length is ' num2str(size(training, 2)) ...
      '; test length is ' num2str(size(test, 2)) '.']);
  
% TODO train with data

% Find average face
N = size(training, 2);
average_face = sum(training, 2) ./ N;
show_face(average_face);

% Path to custom libsvm location on windows
addpath('D:/Git/libsvm/windows');
