% Retrieve important info from task 1
res_path = get_res_path();
load(strjoin({res_path 'errors.mat'}, filesep));


figure('position', [0 0 1280 800]);
hold on;
plot(avg_error_training, 'LineWidth',5);
plot(avg_error_test, 'LineWidth',5);
hold off;

title('Average Reconstruction Error vs. Number of Eigenvectors', 'interpreter', 'latex');
xlabel('Number of Eigenvectors');
ylabel('Error');
grid;

% If legends exists
leg = legend('Error from Training', 'Error from Testing','Location','northeast');
set(leg,'FontSize',25);
% Format data
set(findall(gcf,'type','axes'),'fontsize',25);
set(findall(gcf,'type','text'),'fontSize',25);
% Save data
fig = gcf;
fig.PaperPositionMode = 'auto';
print('error','-dpng','-r0');