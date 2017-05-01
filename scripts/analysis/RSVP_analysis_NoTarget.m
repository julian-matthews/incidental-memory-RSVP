% 2015-09-01 - Julian
% Central analysis script for RSVP replication task.
% Major Functions arranged in order and explained in full.

function RSVP_analysis_NoTarget

% INVERTED FILES
version = 'NoTarget-Upright';
% files = {'99_JM/99_JM_'};
files = {'01_BL/01_BL_' '02_ML/02_ML_' '03_EW/03_EW_' '04_TM/04_TM_' '05_VC/05_VC_'};


%% SPECIFY:

plots = 1; % (1) Yes

%% CALCULATE:

SubjNos = length(files);

if strcmp(version,'NoTarget-Upright')
    test_type = 'NoTarget_upright';
elseif strcmp(version, 'NoTarget-Inverted')
    test_type = 'NoTarget_inverted';
end

raw_data_path = ['../../data/raw/' test_type '_data/'];
save_path = ['../../data/across_subjects/' test_type '/'];


%% RSVP_preprocessing
% Concatenates data for each subject/run into distinct 'Data' structs.
% Each run is lightly preprocessed to specify excluded trials (ie. target
% missed/clicked too early), performance on the target detection task
% (target found trials as a proportion of total), performance on probe
% detection, mean confidence, and AUC

RSVP_preprocessing_NoTarget(files, raw_data_path);

%% RSVP_concatenate
% Concatenates preprocessed data from the above into a single,
% across-subjects matrix w/ values appropriate for further analysis

RSVP_concatenate_NoTarget(files, save_path);

%% RSVP_across_subjects
% Skeleton script for basic, across-subject data analysis for RSVP. 
% Calculates mean accuracies, confidences, and type 1/2 AUCs. Plots all if
% indicated above. 

RSVP_across_subjects(plots, SubjNos, version)

%% RSVP_across_sessions
% Analysis and plots for accuracies, confidence & type 1/2 AUCs between the
% first and second sessions of the RSVP experiment

% RSVP_across_sessions(plots, SubjNos, version);