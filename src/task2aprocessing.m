% Retrieve important info from task 1
clear;
res_path = get_res_path();
load(strjoin({res_path 'errors.mat'}, filesep));
load(strjoin({res_path 'pca.mat'}, filesep));
load(strjoin({res_path 'atapca.mat'}, filesep));
load(strjoin({res_path 'partitioned.mat'}, filesep));

S2_eig_val_col = abs(sum(S2_eig_val, 2));

size_eig = size(S2_eig_val_col, 1);
unused = zeros(size_eig, 1);

for index = 1:size_eig-1
        unused(index) = sum(S2_eig_val_col(index+1:size_eig));
end

figure('position', [0 0 1280 800]);
hold on;
plot(avg_error_training, 'LineWidth',10);
plot(avg_error_test, 'LineWidth',10);
plot(sqrt(unused), 'LineWidth', 5);
hold off;

title('Average Reconstruction Error vs. Number of Bases', 'interpreter', 'latex');
xlabel('Number of Bases');
ylabel('Error');
grid;

% If legends exists
leg = legend('Error from Training', 'Error from Testing', 'Theorectical Error','Location','northeast');
set(leg,'FontSize',25);
% Format data
set(findall(gcf,'type','axes'),'fontsize',50);
set(findall(gcf,'type','text'),'fontSize',50);
% Save data
fig = gcf;
fig.PaperPositionMode = 'auto';
print('error','-dpng','-r0');

% Saving sample images

N = size(training, 2);
P = size(test, 2);
B = test - average_face(:, ones(1,P));

% For reconstruction image
% M is number of eigenvalues/vectors to use
M = 5;
S2_eig_vec_sel = S2_eig_vec_adj(:, 1:M);

% Project each face onto each eigenvector, each row is a face
faces_coeff_training_sel = faces_coeff_training(:, 1:M);
faces_coeff_test_sel = faces_coeff_test(:, 1:M);

% Reconstruct each face.
faces_reconstructed_training = repmat(average_face, 1, N) + S2_eig_vec_sel * faces_coeff_training_sel';
faces_reconstructed_test = repmat(average_face, 1, P) + S2_eig_vec_sel * faces_coeff_test_sel';

% Save everything
% Faces and reconstructions with 100 bases
face1 = training(:, 154);
face2 = training(:, 276);
face3 = test(:, 54);

reface1 = faces_reconstructed_training(:, 154);
reface2 = faces_reconstructed_training(:, 276);
reface3 = faces_reconstructed_test(:, 54);

show_face(face1);
fig = gcf;
fig.PaperPositionMode = 'auto';
print('face1','-dpng','-r0');

show_face(face2);
fig = gcf;
fig.PaperPositionMode = 'auto';
print('face2','-dpng','-r0');

show_face(face3);
fig = gcf;
fig.PaperPositionMode = 'auto';
print('face3','-dpng','-r0');

show_face(reface1);
fig = gcf;
fig.PaperPositionMode = 'auto';
print('reface11','-dpng','-r0');

show_face(reface2);
fig = gcf;
fig.PaperPositionMode = 'auto';
print('reface21','-dpng','-r0');

show_face(reface3);
fig = gcf;
fig.PaperPositionMode = 'auto';
print('reface31','-dpng','-r0');

M = 25;
S2_eig_vec_sel = S2_eig_vec_adj(:, 1:M);

% Project each face onto each eigenvector, each row is a face
faces_coeff_training_sel = faces_coeff_training(:, 1:M);
faces_coeff_test_sel = faces_coeff_test(:, 1:M);

% Reconstruct each face.
faces_reconstructed_training = repmat(average_face, 1, N) + S2_eig_vec_sel * faces_coeff_training_sel';
faces_reconstructed_test = repmat(average_face, 1, P) + S2_eig_vec_sel * faces_coeff_test_sel';

reface1 = faces_reconstructed_training(:, 154);
reface2 = faces_reconstructed_training(:, 276);
reface3 = faces_reconstructed_test(:, 54);

show_face(reface1);
fig = gcf;
fig.PaperPositionMode = 'auto';
print('reface12','-dpng','-r0');

show_face(reface2);
fig = gcf;
fig.PaperPositionMode = 'auto';
print('reface22','-dpng','-r0');

show_face(reface3);
fig = gcf;
fig.PaperPositionMode = 'auto';
print('reface32','-dpng','-r0');

M = 50;
S2_eig_vec_sel = S2_eig_vec_adj(:, 1:M);

% Project each face onto each eigenvector, each row is a face
faces_coeff_training_sel = faces_coeff_training(:, 1:M);
faces_coeff_test_sel = faces_coeff_test(:, 1:M);

% Reconstruct each face.
faces_reconstructed_training = repmat(average_face, 1, N) + S2_eig_vec_sel * faces_coeff_training_sel';
faces_reconstructed_test = repmat(average_face, 1, P) + S2_eig_vec_sel * faces_coeff_test_sel';

reface1 = faces_reconstructed_training(:, 154);
reface2 = faces_reconstructed_training(:, 276);
reface3 = faces_reconstructed_test(:, 54);

show_face(reface1);
fig = gcf;
fig.PaperPositionMode = 'auto';
print('reface13','-dpng','-r0');

show_face(reface2);
fig = gcf;
fig.PaperPositionMode = 'auto';
print('reface23','-dpng','-r0');

show_face(reface3);
fig = gcf;
fig.PaperPositionMode = 'auto';
print('reface33','-dpng','-r0');

close all;