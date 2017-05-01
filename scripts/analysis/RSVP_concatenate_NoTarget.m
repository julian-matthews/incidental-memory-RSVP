%% 2015-09-02 - RSVP data concatenation
% Collects data across subjects and concatenates into a central 'data'
% matrix with values appropriate for further analysis.
% Data columns are outlined within the script, read for further details.

%% 2016-01-14 - NO TARGET VERSION:

function RSVP_concatenate_NoTarget(files, save_path)

% DATA COLUMNS:
% 1- subject number
% 2- response (-4:4 - left to right)
% 3- accuracy (1: correct, 0: incorrect)
% 4- stream length (12:19)
% 5- target lag (8:15)
% 6- probe lag (relative to target: -1, -3, -5, -7
% 7- probe position (-1 or 1 = probe left or right)
% 8- target detect time (seconds) - Replaced for NaN in NoTarget version
% 9- run (1:8)
% 10- session num

% Create number string from the date (convertible with 'datestr' function)
date_string = mat2str(datenum(date));
filename = [date_string '_RSVP_allTrials.mat'];

% Specify paths
processed_path = '../../data/preprocessed_data/';

% Set starting points for building data matrix
trial = 1;

for subj = 1:length(files);
    
    for session = 1:2
        for run = 1:4
            
            if exist([processed_path files{subj} num2str(session) ...
                    '_' num2str(run) '_preprocessed.mat'], 'file');
                
                % Load data for this participant
                load([processed_path files{subj} num2str(session) ...
                    '_' num2str(run) '_preprocessed.mat'], 'Data');
            end
            
            for tr = 1:length(Data.TR);
                %% COLUMN 1
                % Save subject number from preprocessed
                
                data(trial, 1) = Data.Subject_Number;
                
                %% COLUMN 2
                % Convert response & confidence data into combined measure
                % Allows retention of left/right bias (if it exists)
                % Left response will be -ve, right response will be +ve
                
                data(trial, 2) = Data.TR(tr).confidence * Data.TR(tr).keyid;
                
                %% COLUMN 3
                % Save accuracy from preprocessed data
                
                data(trial, 3) = Data.TR(tr).response;
                
                %% COLUMN 4
                % Stream length, read from TR data
                
                data(trial, 4) = length(Data.TR(tr).trial_vector);
                
                %% COLUMN 5
                % Target lag, read directly from TR data
                
                data(trial, 5) = Data.TR(tr).target_lag;
                
                %% COLUMN 6
                % Probe lag relative to target, also direct from TR data
                
                data(trial, 6) = Data.TR(tr).probe_lag;
                
                %% COLUMN 7
                % Probe position, can be inferred from col 2/3 but meh
                % As usual, left is -ve and right +ve
                
                data(trial, 7) = Data.TR(tr).response_side;
                
                %% COLUMN 8
                % TargetDetection time not collected in NoTarget version
                % Replaced for NaN
                
                data(trial,8) = NaN;
                
                %% COLUMN 9
                % Run, from 1 to 8
                
                if session == 1
                    data(trial,9) = run;
                elseif session == 2
                    data(trial,9) = run + 4;
                end
                
                %% COLUMN 10
                % Session number
                
                data(trial,10) = session;
                
                % Move to next line of main data matrix
                trial = trial + 1;
                
            end
            
        end
    end
end

%% SAVE THE DATA

save([save_path filename], 'data')

end