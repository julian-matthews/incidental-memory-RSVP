%% 2015-09-03 - RSVP analysis across subjects
% Skeleton script for basic, across-subject data analysis for RSVP. Will
% likely break this down into smaller scripts but check inside for details.

function RSVP_across_subjects(plots, SubjNos, version)

% Create number string from the date (convertible with 'datestr' function)
date_string = mat2str(datenum(date));

% Select appropriate figure folder
if strcmp(version,'Inverted-Faces')
    test_type = 'inverted/';
elseif strcmp(version, 'Upright-Faces')
    test_type = 'upright/';
elseif strcmp(version, 'Random-Faces')
    test_type = 'RandFace_upright/';
elseif strcmp(version, 'Random-Faces_inv')
    test_type = 'RandFace_inverted/';
elseif strcmp(version,'NoTarget-Upright')
    test_type = 'NoTarget_upright/';
end

% Select AUC method
AUC_method = 3; % calculate_AUC(1), Gabor task method(2), Hawkin Lau type2roc(3)

% If plots = 1: creates and saves bar plot of accuracy + ROC curves at each lag
% plots = 1;

% Use absolute confidence for plots with x-axis = confidence
abs_confid = 1; % 1:4(1) or -4:4(0)

% Specify paths
across_path = ['../../data/across_subjects/' test_type];
figure_path = ['../../figures/' test_type];
results_path = '../../results/';

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
    RSVP.Lag_Conditions{lag} = num2str(lag_positions(lag));
    
    % Determine the lag position for this cycle of analysis
    lag_analysed = lag_positions(lag);
    
    % Select out just the rows corresponding to this lag position
    data_this_lag = data((data(:,6) == lag_analysed),:);
    
    % Save the matrix of data used in this lag's analysis
    RSVP.Data{lag} = data_this_lag;
    
    % Target-found trials in this condition
    RSVP.Trials(lag) = size(data_this_lag,1);
    
    % Store mean accuracy for this lag position
    RSVP.Accuracy(lag) = mean(data_this_lag(:,3));
    RSVP.Accuracy_SEM(lag) = std(data_this_lag(:,3),0,1)/sqrt(length(data_this_lag));
    
    % Store mean (absolute value) confidence at this lag position
    RSVP.Confidence(lag) = mean(abs(data_this_lag(:,2)));
    
    % Calculate standard deviation of (absolute) confidence for this lag
    RSVP.StD_Confidence(lag) = std(abs(data_this_lag(:,2)));
    
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
        
        RSVP.Subj_Accuracy(subj,lag) = mean(subset(:,3));
        RSVP.Subj_Confidence(subj,lag) = mean(abs(subset(:,2)));
        
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
            RSVP.Subj_AUC(subj,lag) = AreaUnderROC([Frq_Cum(1,:);Frq_Cum(2,:)]');
            
        end
        
        %% TYPE-2 AUC
        
        if AUC_method == 2
            
            % Copied from Gabor task, need to double-check for errors
            % (27/11/15)
            
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
            
            % Calculate area under ROC curve and store in RSVP struct
            RSVP.Subj_Type2_AUC(subj,lag) = AreaUnderROC([Frq2_Cum(1,:);Frq2_Cum(2,:)]');
            
        end
        
        if AUC_method == 3
            
            % Using 'type2roc' from Fleming & Chaun (2014)
            correct = subset(:,3);
            conf = abs(subset(:,2));
            Nratings = 4;
            
            % Store AUROC into RSVP struct
            RSVP.Subj_Type2_AUC(subj, lag) = type2roc(correct', conf', Nratings);
            
        end
        
        % Calculate means + SEMs
        RSVP.Subj_Accuracy_Mean(lag) = nanmean(RSVP.Subj_Accuracy(:,lag));
        RSVP.Subj_Accuracy_SEM(lag) = nanstd(RSVP.Subj_Accuracy(:,lag), 0, 1)/sqrt(analysed_subjects);
        
        RSVP.Subj_Confidence_Mean(lag) = nanmean(RSVP.Subj_Confidence(:,lag));
        RSVP.Subj_Confidence_SEM(lag) = nanstd(RSVP.Subj_Confidence(:,lag), 0, 1)/sqrt(analysed_subjects);
        
        RSVP.Subj_AUC_Mean(lag) = nanmean(RSVP.Subj_AUC(:,lag));
        RSVP.Subj_AUC_SEM(lag) = nanstd(RSVP.Subj_AUC(:,lag), 0, 1)/sqrt(analysed_subjects);
        
        RSVP.Subj_Type2_AUC_Mean(lag) = nanmean(RSVP.Subj_Type2_AUC(:,lag));
        RSVP.Subj_Type2_AUC_SEM(lag) = nanstd(RSVP.Subj_Type2_AUC(:,lag), 0, 1)/sqrt(analysed_subjects);
        
        %% TYPE-1 AUC
        if AUC_method == 1
            % Pia's method using calculate_AUC.m
            % Returns different value so may be incorrect
            
            Frequencies = zeros(2,4);
            
            for row = 1:2
                for column = 1:4
                    Frequencies(row,column) = ...
                        sum(abs(data_this_lag(:,2)) == column ...
                        & data_this_lag(:,3) ~= row-1);
                end
            end
            
            RSVP.Frequencies{lag} = Frequencies;
            
            [~, RSVP.AUC(lag)] = calculate_AUC(Frequencies);
            
        elseif AUC_method == 2 || AUC_method == 3
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
            RSVP.Frequencies{lag} = Frq;
            
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
            RSVP.Cum_Frq{lag} = Frq_Cum;
            
            % Calculate area under ROC curve and store in RSVP struct
            RSVP.AUC(lag) = AreaUnderROC([Frq_Cum(1,:);Frq_Cum(2,:)]');
            
            AUC_Str{lag} = sprintf([RSVP.Lag_Conditions{lag} ' AUC: %.3f']...
                ,RSVP.AUC(lag));
            
        end
        
        %% TYPE-2 AUC
        
        if AUC_method == 2
            
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
            RSVP.Type2_Frequencies{lag} = Frq2;
            
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
            RSVP.Cum_Frq2{lag} = Frq2_Cum;
            
            % Calculate area under ROC curve and store in RSVP struct
            RSVP.Type2_AUC(lag) = AreaUnderROC([Frq2_Cum(1,:);Frq2_Cum(2,:)]');
            
            Typ2_AUC_Str{lag} = sprintf([RSVP.Lag_Conditions{lag} ' Typ2-AUC: %.3f']...
                ,RSVP.Type2_AUC(lag));
            
        end
        
        if AUC_method == 3
            %% CREATES A ROC-PLOT FOR POSTERITY (maybe remove 27/11/15)
            
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
            RSVP.Type2_Frequencies{lag} = Frq2;
            
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
            RSVP.Cum_Frq2{lag} = Frq2_Cum;
            
            % Assign appropriate variables for using Fleming & Chau (2014)
            correct = data_this_lag(:,3);
            conf = abs(data_this_lag(:,2));
            Nratings = 4;
            
            RSVP.Type2_AUC(lag) = type2roc(correct', conf', Nratings);
            
            Typ2_AUC_Str{lag} = sprintf([RSVP.Lag_Conditions{lag} ' Typ2-AUC: %.3f']...
                ,RSVP.Type2_AUC(lag));
        end
        
    end
    
end

%% MEAN ACCURACIES AT EACH LAG/CONFIDENCE PERMUTATION

% Requires data(:,2) = confidence, data(:,3) = accuracy, data(:,6) = lag
% Confidence levels are set -4 to 4 but lags are determined
[MeanAccuracies] = acc_at_conf(data);

if abs_confid == 0
    
    % Determine number and value of unique confidence levels
    confid_levels = unique(data(:,2))';
    confid_conditions = length(confid_levels);
    
    for confid = 1:confid_conditions
        confid_strings{confid} = num2str(confid_levels(confid));
    end
    
    % Plots of accuracies at each lag position
    if plots == 1
        %% BAR GRAPH OF MEAN ACCURACIES FOR EACH CONFIDENCE LEVEL
        
        % Assign lag accuracies to 'y' for ease of reading
        y = MeanAccuracies.mAcc;
        
        % Open figure
        mAcc_plot = figure;
        hold on
        
        bar(y)
        set(gca, 'XTick', 1:numel(y), 'XTickLabel', confid_strings)
        
        ylim([0 1])
        xlabel('Confidence Level')
        ylabel('p(Correct)')
        
        temp = sprintf('Mean Probe Accuracy at each Confidence Level (Ver: %s, n = %s)',version, num2str(analysed_subjects));
        
        title(temp)
        
        print(gcf, '-djpeg',[figure_path date_string '_RSVP_ConfidAcc'])
        
        hold off
        
        close(mAcc_plot);
        
        %% SUBPLOTS OF MEAN ACCURACIES FOR EACH CONFIDENCE LEVEL/LAG
        
        % Assign lag accuracies to 'y' for ease of reading
        y = MeanAccuracies.mAcc_lag;
        
        % Open figure
        mAccLag_plot = figure;
        
        % Bar graph subplot of -7 lag
        subplot(2,2,1)
        bar(y(1,:))
        set(gca,'Xtick',1:8,'XTickLabel',confid_strings)
        h = findobj(gca,'Type','patch');
        set(h,'FaceColor','r')
        ylim([0 1])
        xlabel('Confidence Level')
        title('Lag -7')
        
        % Bar graph subplot of -5 lag
        subplot(2,2,3)
        bar(y(2,:))
        set(gca,'Xtick',1:8,'XTickLabel',confid_strings)
        h = findobj(gca,'Type','patch');
        set(h,'FaceColor','g')
        ylim([0 1])
        xlabel('Confidence Level')
        title('Lag -5')
        
        % Bar graph subplot of -3 lag
        subplot(2,2,2)
        bar(y(3,:))
        set(gca,'Xtick',1:8,'XTickLabel',confid_strings)
        h = findobj(gca,'Type','patch');
        set(h,'FaceColor','y')
        ylim([0 1])
        xlabel('Confidence Level')
        title('Lag -3')
        
        % Bar graph subplot of -1 lag
        subplot(2,2,4)
        bar(y(4,:))
        set(gca,'Xtick',1:8,'XTickLabel',confid_strings)
        h = findobj(gca,'Type','patch');
        set(h,'FaceColor','b')
        ylim([0 1])
        xlabel('Confidence Level')
        title('Lag -1')
        
        % Top Title
        suptitle('Mean Probe Accuracy at each Confidence/Lag level')
        
        print(gcf, '-djpeg',[figure_path date_string '_RSVP_ConfidAccLag'])
        
        hold off
        
        close(mAccLag_plot);
        
    end
    
end

if abs_confid == 1
    
    % Determine number and value of unique (absolute) confidence levels
    abs_confid_levels = unique(abs(data(:,2)))';
    abs_confid_conditions = length(abs_confid_levels);
    
    for abs_confid = 1:abs_confid_conditions
        abs_confid_strings{abs_confid} = num2str(abs_confid_levels(abs_confid));
    end
    
    if plots == 1
        %% BAR GRAPH OF MEAN ACCURACIES FOR EACH (ABSOLUTE) CONFIDENCE LEVEL
        % Assign lag accuracies to 'y' for ease of reading
        y = MeanAccuracies.mAcc_abs;
        
        % Open figure
        mAccAbs_plot = figure;
        hold on
        
        bar(y)
        set(gca, 'XTick', 1:numel(y), 'XTickLabel', abs_confid_strings)
        
        ylim([0 1])
        xlabel('Confidence Level (1:4)')
        ylabel('p(Correct)')
        
        temp = sprintf('Mean Probe Accuracy at each Confidence Level (Ver: %s, n = %s)',version, num2str(analysed_subjects));
        
        title(temp)
        
        print(gcf, '-djpeg',[figure_path date_string '_RSVP_ConfidAccAbs'])
        
        hold off
        
        close(mAccAbs_plot);
        
        %% SUBPLOTS OF MEAN ACCURACIES FOR EACH (ABS) CONFIDENCE LEVEL/LAG
        
        % Assign lag accuracies to 'y' for ease of reading
        y = MeanAccuracies.mAcc_abs_lag;
        
        % Open figure
        mAccLagAbs_plot = figure;
        
        colors = hsv(numel(y(1,:)));
        
        for confid = 1:abs_confid_conditions
            
            plot(y(confid,:),'^-', 'Color',colors(confid,:))
            hold on
            
        end
        
        set(gca,'Xtick',1:numel(y(1,:)),'XTickLabel',abs_confid_strings)
        
        % Assign strings for legend
        legend(MeanAccuracies.Lag_Conditions, 'Location', 'SouthEast')
        ylim([0 1])
        xlabel('Confidence Level (1:4)')
        ylabel('p(Correct)')
        
        % save
        temp = sprintf('Mean Probe Accuracy at each Confid/Lag level (Ver: %s, n = %s)',version, num2str(analysed_subjects));
        
        title(temp)
        
        print(gcf, '-djpeg',[figure_path date_string '_RSVP_ConfidAccLagAbs'])
        
        hold off
        
        close(mAccLagAbs_plot);
        
    end
    
end

%% PLOTS and TABLES

if plots == 1
    
    % Assign lag accuracies to 'y' for ease of reading
    y = RSVP.Subj_Accuracy_Mean;
    
    % Open figure
    Accu_plot = figure;
    aHand = axes('parent', Accu_plot);
    hold(aHand, 'on')
    
    % Create 'colors' matrix with a colour for each lag position
    colors = hsv(numel(y));
    for i = 1:numel(y)
        bar(i, y(i), 'parent', aHand, 'facecolor', colors(i,:));
    end
    
    for i = 1:numel(y)
        errorbar(i, y(i), RSVP.Subj_Accuracy_SEM(i), 'k');
    end
    set(gca, 'XTick', 1:numel(y), 'XTickLabel', RSVP.Lag_Conditions)
    
    % ylim([0.5 0.8])
    ylim([0 1])
    xlabel('Lag Position')
    ylabel('p(Correct)')
    
    temp = sprintf('Mean Probe Accuracy at each Lag Position (Ver: %s, n = %s)',version, num2str(analysed_subjects));
    
    title(temp)
    
    print(gcf, '-djpeg',[figure_path date_string '_RSVP_Accuracies'])
    
    hold off
    
    close(Accu_plot);
    
    %% MEAN CONFIDENCE PLOT
    % Assign lag confidences to 'y' for ease of reading
    y = RSVP.Subj_Confidence_Mean;
    
    % Open figure
    Confid_plot = figure;
    aHand = axes('parent', Confid_plot);
    hold(aHand, 'on')
    
    % Create 'colors' matrix with a colour for each lag position
    colors = hsv(numel(y));
    for i = 1:numel(y)
        bar(i, y(i), 'parent', aHand, 'facecolor', colors(i,:));
    end
    
    for i = 1:numel(y)
        errorbar(i, y(i), RSVP.Subj_Confidence_SEM(i), 'k');
    end
    
    set(gca, 'XTick', 1:numel(y), 'XTickLabel', RSVP.Lag_Conditions)
    
    ylim([1 4])
    xlabel('Lag Position')
    ylabel('Confidence Level (1:4)')
    
    temp = sprintf('Mean Confidence at each Lag Position (Ver: %s, n = %s)',version, num2str(analysed_subjects));
    
    title(temp)
    
    print(gcf, '-djpeg',[figure_path date_string '_RSVP_Confidence'])
    
    hold off
    
    close(Confid_plot);
    
    %% MEAN TYPE-2 AUC PLOT
    % Assign lag Type2-AUCs to 'y' for ease of reading
    y = RSVP.Subj_AUC_Mean;
    
    yPos = 0.5;
    
    % Open figure
    Typ1AUC_plot = figure;
    aHand = axes('parent', Typ1AUC_plot);
    hold(aHand, 'on')
    
    % Create 'colors' matrix with a colour for each lag position
    colors = hsv(numel(y));
    for i = 1:numel(y)
        bar(i, y(i), 'parent', aHand, 'facecolor', colors(i,:));
    end
    
    for i = 1:numel(y)
        errorbar(i, y(i), RSVP.Subj_AUC_SEM(i), 'k');
    end
    
    set(gca, 'XTick', 1:numel(y), 'XTickLabel', RSVP.Lag_Conditions)
    
    ylim([0.4 1])
    
    plot(get(gca,'xlim'), [yPos yPos], '--k'); % Adapts to x limits of current axes
    
    xlabel('Lag Position')
    ylabel('Area Under Curve (Type-1)')
    
    temp = sprintf('Mean Type1-AUCs at each Lag Position (Ver: %s, n = %s)',version, num2str(analysed_subjects));
    
    title(temp)
    
    print(gcf, '-djpeg',[figure_path date_string '_RSVP_Mean_AUCs'])
    
    hold off
    
    close(Typ1AUC_plot);
    
    %% MEAN TYPE-2 AUC PLOT
    % Assign lag Type2-AUCs to 'y' for ease of reading
    y = RSVP.Subj_Type2_AUC_Mean;
    
    yPos = 0.5;
    
    % Open figure
    Typ2AUC_plot = figure;
    aHand = axes('parent', Typ2AUC_plot);
    hold(aHand, 'on')
    
    % Create 'colors' matrix with a colour for each lag position
    colors = hsv(numel(y));
    for i = 1:numel(y)
        bar(i, y(i), 'parent', aHand, 'facecolor', colors(i,:));
    end
    
    for i = 1:numel(y)
        errorbar(i, y(i), RSVP.Subj_Type2_AUC_SEM(i), 'k');
    end
    
    set(gca, 'XTick', 1:numel(y), 'XTickLabel', RSVP.Lag_Conditions)
    
    ylim([0.4 1])
    
    plot(get(gca,'xlim'), [yPos yPos], '--k'); % Adapts to x limits of current axes
    
    xlabel('Lag Position')
    ylabel('Area Under Curve (Type-2)')
    
    temp = sprintf('Mean Type2-AUCs at each Lag Position (Ver: %s, n = %s)',version, num2str(analysed_subjects));
    
    title(temp)
    
    print(gcf, '-djpeg',[figure_path date_string '_RSVP_Mean_Metacognition'])
    
    hold off
    
    close(Typ2AUC_plot);
    
    %% TYPE-1 AUC PLOT
    
    AUC_plot = figure;
    
    % Redefine colour palette
    colors = hsv(4);
    
    % Plot remaining lags
    for lag = 1:lag_conditions
        
        plot([0,RSVP.Cum_Frq{lag}(2,:),1],...
            [0,RSVP.Cum_Frq{lag}(1,:),1],'o-', 'Color',colors(lag,:))
        hold on
        
    end
    
    % Assign strings for legend
    legend(AUC_Str{1:lag_conditions}, 'Location', 'SouthEast')
    xlabel('False Positive Rate')
    ylabel('True Positive Rate')
    
    ylim([0 1])
    xlim([0 1])
    % save
    title('ROC Curve at each Lag Position')
    print(gcf, '-djpeg',[figure_path date_string '_RSVP_ROCs'])
    
    hold off
    
    close(AUC_plot);
    
    %% TYPE-2 AUC PLOT
    
    Typ2_AUC_plot = figure;
    
    % Plot remaining lags
    for lag = 1:lag_conditions
        
        plot([0,RSVP.Cum_Frq2{lag}(2,:),1],...
            [0,RSVP.Cum_Frq2{lag}(1,:),1],'o-', 'Color',colors(lag,:))
        hold on
        
    end
    
    % Assign strings for legend
    legend(Typ2_AUC_Str{1:lag_conditions}, 'Location', 'SouthEast')
    xlabel('False Positive Rate')
    ylabel('True Positive Rate')
    
    ylim([0 1])
    xlim([0 1])
    
    % save
    title('Type2 ROC Curve at each Lag Position')
    print(gcf, '-djpeg',[figure_path date_string '_RSVP_Typ2_ROCs'])
    
    hold off
    
    close(Typ2_AUC_plot);
    
end

%% RT to detect target


end