function [ indices ] = results( correct, incorrect, decision, labels, the_title, file_name )
% RESULTS Displays results
    % Right or wrong stuff
    percentage = 100 * correct/(correct + incorrect);
    disp(['Guessed ' num2str(correct) ' correctly and ' num2str(incorrect) ' incorrectly; Success rate is ' num2str(percentage) '%.']);
    
    % Wrong pics
    incorrect_vec = (decision ~= labels);
    indices = find(incorrect_vec);
    
    % Plot and save confusion matrix.
    figure('position', [0 0 800 800]);
    confuse_matrix = confusionmat(labels, decision);
    imagesc(confuse_matrix);
    colorbar;
    
    % Format data
    title(the_title, 'interpreter', 'latex');
    xlabel('Actual Class');
    ylabel('Class Guessed');

    % Format data
    set(findall(gcf,'type','axes'),'fontsize',25);
    set(findall(gcf,'type','text'),'fontSize',25);
    % Save data
    fig = gcf;
    fig.PaperPositionMode = 'auto';
    print(file_name,'-dpng','-r0');

    endg

