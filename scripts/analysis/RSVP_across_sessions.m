%% 2015-09-03 - RSVP analysis across subjects
% Skeleton script for basic, across-subject data analysis for RSVP. Will
% likely break this down into smaller scripts but check inside for details.

function RSVP_across_sessions(plots, SubjNos, version)

% Create number string from the date (convertible with 'datestr' function)
date_string = mat2str(datenum(date));

% Select appropriate figure folder
if strcmp(version,'Inverted-Faces')
    test_type = 'inverted/';
elseif strcmp(version, 'Upright-Faces')
    test_type = 'upright/';
elseif strcmp(version, 'Random-Faces_upr')
    test_type = 'RandFace_upright/';
elseif strcmp(version, 'Random-Faces_inv')
    test_type = 'RandFace_inverted/';
end

% Select AUC method
AUC_method = 3; % calculate_AUC(1), Gabor task method(2), Hawkin Lau type2roc(3)

% If plots = 1: creates and saves bar plot of accuracy + ROC curves at each lag
% plots = 1;

% Use absolute confidence for plots with x-axis = confidence
abs_confid = 1; % 1:4(1) or -4:4(0)

% Specify paths
across_path = ['../../data/across_subjects/' test_type];
figure_path = ['../../figures/training/' test_type];
results_path = '../../results/';

% Load across_subject data from today's date
% This will work in the context of RSVP_analysis or with data concatenated
% the same day as across_subjects analysis but will need to manually enter
% a date_string if you want to load older allTrials.mats

% load([across_path '736211_RSVP_allTrials.mat']);
load([across_path date_string '_RSVP_allTrials.mat']);

all_data = data;

%% CONFIDENCE/ACCURACY/METACOGNITION AT EACH LAG

% Detect how many unique probe lag positions were used and what they are
lag_positions = unique(all_data(:,6));
lag_conditions = length(lag_positions);

for session = 1:max(all_data(:,10))
    
    data = all_data(all_data(:,10) == session,:);
    
    for lag = 1:lag_conditions
        
        % String with lag_positions in the first row
        Session(session).RSVP.Lag_Conditions{lag} = num2str(lag_positions(lag));
        
        % Determine the lag position for this cycle of analysis
        lag_analysed = lag_positions(lag);
        
        % Select out just the rows corresponding to this lag position
        data_this_lag = data((data(:,6) == lag_analysed),:);
        
        % Save the matrix of data used in this lag's analysis
        Session(session).RSVP.Data{lag} = data_this_lag;
        
        % Target-found trials in this condition
        Session(session).RSVP.Trials(lag) = size(data_this_lag,1);
        
        % Store mean accuracy for this lag position
        Session(session).RSVP.Accuracy(lag) = mean(data_this_lag(:,3));
        Session(session).RSVP.Accuracy_SEM(lag) = std(data_this_lag(:,3),0,1)/sqrt(length(data_this_lag));
        
        % Store mean (absolute value) confidence at this lag position
        Session(session).RSVP.Confidence(lag) = mean(abs(data_this_lag(:,2)));
        
        % Calculate standard deviation of (absolute) confidence for this lag
        Session(session).RSVP.StD_Confidence(lag) = std(abs(data_this_lag(:,2)));
        
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
            
            Session(session).RSVP.Subj_Accuracy(subj,lag) = mean(subset(:,3));
            Session(session).RSVP.Subj_Confidence(subj,lag) = mean(abs(subset(:,2)));
            
            if AUC_method == 2 || AUC_method == 3
                % Alternate method using cumulative proportions
                
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
                Session(session).RSVP.Subj_AUC(subj,lag) = AreaUnderROC([Frq_Cum(1,:);Frq_Cum(2,:)]');
                
            end
            
            %% TYPE-2 AUC
            
            if AUC_method == 3
                
                % Using 'type2roc' from Fleming & Chaun (2014)
                correct = subset(:,3);
                conf = abs(subset(:,2));
                Nratings = 4;
                
                % Store AUROC into RSVP struct
                Session(session).RSVP.Subj_Type2_AUC(subj, lag) = type2roc(correct', conf', Nratings);
                
            end
            
            % Calculate means + SEMs
            Session(session).RSVP.Subj_Accuracy_Mean(lag) = nanmean(Session(session).RSVP.Subj_Accuracy(:,lag));
            Session(session).RSVP.Subj_Accuracy_SEM(lag) = nanstd(Session(session).RSVP.Subj_Accuracy(:,lag), 0, 1)/sqrt(analysed_subjects);
            
            Session(session).RSVP.Subj_Confidence_Mean(lag) = nanmean(Session(session).RSVP.Subj_Confidence(:,lag));
            Session(session).RSVP.Subj_Confidence_SEM(lag) = nanstd(Session(session).RSVP.Subj_Confidence(:,lag), 0, 1)/sqrt(analysed_subjects);
            
            Session(session).RSVP.Subj_AUC_Mean(lag) = nanmean(Session(session).RSVP.Subj_AUC(:,lag));
            Session(session).RSVP.Subj_AUC_SEM(lag) = nanstd(Session(session).RSVP.Subj_AUC(:,lag), 0, 1)/sqrt(analysed_subjects);
            
            Session(session).RSVP.Subj_Type2_AUC_Mean(lag) = nanmean(Session(session).RSVP.Subj_Type2_AUC(:,lag));
            Session(session).RSVP.Subj_Type2_AUC_SEM(lag) = nanstd(Session(session).RSVP.Subj_Type2_AUC(:,lag), 0, 1)/sqrt(analysed_subjects);
            
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
            Session(session).RSVP.Frequencies{lag} = Frq;
            
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
            Session(session).RSVP.Cum_Frq{lag} = Frq_Cum;
            
            % Calculate area under ROC curve and store in RSVP struct
            Session(session).RSVP.AUC(lag) = AreaUnderROC([Frq_Cum(1,:);Frq_Cum(2,:)]');
            
            AUC_Str{lag} = sprintf([Session(session).RSVP.Lag_Conditions{lag} ' AUC: %.3f']...
                ,Session(session).RSVP.AUC(lag));
            
            %% TYPE-2 AUC
            % CREATES A ROC-PLOT FOR POSTERITY (maybe remove 27/11/15)
            
            % Create matrix where:
            % Rows = categories of response (L or R)
            % Columns = confidence categories (-4 to 4)
            Frq2 = zeros(2, 4);
            
            % Total numbers of correct/incorrect trials per confidence rating
            for row = 1:size(data_this_lag,1)
                for response = 1:4 % Absolute values will be taken
                    if abs(data_this_lag(row,2)) == response && data_this_lag(row,3) == 1
                        Frq2(1,(5-response)) = (Frq2(1,(5-response))+1); % Correct
                    elseif abs(data_this_lag(row,2)) == response && data_this_lag(row,3) == 0
                        Frq2(2,(5-response)) = (Frq2(2,(5-response))+1); % Incorrect
                    end
                end
            end
            
            % Save to RSVP struct
            Session(session).RSVP.Type2_Frequencies{lag} = Frq2;
            
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
            
            % Save to RSVP struct
            Session(session).RSVP.Cum_Frq2{lag} = Frq2_Cum;
            
            % Assign appropriate variables for using Fleming & Chau (2014)
            correct = data_this_lag(:,3);
            conf = abs(data_this_lag(:,2));
            Nratings = 4;
            
            Session(session).RSVP.Type2_AUC(lag) = type2roc(correct', conf', Nratings);
            
            Typ2_AUC_Str{lag} = sprintf([Session(session).RSVP.Lag_Conditions{lag} ' Typ2-AUC: %.3f']...
                ,Session(session).RSVP.Type2_AUC(lag));
            
            
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
    
    colors = cool(max(all_data(:,10)));
    
    for session = 1:max(all_data(:,10))
        
        % Assign lag accuracies to 'y' for ease of reading
        y = Session(session).RSVP.Subj_Accuracy_Mean;
        
        plot(get(gca,'xlim'), [yPos yPos], '--k');
        
        for i = 1:numel(y)
            errorbar(i,y(i), Session(session).RSVP.Subj_Accuracy_SEM(i),...
                'LineStyle','none', ...
                'Color',colors(session,:),...
                'LineWidth',1);
        end
        
        this_title = sprintf('Session %d',session);
        
        h(session) = plot(y,'MarkerFaceColor',colors(session,:),'Marker','^',...
            'Color',colors(session,:),...
            'MarkerEdgeColor',colors(session,:),...
            'LineWidth',1,...
            'DisplayName',this_title);
        
    end
    
    set(gca, 'XTick', 1:numel(y), 'XTickLabel', Session(session).RSVP.Lag_Conditions)
    
    % ylim([0.5 0.8])
    ylim([0 1])
    xlabel('Lag Position')
    ylabel('p(Correct)')
    
    temp = sprintf('Mean Probe Accuracy at each Lag Position (Ver: %s, n = %s)',version, num2str(analysed_subjects));
    
    title(temp)
    
    legend([h(1) h(2)],{'Session 1' 'Session 2'}); legend boxoff;
    
    print(gcf, '-dtiff',[figure_path date_string '_RSVP_Accuracies'])
    
    hold off
    
    close(Accu_plot);
    
    %% MEAN CONFIDENCE PLOT
    
    % Open figure
    Confid_plot = figure;
    aHand = axes('parent', Confid_plot);
    hold(aHand, 'on')
    
    colors = cool(max(all_data(:,10)));
    
    for session = 1:max(all_data(:,10))
        
        % Assign lag accuracies to 'y' for ease of reading
        y = Session(session).RSVP.Subj_Confidence_Mean;
        
        for i = 1:numel(y)
            errorbar(i,y(i), Session(session).RSVP.Subj_Confidence_SEM(i),...
                'LineStyle','none', ...
                'Color',colors(session,:),...
                'LineWidth',1);
        end
        
        this_title = sprintf('Session %d',session);
        
        h(session) = plot(y,'MarkerFaceColor',colors(session,:),'Marker','^',...
            'Color',colors(session,:),...
            'MarkerEdgeColor',colors(session,:),...
            'LineWidth',1,...
            'DisplayName',this_title);
        
    end
    
    set(gca, 'XTick', 1:numel(y), 'XTickLabel', Session(session).RSVP.Lag_Conditions)
    
    ylim([1 4])
    xlabel('Lag Position')
    ylabel('Confidence Level (1:4)')
    
    temp = sprintf('Mean Confidence at each Lag Position (Ver: %s, n = %s)',version, num2str(analysed_subjects));
    
    title(temp)
    
    legend([h(1) h(2)],{'Session 1' 'Session 2'}); legend boxoff;
    
    print(gcf, '-dtiff',[figure_path date_string '_RSVP_Confidence'])
    
    hold off
    
    close(Confid_plot);
    
    %% MEAN TYPE-2 AUC PLOT
    
    % Open figure
    Typ1AUC_plot = figure;
    aHand = axes('parent', Typ1AUC_plot);
    hold(aHand, 'on')
    
    yPos = 0.5;
    
    xlim([0.5 4.5])
    
    colors = cool(max(all_data(:,10)));
    
    for session = 1:max(all_data(:,10))
        
        % Assign lag accuracies to 'y' for ease of reading
        y = Session(session).RSVP.Subj_AUC_Mean;
        
        plot(get(gca,'xlim'), [yPos yPos], '--k');
        
        for i = 1:numel(y)
            errorbar(i,y(i), Session(session).RSVP.Subj_AUC_SEM(i),...
                'LineStyle','none', ...
                'Color',colors(session,:),...
                'LineWidth',1);
        end
        
        this_title = sprintf('Session %d',session);
        
        h(session) = plot(y,'MarkerFaceColor',colors(session,:),'Marker','^',...
            'Color',colors(session,:),...
            'MarkerEdgeColor',colors(session,:),...
            'LineWidth',1,...
            'DisplayName',this_title);
        
    end
    
    set(gca, 'XTick', 1:numel(y), 'XTickLabel', Session(session).RSVP.Lag_Conditions)
    
    ylim([0.4 1])
    
    xlabel('Lag Position')
    ylabel('Area Under Curve (Type-1)')
    
    temp = sprintf('Mean Type1-AUCs at each Lag Position (Ver: %s, n = %s)',version, num2str(analysed_subjects));
    
    title(temp)
    
    legend([h(1) h(2)],{'Session 1' 'Session 2'}); legend boxoff;
    
    print(gcf, '-dtiff',[figure_path date_string '_RSVP_Mean_AUCs'])
    
    hold off
    
    close(Typ1AUC_plot);
    
    %% MEAN TYPE-2 AUC PLOT
    
    % Open figure
    Typ2AUC_plot = figure;
    aHand = axes('parent', Typ2AUC_plot);
    hold(aHand, 'on')
    
    yPos = 0.5;
    
    xlim([0.5 4.5])
    
    colors = cool(max(all_data(:,10)));
    
    for session = 1:max(all_data(:,10))
        
        % Assign lag accuracies to 'y' for ease of reading
        y = Session(session).RSVP.Subj_Type2_AUC_Mean;
        
        plot(get(gca,'xlim'), [yPos yPos], '--k');
        
        for i = 1:numel(y)
            errorbar(i,y(i), Session(session).RSVP.Subj_Type2_AUC_SEM(i),...
                'LineStyle','none', ...
                'Color',colors(session,:),...
                'LineWidth',1);
        end
        
        this_title = sprintf('Session %d',session);
        
        h(session) = plot(y,'MarkerFaceColor',colors(session,:),'Marker','^',...
            'Color',colors(session,:),...
            'MarkerEdgeColor',colors(session,:),...
            'LineWidth',1,...
            'DisplayName',this_title);
        
    end
    
    set(gca, 'XTick', 1:numel(y), 'XTickLabel', Session(session).RSVP.Lag_Conditions)
    
    ylim([0.4 1])
    
    xlabel('Lag Position')
    ylabel('Area Under Curve (Type-2)')
    
    temp = sprintf('Mean Type2-AUCs at each Lag Position (Ver: %s, n = %s)',version, num2str(analysed_subjects));
    
    title(temp)
    
    legend([h(1) h(2)],{'Session 1' 'Session 2'}); legend boxoff;
    
    print(gcf, '-dtiff',[figure_path date_string '_RSVP_Mean_Metacognition'])
    
    hold off
    
    close(Typ2AUC_plot);
    
    %% TYPE-1 AUC PLOT
    
    %     AUC_plot = figure;
    %
    %     % Redefine colour palette
    %     colors = hsv(4);
    %
    %     % Plot remaining lags
    %     for lag = 1:lag_conditions
    %
    %         plot([0,RSVP.Cum_Frq{lag}(2,:),1],...
    %             [0,RSVP.Cum_Frq{lag}(1,:),1],'o-', 'Color',colors(lag,:))
    %         hold on
    %
    %     end
    %
    %     % Assign strings for legend
    %     legend(AUC_Str{1:lag_conditions}, 'Location', 'SouthEast')
    %     xlabel('False Positive Rate')
    %     ylabel('True Positive Rate')
    %
    %     ylim([0 1])
    %     xlim([0 1])
    %     % save
    %     title('ROC Curve at each Lag Position')
    %     print(gcf, '-djpeg',[figure_path date_string '_RSVP_ROCs'])
    %
    %     hold off
    %
    %     close(AUC_plot);
    %
    %     %% TYPE-2 AUC PLOT
    %
    %     Typ2_AUC_plot = figure;
    %
    %     % Plot remaining lags
    %     for lag = 1:lag_conditions
    %
    %         plot([0,RSVP.Cum_Frq2{lag}(2,:),1],...
    %             [0,RSVP.Cum_Frq2{lag}(1,:),1],'o-', 'Color',colors(lag,:))
    %         hold on
    %
    %     end
    %
    %     % Assign strings for legend
    %     legend(Typ2_AUC_Str{1:lag_conditions}, 'Location', 'SouthEast')
    %     xlabel('False Positive Rate')
    %     ylabel('True Positive Rate')
    %
    %     ylim([0 1])
    %     xlim([0 1])
    %
    %     % save
    %     title('Type2 ROC Curve at each Lag Position')
    %     print(gcf, '-djpeg',[figure_path date_string '_RSVP_Typ2_ROCs'])
    %
    %     hold off
    %
    %     close(Typ2_AUC_plot);
    
end

%% RT to detect target


end