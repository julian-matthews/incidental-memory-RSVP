%% 2015-09-03 - RSVP analysis across subjects
% Skeleton script for basic, across-subject data analysis for RSVP. Will
% likely break this down into smaller scripts but check inside for details.

function RSVP_scatter_combined(plots, type, group)

% Create number string from the date (convertible with 'datestr' function)
date_string = mat2str(datenum(date));

figure_path = '../../figures/combined/';

for iteration = 1:length(group)
    
    % Specify version for this iteration & subject numbers
    ver_string = type{iteration};
    SubjNos = length(group{iteration});
    
    % Select appropriate figure folder
    if strcmp(ver_string,'Inverted-Faces')
        test_type = 'inverted/';
    elseif strcmp(ver_string, 'Upright-Faces')
        test_type = 'upright/';
    elseif strcmp(ver_string, 'Random-Faces_upr')
        test_type = 'RandFace_upright/';
    elseif strcmp(ver_string, 'Random-Faces_inv')
        test_type = 'RandFace_inverted/';    
    end
    
    % Save label for this struct
    Version(iteration).Label = ver_string;
    
    % Specify paths
    across_path = ['../../data/across_subjects/' test_type];
    
    % Load across_subject data from today's date
    % This will work in the context of RSVP_analysis or with data concatenated
    % the same day as across_subjects analysis but will need to manually enter
    % a date_string if you want to load older allTrials.mats
    
    % load([across_path '736211_RSVP_allTrials.mat']);
    load([across_path date_string '_RSVP_allTrials.mat']);
    
    %% CONFIDENCE/ACCURACY/METACOGNITION AT EACH LAG
    
    % Detect how many unique probe lag positions were used and what they are
    lag_positions = unique(data(:,6));
    lag_conditions = length(lag_positions);
    
    for lag = 1:lag_conditions
        
        % String with lag_positions in the first row
        Version(iteration).Lag_Conditions{lag} = num2str(lag_positions(lag));
        
        % Determine the lag position for this cycle of analysis
        lag_analysed = lag_positions(lag);
        
        % Select out just the rows corresponding to this lag position
        data_this_lag = data((data(:,6) == lag_analysed),:);
        
        % Save the matrix of data used in this lag's analysis
        Version(iteration).Data{lag} = data_this_lag;
        
        % Target-found trials in this condition
        Version(iteration).Trials(lag) = size(data_this_lag,1);
        
        % Store mean accuracy for this lag position
        Version(iteration).Accuracy(lag) = mean(data_this_lag(:,3));
        Version(iteration).Accuracy_SEM(lag) = std(data_this_lag(:,3),0,1)/sqrt(length(data_this_lag));
        
        % Store mean (absolute value) confidence at this lag position
        Version(iteration).Confidence(lag) = mean(abs(data_this_lag(:,2)));
        
        % Calculate standard deviation of (absolute) confidence for this lag
        Version(iteration).StD_Confidence(lag) = std(abs(data_this_lag(:,2)));
        
        % Subject counter to account for subjects with no useable data
        analysed_subjects = 0;
        
        % Means by subject
        for subj = 1:SubjNos
            
            subset = data_this_lag(data_this_lag(:,1) == subj,:);
            
            if isempty(subset)
                
                % One fewer subjects in SEM if no data included
                analysed_subjects = analysed_subjects - 1;
            end
            
            analysed_subjects = analysed_subjects + 1;
            
            Version(iteration).Subj_Accuracy(subj,lag) = mean(subset(:,3));
            Version(iteration).Subj_Confidence(subj,lag) = mean(abs(subset(:,2)));
            
            Frq = zeros(2,8);
            
            for row = 1:size(subset,1)
                for response = 1:4 % Right responses (recoded from 5:8 in acrossSubjects)
                    if subset(row,2) == response && subset(row,7) > 0
                        Frq(2,response+4) = (Frq(2,response+4)+1); % correct_rejection
                    elseif subset(row,2) == response && subset(row,7) < 0
                        Frq(1,(response+4)) = (Frq(1,(response+4)))+1; % miss
                    end
                end
                for response = -4:-1 % Left responses (-ve'd in acrossSubjects)
                    if subset(row,2) == response && subset(row,7) < 0
                        Frq(1,(response+5)) = (Frq(1,(response+5)))+1; % hit
                    elseif subset(row,2) == response && subset(row,7) > 0
                        Frq(2,(response+5)) = (Frq(2,(response+5)))+1; % false alarm
                    end
                end
                
            end
            
            % Convert to proportions
            for column = 1:length(Frq)
                Frq_Pro(1,column) = (Frq(1,column)/sum(Frq(1,:)));
                Frq_Pro(2,column) = (Frq(2,column)/sum(Frq(2,:)));
            end
            
            % Cumulative proportions
            for column = 1:length(Frq_Pro)
                Frq_Cum(1,column) = sum(Frq_Pro(1,(1:column)));
                Frq_Cum(2,column) = sum(Frq_Pro(2,(1:column)));
            end
            
            % Calculate area under ROC curve and store in RSVP struct per subj
            Version(iteration).Subj_AUC(subj,lag) = AreaUnderROC([Frq_Cum(1,:);Frq_Cum(2,:)]');
            
            %% TYPE-2 AUROC
            
            % Using 'type2roc' from Fleming & Chaun (2014)
            correct = subset(:,3);
            conf = abs(subset(:,2));
            Nratings = 4;
            
            % Store AUROC into RSVP struct
            Version(iteration).Subj_Type2_AUROC(subj, lag) = type2roc(correct', conf', Nratings);
            
            
            
            % Calculate means + SEMs
            Version(iteration).Subj_Accuracy_Mean(lag) = nanmean(Version(iteration).Subj_Accuracy(:,lag));
            Version(iteration).Subj_Accuracy_SEM(lag) = nanstd(Version(iteration).Subj_Accuracy(:,lag), 0, 1)/sqrt(analysed_subjects);
            
            Version(iteration).Subj_Confidence_Mean(lag) = nanmean(Version(iteration).Subj_Confidence(:,lag));
            Version(iteration).Subj_Confidence_SEM(lag) = nanstd(Version(iteration).Subj_Confidence(:,lag), 0, 1)/sqrt(analysed_subjects);
            
            Version(iteration).Subj_AUC_Mean(lag) = nanmean(Version(iteration).Subj_AUC(:,lag));
            Version(iteration).Subj_AUC_SEM(lag) = nanstd(Version(iteration).Subj_AUC(:,lag), 0, 1)/sqrt(analysed_subjects);
            
            Version(iteration).Subj_Type2_AUROC_Mean(lag) = nanmean(Version(iteration).Subj_Type2_AUROC(:,lag));
            Version(iteration).Subj_Type2_AUROC_SEM(lag) = nanstd(Version(iteration).Subj_Type2_AUROC(:,lag), 0, 1)/sqrt(analysed_subjects);
            
            %% TYPE-1 AUC
            % Alternate method using cumulative proportions
            
            Frq = zeros(2,8);
            
            for row = 1:size(data_this_lag,1)
                for response = 1:4 % Right responses (recoded from 5:8 in acrossSubjects)
                    if data_this_lag(row,2) == response && data_this_lag(row,7) > 0
                        Frq(2,response+4) = (Frq(2,response+4)+1); % correct_rejection
                    elseif data_this_lag(row,2) == response && data_this_lag(row,7) < 0
                        Frq(1,(response+4)) = (Frq(1,(response+4)))+1; % miss
                    end
                end
                for response = -4:-1 % Left responses (-ve'd in acrossSubjects)
                    if data_this_lag(row,2) == response && data_this_lag(row,7) < 0
                        Frq(1,(response+5)) = (Frq(1,(response+5)))+1; % hit
                    elseif data_this_lag(row,2) == response && data_this_lag(row,7) > 0
                        Frq(2,(response+5)) = (Frq(2,(response+5)))+1; % false alarm
                    end
                end
                
            end
            
            % Save to RSVP struct
            Version(iteration).Frequencies{lag} = Frq;
            
            % Convert to proportions
            for column = 1:length(Frq)
                Frq_Pro(1,column) = (Frq(1,column)/sum(Frq(1,:)));
                Frq_Pro(2,column) = (Frq(2,column)/sum(Frq(2,:)));
            end
            
            % Cumulative proportions
            for column = 1:length(Frq_Pro)
                Frq_Cum(1,column) = sum(Frq_Pro(1,(1:column)));
                Frq_Cum(2,column) = sum(Frq_Pro(2,(1:column)));
            end
            
            % Save to RSVP struct
            Version(iteration).Cum_Frq{lag} = Frq_Cum;
            
            % Calculate area under ROC curve and store in RSVP struct
            Version(iteration).AUC(lag) = AreaUnderROC([Frq_Cum(1,:);Frq_Cum(2,:)]');
            
            % AUC_Str{lag} = sprintf([Version(iteration).Lag_Conditions{lag} ' AUC: %.3f']...
            %    ,Version(iteration).AUC(lag));
            
            %% TYPE-2 AUC
            % CREATES A ROC-PLOT FOR POSTERITY (maybe remove 27/11/15)
            
            % Create matrix where:
            % Rows = categories of response (L or R)
            % Columns = confidence categories (-4 to 4)
            Frq2 = zeros(2, 4);
            
            % Total numbers of correct/incorrect trials per confidence rating
            for row = 1:size(subset,1)
                for response = 1:4 % Absolute values will be taken
                    if abs(subset(row,2)) == response && subset(row,3) == 1
                        Frq2(1,(5-response)) = (Frq2(1,(5-response))+1); % Correct
                    elseif abs(subset(row,2)) == response && subset(row,3) == 0
                        Frq2(2,(5-response)) = (Frq2(2,(5-response))+1); % Incorrect
                    end
                end
            end
            
            % Save to RSVP struct
            Version(iteration).Type2_Frequencies{lag} = Frq2;
            
            % Proportional Type-2
            for column = 1:length(Frq2)
                Frq2_Pro(1,column) = (Frq2(1,column)/sum(Frq2(1,:)));
                Frq2_Pro(2,column) = (Frq2(2,column)/sum(Frq2(2,:)));
            end
            
            % Cumulative Type-2
            for column = 1:length(Frq2_Pro)
                Frq2_Cum(1,column) = sum(Frq2_Pro(1,(1:column)));
                Frq2_Cum(2,column) = sum(Frq2_Pro(2,(1:column)));
            end
            
            % Save to struct
            Version(iteration).Cum_Frq2{lag} = Frq2_Cum;
            
            % Assign appropriate variables for using Fleming & Chau (2014)
            Version(iteration).Type2_AUC(subj,lag) = AreaUnderROC([Frq2_Cum(1,:);Frq2_Cum(2,:)]');
            
            % Typ2_AUC_Str{lag} = sprintf([Version(iteration).Lag_Conditions{lag} ' Typ2-AUC: %.3f']...
            %    ,Version(iteration).Type2_AUC(lag));
            
            Version(iteration).Subj_Type2_AUC_Mean(lag) = nanmean(Version(iteration).Type2_AUC(:,lag));
            Version(iteration).Subj_Type2_AUC_SEM(lag) = nanstd(Version(iteration).Type2_AUC(:,lag), 0, 1)/sqrt(analysed_subjects);
            
        end
        
    end
    
end

%% PLOTS and TABLES

if plots == 1
    
    % Open figure
    Accu_plot = figure;
    aHand = axes('parent', Accu_plot);
    hold(aHand, 'on')
    
    yPos = 0.5;
    
    xlim([0.5 4.5])
    
    colors = cool(length(type));
    
    offset = -0.1;
    
    for iteration = 1:length(type)
        
        offset = offset + 0.1;
        
        % Assign lag accuracies to 'y' for ease of reading
        y = Version(iteration).Subj_Accuracy_Mean;
        
        plot(get(gca,'xlim'), [yPos yPos], '--k');
        
        i = 1:numel(y);
        i = i + offset;
        
        errorbar(i,y, Version(iteration).Subj_Accuracy_SEM,...
            'LineStyle','none', ...
            'Color',colors(iteration,:),...
            'LineWidth',1);
        
        h(iteration) = plot(i, y,'MarkerFaceColor',colors(iteration,:),'Marker','o',...
            'Color',colors(iteration,:),...
            'MarkerEdgeColor',colors(iteration,:),...
            'LineWidth',1);
        
    end
    
    set(gca, 'XTick', 1:numel(y), 'XTickLabel', Version(iteration).Lag_Conditions)
    
    ylim([0.3 0.9])
    xlabel('Lag Position')
    ylabel('p(Correct)')
    
    temp = sprintf('Mean Probe Accuracy');
    
    title(temp)
    
    legend([h(1) h(2) h(3) h(4)],{type{1} type{2} type{3} type{4}}); legend boxoff;
    
    saveas(gcf,[figure_path date_string '_Accuracy'],'fig');
    print(gcf, '-dtiff',[figure_path date_string '_Accuracy'])
    
    hold off
    
    close(Accu_plot);
    
    %% MEAN CONFIDENCE PLOT
    
    % Open figure
    Confid_plot = figure;
    aHand = axes('parent', Confid_plot);
    hold(aHand, 'on')
    
    colors = cool(length(type));
    
    offset = -0.1;
    
    for iteration = 1:length(type)
        
        offset = offset + 0.1;
        
        % Assign lag accuracies to 'y' for ease of reading
        y = Version(iteration).Subj_Confidence_Mean;
        
        i = 1:numel(y);
        i = i + offset;
        
        errorbar(i,y, Version(iteration).Subj_Confidence_SEM,...
            'LineStyle','none', ...
            'Color',colors(iteration,:),...
            'LineWidth',1);
        
        this_title = sprintf('Session %d',iteration);
        
        h(iteration) = plot(i,y,'MarkerFaceColor',colors(iteration,:),'Marker','o',...
            'Color',colors(iteration,:),...
            'MarkerEdgeColor',colors(iteration,:),...
            'LineWidth',1,...
            'DisplayName',this_title);
        
    end
    
    set(gca, 'XTick', 1:numel(y), 'XTickLabel', Version(iteration).Lag_Conditions)
    
    ylim([1 4])
    xlabel('Lag Position')
    ylabel('Confidence Level (1:4)')
    
    temp = sprintf('Mean Confidence');
    
    title(temp)
    
    legend([h(1) h(2) h(3) h(4)],{type{1} type{2} type{3} type{4}}); legend boxoff;
    
    saveas(gcf,[figure_path date_string '_Confidence'],'fig');
    print(gcf, '-dtiff',[figure_path date_string '_Confidence'])
    
    hold off
    
    close(Confid_plot);
    
    %% MEAN TYPE-1 AUC PLOT
    
    % Open figure
    Typ1AUC_plot = figure;
    aHand = axes('parent', Typ1AUC_plot);
    hold(aHand, 'on')
    
    yPos = 0.5;
    
    xlim([0.5 4.5])
    
    colors = cool(length(type));
    
    offset = -0.1;
    
    for iteration = 1:length(type)
        
        offset = offset + 0.1;
        
        % Assign lag accuracies to 'y' for ease of reading
        y = Version(iteration).Subj_AUC_Mean;
        
        plot(get(gca,'xlim'), [yPos yPos], '--k');
        
        i = 1:numel(y);
        i = i + offset;
        
        errorbar(i,y, Version(iteration).Subj_AUC_SEM,...
            'LineStyle','none', ...
            'Color',colors(iteration,:),...
            'LineWidth',1);
        
        this_title = sprintf('Session %d',iteration);
        
        h(iteration) = plot(i, y,'MarkerFaceColor',colors(iteration,:),'Marker','o',...
            'Color',colors(iteration,:),...
            'MarkerEdgeColor',colors(iteration,:),...
            'LineWidth',1,...
            'DisplayName',this_title);
        
    end
    
    set(gca, 'XTick', 1:numel(y), 'XTickLabel', Version(iteration).Lag_Conditions)
    
    ylim([0.3 0.9])
    
    xlabel('Lag Position')
    ylabel('Area Under Curve (Type-1)')
    
    temp = sprintf('Objective Performance');
    
    title(temp)
    
    legend([h(1) h(2) h(3) h(4)],{type{1} type{2} type{3} type{4}}); legend boxoff;
    
    saveas(gcf,[figure_path date_string '_Obj_Performance'],'fig');
    print(gcf, '-dtiff',[figure_path date_string '_Obj_Performance'])
    
    hold off
    
    close(Typ1AUC_plot);
    
    %% MEAN TYPE-2 AUROC PLOT
    
    % Open figure
    Typ2AUC_plot = figure;
    aHand = axes('parent', Typ2AUC_plot);
    hold(aHand, 'on')
    
    yPos = 0.5;
    
    xlim([0.5 4.5])
    
    colors = cool(length(type));
    
    offset = -0.1;
    
    for iteration = 1:length(type)
        
        offset = offset + 0.1;
        
        % Assign lag accuracies to 'y' for ease of reading
        y = Version(iteration).Subj_Type2_AUROC_Mean;
        
        plot(get(gca,'xlim'), [yPos yPos], '--k');
        
        i = 1:numel(y);
        i = i + offset;
        
        errorbar(i,y, Version(iteration).Subj_Type2_AUROC_SEM,...
            'LineStyle','none', ...
            'Color',colors(iteration,:),...
            'LineWidth',1);
        
        this_title = sprintf('Session %d',iteration);
        
        h(iteration) = plot(i, y,'MarkerFaceColor',colors(iteration,:),'Marker','o',...
            'Color',colors(iteration,:),...
            'MarkerEdgeColor',colors(iteration,:),...
            'LineWidth',1,...
            'DisplayName',this_title);
        
    end
    
    set(gca, 'XTick', 1:numel(y), 'XTickLabel', Version(iteration).Lag_Conditions)
    
    ylim([0.3 0.9])
    
    xlabel('Lag Position')
    ylabel('Type-2 AUROC')
    
    temp = sprintf('Metacognition: AUROC, Fleming & Lau (2014)');
    
    title(temp)
    
    legend([h(1) h(2) h(3) h(4)],{type{1} type{2} type{3} type{4}}); legend boxoff;
    
    saveas(gcf,[figure_path date_string '_Metacognition_AUROC'],'fig');
    print(gcf, '-dtiff',[figure_path date_string '_Metacognition_AUROC'])
    
    hold off
    
    close(Typ2AUC_plot);
    
    %% MEAN TYPE-2 AUC PLOT
    
    % Open figure
    Typ2AUC_plot = figure;
    aHand = axes('parent', Typ2AUC_plot);
    hold(aHand, 'on')
    
    yPos = 0.5;
    
    xlim([0.5 4.5])
    
    colors = cool(length(type));
    
    offset = -0.1;
    
    for iteration = 1:length(type)
        
        offset = offset + 0.1;
        
        % Assign lag accuracies to 'y' for ease of reading
        y = Version(iteration).Subj_Type2_AUC_Mean;
        
        plot(get(gca,'xlim'), [yPos yPos], '--k');
        
        i = 1:numel(y);
        i = i + offset;
        
        errorbar(i,y, Version(iteration).Subj_Type2_AUC_SEM,...
            'LineStyle','none', ...
            'Color',colors(iteration,:),...
            'LineWidth',1);
        
        this_title = sprintf('Session %d',iteration);
        
        h(iteration) = plot(i, y,'MarkerFaceColor',colors(iteration,:),'Marker','o',...
            'Color',colors(iteration,:),...
            'MarkerEdgeColor',colors(iteration,:),...
            'LineWidth',1,...
            'DisplayName',this_title);
        
    end
    
    set(gca, 'XTick', 1:numel(y), 'XTickLabel', Version(iteration).Lag_Conditions)
    
    ylim([0.3 0.9])
    
    xlabel('Lag Position')
    ylabel('Type-2 AUC')
    
    temp = sprintf('Metacognition: Type-2 AUC');
    
    title(temp)
    
    legend([h(1) h(2) h(3) h(4)],{type{1} type{2} type{3} type{4}}); legend boxoff;
    
    saveas(gcf,[figure_path date_string '_Metacognition_Typ2AUC'],'fig');
    print(gcf, '-dtiff',[figure_path date_string '_Metacognition_Typ2AUC'])
    
    hold off
    
    close(Typ2AUC_plot);
    
end


end