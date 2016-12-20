% Load required data from task 2
clear
res_path = get_res_path();
load(strjoin({res_path 'pca.mat'}, filesep));
load(strjoin({res_path 'partitioned.mat'}, filesep));
load(strjoin({res_path 'atapca.mat'}, filesep));
load(strjoin({res_path 'nn.mat'}, filesep));

% Raw numbers
figure('position', [0 0 1280 800]);
hold on;
plot(correct_vec, 'LineWidth',10);
plot(incorrect_vec, 'LineWidth',10);
hold off;

title('Correct \& Incorrect Guesses vs. Number of Bases', 'interpreter', 'latex');
xlabel('Number of Bases');
ylabel('Number of Guesses');
grid;

% If legends exists
leg = legend('Correct Guesses', 'Incorrect Guesses','Location','northeast');
set(leg,'FontSize',50);
% Format data
set(findall(gcf,'type','axes'),'fontsize',50);
set(findall(gcf,'type','text'),'fontSize',50);
% Save data
fig = gcf;
fig.PaperPositionMode = 'auto';
print('correctincorrect','-dpng','-r0');

figure('position', [0 0 1280 800]);
percent = 100 * (correct_vec ./ size(test, 2));
plot(percent, 'LineWidth',10);

title('Accuracy vs. Number of Bases', 'interpreter', 'latex');
xlabel('Number of Bases');
ylabel('Percentage');
grid;

% If legends exists
% set(leg,'FontSize',25);
% Format data
set(findall(gcf,'type','axes'),'fontsize',50);
set(findall(gcf,'type','text'),'fontSize',50);
% Save data
fig = gcf;
fig.PaperPositionMode = 'auto';
print('correctincorrectpercent','-dpng','-r0');

figure('position', [0 0 1280 800]);
plot(timings, 'LineWidth',10);

title('Time Taken vs. Number of Bases', 'interpreter', 'latex');
xlabel('Number of Bases');
ylabel('Tics');
grid;

% If legends exists
% set(leg,'FontSize',25);
% Format data
set(findall(gcf,'type','axes'),'fontsize',50);
set(findall(gcf,'type','text'),'fontSize',50);
% Save data
fig = gcf;
fig.PaperPositionMode = 'auto';
print('tics','-dpng','-r0');

guesses = all_guesses(:, :, 156);
results(guesses(:, 2), l_test', 'NN PCA with 156 Bases', 'confusepca'); 

show_face(test(:, 26 * 3));
fig = gcf;
fig.PaperPositionMode = 'auto';
print('class1','-dpng','-r0');

show_face(test(:, 30 * 3));
fig = gcf;
fig.PaperPositionMode = 'auto';
print('class2','-dpng','-r0');

show_face(test(:, 42 * 3));
fig = gcf;
fig.PaperPositionMode = 'auto';
print('class3','-dpng','-r0');

close all;
