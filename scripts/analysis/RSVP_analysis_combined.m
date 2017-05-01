% 2015-09-01 - Julian
% Central analysis script for RSVP replication task.
% Major Functions arranged in order and explained in full.

function RSVP_analysis_combined

% INVERTED FILES
type{1} = 'Inverted-Faces';
group{1} = {'01_SC/01_SC_' '02_VR/02_VR_' '03_AR/03_AR_' '04_TC/04_TC_' '05_JF/05_JF_' '06_MU/06_MU_' '07_SI/07_SI_'};

% UPRIGHT FILES
type{2} = 'Upright-Faces';
group{2} = {'01_AR/01_AR_' '02_JH/02_JH_' '03_EW/03_EW_' '04_ML/04_ML_' '05_JH/05_JH_' '06_HM/06_HM_'};

% RANDFACE upright FILES
type{3} = 'Random-Faces_upr';
group{3} = {'01_AA/01_AA_' '02_NS/02_NS_' '03_KF/03_KF_' '04_TH/04_TH_' '05_TM/05_TM_'};

% RANDFACE inverted FILES
type{4} = 'Random-Faces_inv';
group{4} = {'01_OW/01_OW_' '02_GP/02_GP_' '03_MY/03_MY_' '04_AL/04_AL_' '05_JM/05_JM_'};


%% SPECIFY:

plots = 0; % (1) Yes
threshold = 0; % If (1), only runs with target performance >= limit
limit = .7; % If threshold set, target performance is >= limit (70% standard)

%% CALCULATE:

for run = 1:length(group)
    
    files = group{run};
    version = type{run};
    
    SubjNos = length(files);
    
    if strcmp(version,'Inverted-Faces')
        test_type = 'inverted';
    elseif strcmp(version, 'Upright-Faces')
        test_type = 'upright';
    elseif strcmp(version, 'Random-Faces_upr')
        test_type = 'RandFace_upright';
    elseif strcmp(version, 'Random-Faces_inv')
        test_type = 'RandFace_inverted';
    end
    
    raw_data_path = ['../../data/raw/' test_type '_data/'];
    save_path = ['../../data/across_subjects/' test_type '/'];
    
    %% RSVP_preprocessing
    % The standard version but this will give totals of misses & false
    % alarms now
    RSVP_preprocessing(files, raw_data_path, test_type);
    
    Target_Calcs(files, save_path, test_type);
    
    %% RSVP_concatenate
    % Concatenates preprocessed data from the above into a single,
    % across-subjects matrix w/ values appropriate for further analysis
    
    RSVP_concatenate(files, threshold, limit, save_path, test_type);
    
end

%% RSVP_target
% Light analysis of target performance and RTs

RSVP_target(plots, type, group);

%% RSVP_scatter_combined
% Creates scatter plots for each task manipulation to better compare
% between tasks.

RSVP_scatter_combined(plots, type, group);