% Acquire saved PCA data.
% Get resource path
res_path = get_res_path();

% Define matrix resource path
data_path = strjoin({res_path 'pca.mat'}, filesep);

% Load data and exit
load(data_path);

% Plot AAT eigenvalues
S_eig_val_col = sum(S_eig_val, 2);

close all;

figure('position', [0 0 1280 800]);
plot(1:length(S_eig_val_col), abs(S_eig_val_col), 'linewidth', 10);

title('Eigenvalues of $$S = AA^T$$', 'interpreter', 'latex');
xlabel('Number');
ylabel('Value');
grid;

% If legends exists
% set(leg,'FontSize',25);
% Format data
set(findall(gcf,'type','axes'),'fontsize',50);
set(findall(gcf,'type','text'),'fontSize',50);
% Save data
fig = gcf;
fig.PaperPositionMode = 'auto';
print('S_eig_val','-dpng','-r0');

% Plot AAT eigenvalues, rounded
S_eig_val_rounded = round(S_eig_val, 10);
S_eig_val_rounded = S_eig_val_rounded(S_eig_val_rounded ~= 0);
S_eig_val_col_rounded = sum(S_eig_val_rounded, 2);

figure('position', [0 0 1280 800]);
plot(1:length(S_eig_val_col_rounded), abs(S_eig_val_col_rounded), 'linewidth', 10);

title('Eigenvalues of $$S = AA^T$$', 'interpreter', 'latex');
xlabel('Number');
ylabel('Value');
grid;

% If legends exists
% set(leg,'FontSize',25);
% Format data
set(findall(gcf,'type','axes'),'fontsize',50);
set(findall(gcf,'type','text'),'fontSize',50);
% Save data
fig = gcf;
fig.PaperPositionMode = 'auto';
print('S_eig_val_rounded','-dpng','-r0');

% Plot ATA eigenvalues, rounded immediately
S2_eig_val_rounded = round(S2_eig_val, 10);
S2_eig_val_rounded = S2_eig_val_rounded(S2_eig_val_rounded ~= 0);
S2_eig_val_col_rounded = sum(S2_eig_val_rounded, 2);

figure('position', [0 0 1280 800]);
plot(1:length(S2_eig_val_col_rounded), abs(S2_eig_val_col_rounded), 'linewidth', 10);


title('Eigenvalues of $$S = A^{T}A$$', 'interpreter', 'latex');
xlabel('Number');
ylabel('Value');
grid;

% If legends exists
% set(leg,'FontSize',25);
% Format data
set(findall(gcf,'type','axes'),'fontsize',50);
set(findall(gcf,'type','text'),'fontSize',50);
% Save data
fig = gcf;
fig.PaperPositionMode = 'auto';
print('S2_eig_val_rounded','-dpng','-r0');

S2_eig_vec_adj = A * S2_eig_vec;
S2_eig_vec_adj = normc(S2_eig_vec_adj);

% Show and save 3 eigenfaces, S=AAT.
for index = 1:3
    show_face(S_eig_vec(:, index));
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    name = ['eigface', num2str(index)];
    print(name,'-dpng','-r0');
end

% Show and save 4 eigenfaces, S=ATA.
for index = 4:7
    show_face(S2_eig_vec_adj(:, index - 3));
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    name = ['eigface', num2str(index)];
    print(name,'-dpng','-r0');
end


