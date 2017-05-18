%% 2017-04-03 Julian: QUICK ANALYSIS FOR RSVP
% Load smp_data and perform rudimentary analysis (RSVP-all-data.mat)

% Data arranged into TWU,TWI; TAU,TAI; NAU,NAI structs

% Subj#, Sesh, Run, Response, Confid, Probe_Lag, Target_Lag, Time, Truth,
% Keyid

clear COND;

for condition = 1:6
    
    switch condition
        case 1
            this_data = smp_dat.TWU;
        case 2
            this_data = smp_dat.TWI;
        case 3
            this_data = smp_dat.TAU;
        case 4
            this_data = smp_dat.TAI;
        case 5
            this_data = smp_dat.NAU;
        case 6
            this_data = smp_dat.NAI;
    end
    
    for tr = 1:size(this_data,1)
        if this_data(tr,2) == 2 && this_data(tr,3) == 1
            this_data(tr,3) = 5;
        elseif this_data(tr,2) == 2 && this_data(tr,3) == 2
            this_data(tr,3) = 6;
        elseif this_data(tr,2) == 2 && this_data(tr,3) == 3
            this_data(tr,3) = 7;
        elseif this_data(tr,2) == 2 && this_data(tr,3) == 4
            this_data(tr,3) = 8;
        end
    end
    
    for subj = 1:length(unique(this_data(:,1)))
        
        % Separate data by subject
        this_subj = this_data(this_data(:,1)==subj,:);
        
        for runs = 1:length(unique(this_data(:,3)))
            
            this_dat = this_subj(this_subj(:,3)==runs,:);
            
            
            % Calculate type 1 AUC
            [~,~,COND(condition).RUNS.OBJPER(subj,runs)] = ...
                type1auc(this_dat(:,9),(this_dat(:,10).*this_dat(:,5)));
            
            % Calculate type 2 AUC
            COND(condition).RUNS.META(subj,runs) = ...
                type2roc(this_dat(:,4),this_dat(:,5),4);
            
            % Calculate mean (absolute) confidence
            COND(condition).RUNS.CONFID(subj,runs) = ...
                mean(this_dat(:,5));
            
            % Log number of valid trials
            COND(condition).RUNS.NUMS(subj,runs) = ...
                size(this_dat,1);
            
        end
        
        for lags = 1:length(unique(this_data(:,6)))
            
            lag_types = [-1, -3, -5, -7];
            
            this_dat = this_subj(this_subj(:,6)==lag_types(lags),:);
            
            % Calculate type 1 AUC
            [~,~,COND(condition).LAGS.OBJPER(subj,lags)] = ...
                type1auc(this_dat(:,9),(this_dat(:,10).*this_dat(:,5)));
            
            % Calculate type 2 AUC
            COND(condition).LAGS.META(subj,lags) = ...
                type2roc(this_dat(:,4),this_dat(:,5),4);
            
            % Calculate mean (absolute) confidence
            COND(condition).LAGS.CONFID(subj,lags) = ...
                mean(this_dat(:,5));
            
            % Log number of valid trials
            COND(condition).LAGS.NUMS(subj,lags) = ...
                size(this_dat,1);
            
        end
    end
end

for condition = 1:6
    
    for measures = 1:3
        
        switch measures
            case 1
                measure = COND(condition).LAGS.OBJPER;
            case 2
                measure = COND(condition).LAGS.META;
            case 3
                measure = COND(condition).LAGS.CONFID;
        end
        
        % Means and SEMs
        MEANS = mean(measure,1);
        SEMS = within_subject_error(measure); % See github/julian-matthews/stats-tools
        
        if measures == 1
            COND(condition).LAGS.OP_means = MEANS;
            COND(condition).LAGS.OP_SEMs = SEMS;
        elseif measures == 2
            COND(condition).LAGS.Meta_means = MEANS;
            COND(condition).LAGS.Meta_SEMs = SEMS;
        elseif measures == 3
            COND(condition).LAGS.Conf_means = MEANS;
            COND(condition).LAGS.Conf_SEMs = SEMS;
        end
    end
end

