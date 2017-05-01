%% 2015-12-10 RSVP_target
% Skeleton script for basic, across-subject data analysis for RSVP. Will
% likely break this down into smaller scripts but check inside for details.

% 14/01/2016: Made changes to include RandFace_Inverted

function RSVP_target(plots, type, group)

% Trim RandFace data, mark as missed any trial > 0.610 targ response
Trim = 1;

% Create number string from the date (convertible with 'datestr' function)
date_string = mat2str(datenum(date));

figure_path = '../../figures/combined/';

for iteration = 1:length(group)
    
    % Specify version for this iteration & subject numbers
    ver_string = type{iteration};
    SubjNos = length(group{iteration});
    
    % Select appropriate figure folder
    if strcmp(ver_string,'Inverted-Faces')
        test_type = 'inverted';
    elseif strcmp(ver_string, 'Upright-Faces')
        test_type = 'upright';
    elseif strcmp(ver_string, 'Random-Faces_upr')
        test_type = 'RandFace_upright';
    elseif strcmp(ver_string, 'Random-Faces_inv')
        test_type = 'RandFace_inverted';    
    end
    
    raw_data_path = ['../../data/raw/' test_type '_data/'];
    
    % Save label for this struct
    Version(iteration).Label = ver_string;
    
    % Specify paths
    across_path = ['../../data/across_subjects/' test_type '/'];
    
    % Load across_subject data from today's date
    % This will work in the context of RSVP_analysis or with data concatenated
    % the same day as across_subjects analysis but will need to manually enter
    % a date_string if you want to load older allTrials.mats
    
    load([across_path date_string '_RSVP_allTrials.mat']);
    load([across_path date_string '_RSVP_NoTarget.mat']);
    
    % If trimming RandFace data to just those within 2 faces, do it here
    if Trim == 1 && strcmp(ver_string, 'Random-Faces_upr')
        
        RandFace_upright_saved = data;
        
        for subj = 1:SubjNos
            subset = data(data(:,1) == subj,:);
            more_misses = size(subset(subset(:,8) > 0.605,:),1);
            excluded(subj,3) = excluded(subj,3) + more_misses;
        end
        
        data = data(data(:,8) < 0.605,:);
        
    end
    
    if Trim == 1 && strcmp(ver_string, 'Random-Faces_inv')
        
        RandFace_inverted_saved = data;
        
        for subj = 1:SubjNos
            subset = data(data(:,1) == subj,:);
            more_misses = size(subset(subset(:,8) > 0.605,:),1);
            excluded(subj,3) = excluded(subj,3) + more_misses;
        end
        
        data = data(data(:,8) < 0.605,:);
        
    end
    
    % Determine mean RT for each participant
    % Calculate overall mean RT + SEM
    for subj = 1:SubjNos
        
        % Just this participant's data
        subset = data(data(:,1) == subj,:);
        
        % How many runs did they complete
        Version(iteration).sub_runs(subj) = length(unique(subset(:,9)));
        
        % How many trials is this
        sub_trials = Version(iteration).sub_runs(subj) * 40;
        
        % Determine mean target performance (subset / sub_trials)
        Version(iteration).Hit(subj) = size(subset,1) / sub_trials;
        
        % Add mean RT to struct
        Version(iteration).RT(subj) = mean(subset(:,8));
        
        Version(iteration).FA(subj) = excluded(subj,2) / sub_trials;
        
        Version(iteration).Miss(subj) = excluded(subj,3) / sub_trials;
        
    end
    
    % Means + SEMS for Target Performance
    Version(iteration).MEAN_Hit = mean(Version(iteration).Hit);
    Version(iteration).SEM_Hit = std(Version(iteration).Hit)/sqrt(SubjNos);
    
    Version(iteration).MEAN_FA = mean(Version(iteration).FA);
    Version(iteration).SEM_FA = std(Version(iteration).FA)/sqrt(SubjNos);
    
    Version(iteration).MEAN_Miss = mean(Version(iteration).Miss);
    Version(iteration).SEM_Miss = std(Version(iteration).Miss)/sqrt(SubjNos);
    
    % Means + SEMS for RTs
    Version(iteration).MEAN_RT = mean(Version(iteration).RT);
    Version(iteration).SEM_RT = std(Version(iteration).RT)/sqrt(SubjNos);
    % Plot bargraph of mean targ performance + SEM for each version
    
    % Plot bargraph of mean RT + SEM for each version
    
    
    
end

% Switch things around
Save_state = Version;
Version(1) = Save_state(2);
Version(2) = Save_state(1);
Version(3) = Save_state(3);
Version(4) = Save_state(4);

save_type = type;
type = {'Upright-Faces' 'Inverted-Faces' 'Random-Faces_Upr' 'Random-Faces_Inv'};

%% PLOTS and TABLES

if plots == 1
    %% MEAN TARGET PERFORMANCE
    
    Accu_plot = figure;
    aHand = axes('parent', Accu_plot);
    hold(aHand, 'on')
    
    xlim([0.5 4.5])
        
    bits = [Version(:).MEAN_Hit ; Version(:).MEAN_FA ; Version(:).MEAN_Miss]';
    errors = [Version(:).SEM_Hit ; Version(:).SEM_FA ; Version(:).SEM_Miss]';
    barwitherr(errors,bits), colormap(cool);
    
    set(gca, 'Xtick', 1:4, 'XTickLabel', {Version(:).Label})
    legend('Target Hit','False Alarm','Miss'); legend boxoff;
    
    ylim([0 1])
    xlabel('Task Condition')
    ylabel('Target Detection (%)')
    
    temp = sprintf('Mean Target Performance');
    
    title(temp)
    
    saveas(gcf,[figure_path date_string '_Target_Performance'],'fig');
    print(gcf, '-dtiff',[figure_path date_string '_Target_Performance'])
    
    hold off
    
    close(Accu_plot);
    
    %% MEAN REACTION TIMES
    
    RT_plot = figure;
    aHand = axes('parent', RT_plot);
    hold(aHand, 'on')
    
    
    xlim([0.5 4.5])
    
    bits = [Version(:).MEAN_RT];
    errors = [Version(:).SEM_RT];
    
    barwitherr(errors,bits), colormap(cool);
    
    set(gca, 'XTick', 1:4, 'XTickLabel', {Version(:).Label})
    
    ylim([0.35 0.6])
    xlabel('Task Condition')
    ylabel('Time(ms)')
    
    temp = sprintf('Mean Reaction Time');
    
    title(temp)
    
    saveas(gcf,[figure_path date_string '_Target_RT'],'fig');
    print(gcf, '-dtiff',[figure_path date_string '_Target_RT'])
    
    hold off
    
    close(RT_plot);
    
end


end