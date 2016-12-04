% Load partitioned data; to repartition, run regenerate_partitioned
[ training, test, l ] = load_partitioned();

disp(['Training length is ' num2str(size(training, 1)) ...
      '; test length is ' num2str(size(test, 1)) '.']);
  
% TODO train with data
