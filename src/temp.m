% one_v_rest_generate
% one_v_rest_test

confuse_matrix = confusionmat(l_test', answers1);

figure('position', [0 0 800 800]);
imagesc(confuse_matrix);
colorbar;

title('Title', 'interpreter', 'latex');
xlabel('Class Guessed');
ylabel('Actual Class');

set(findall(gcf,'type','axes'),'fontsize',25);
set(findall(gcf,'type','text'),'fontSize',25);