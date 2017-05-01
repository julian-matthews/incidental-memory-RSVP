% 2015-09-01 - Julian
% Central analysis script for RSVP replication task.
% Major Functions arranged in order and explained in full.

function RSVP_analysis

% INVERTED FILES
% version = 'Inverted-Faces';
% files = {'01_SC/01_SC_' '02_VR/02_VR_' '03_AR/03_AR_' '04_TC/04_TC_' '05_JF/05_JF_' '06_MU/06_MU_' '07_SI/07_SI_'};

% UPRIGHT FILES
% version = 'Upright-Faces';
% files = {'01_AR/01_AR_' '02_JH/02_JH_' '03_EW/03_EW_' '04_ML/04_ML_' '05_JH/05_JH_' '06_HM/06_HM_'};

% RANDFACE FILES
% version = 'Random-Faces_upr';
% files = {'01_AA/01_AA_' '02_NS/02_NS_' '03_KF/03_KF_' '04_TH/04_TH_' '05_TM/05_TM_'};

% RANDFACE INVERTED FILES
version = 'Random-Faces_inv';
files = {'01_OW/01_OW_' '02_GP/02_GP_' '03_MY/03_MY_' '04_AL/04_AL_' '05_JM/05_JM_'};

%% SPECIFY:

plots = 1; % (1) Yes
threshold = 1; % If (1), only runs with target performance >= limit 
limit = .7; % If threshold set, target performance is >= limit (70% standard)

%% CALCULATE:

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
% Concatenates data for each subject/run into distinct 'Data' structs.
% Each run is lightly preprocessed to specify excluded trials (ie. target
% missed/clicked too early), performance on the target detection task
% (target found trials as a proportion of total), performance on probe
% detection, mean confidence, and AUC

RSVP_preprocessing(files, raw_data_path, test_type);

%% RSVP_concatenate
% Concatenates preprocessed data from the above into a single,
% across-subjects matrix w/ values appropriate for further analysis

RSVP_concatenate(files, threshold, limit, save_path, test_type);

%% RSVP_within_subjects
% Basic script for within-subjects analysis for RSVP.
% Plots mean target detection times for each subject

RSVP_within_subjects(plots, version);

%% RSVP_across_subjects
% Skeleton script for basic, across-subject data analysis for RSVP. 
% Calculates mean accuracies, confidences, and type 1/2 AUCs. Plots all if
% indicated above. 

RSVP_across_subjects(plots, SubjNos, version)

%% RSVP_across_sessions
% Analysis and plots for accuracies, confidence & type 1/2 AUCs between the
% first and second sessions of the RSVP experiment

RSVP_across_sessions(plots, SubjNos, version);