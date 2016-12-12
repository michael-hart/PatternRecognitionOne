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
plot(correct_vec, 'LineWidth',5);
plot(incorrect_vec, 'LineWidth',5);
hold off;

title('Corrent and Incorrect Guesses vs. Number of Eigenvectors', 'interpreter', 'latex');
xlabel('Number of Eigenvectors');
ylabel('Number of Guesses');
grid;

% If legends exists
leg = legend('Correct Guesses', 'Incorrect Guesses','Location','northeast');
set(leg,'FontSize',25);
% Format data
set(findall(gcf,'type','axes'),'fontsize',25);
set(findall(gcf,'type','text'),'fontSize',25);
% Save data
fig = gcf;
fig.PaperPositionMode = 'auto';
print('correctincorrect','-dpng','-r0');

figure('position', [0 0 1280 800]);
percent = 100 * (correct_vec ./ size(test, 2));
plot(percent, 'LineWidth',5);

title('Accuracy vs. Number of Eigenvectors', 'interpreter', 'latex');
xlabel('Number of Eigenvectors');
ylabel('Percentage');
grid;

% If legends exists
% set(leg,'FontSize',25);
% Format data
set(findall(gcf,'type','axes'),'fontsize',25);
set(findall(gcf,'type','text'),'fontSize',25);
% Save data
fig = gcf;
fig.PaperPositionMode = 'auto';
print('correctincorrectpercent','-dpng','-r0');