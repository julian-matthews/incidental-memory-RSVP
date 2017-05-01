function Target_Calcs(files, save_path, test_type)

% Concatenates data for missed trials (proportion misses & false alarms)

processed_path = ['../../data/preprocessed_data/' test_type '/'];

date_string = mat2str(datenum(date));
filename = [date_string '_RSVP_NoTarget.mat'];

%% LOADS DATA

% Set starting points for building data matrix
trial = 1;

for subj = 1:length(files);
    
    Total_False = 0;
    Total_Miss = 0;
    
    for session = 1:2
        for run = 1:4
            
            
            if exist([processed_path files{subj} num2str(session) ...
                    '_' num2str(run) '_preprocessed.mat'], 'file');
                
                % Load data for this participant
                load([processed_path files{subj} num2str(session) ...
                    '_' num2str(run) '_preprocessed.mat'], 'Data');
            else
                continue
            end
            
            
            Total_False = Total_False + Data.False_Alarms;
            Total_Miss = Total_Miss + Data.Misses;
            
        end
    end
    
    excluded(trial,1) = Data.Subject_Number;
    excluded(trial,2) = Total_False;
    excluded(trial,3) = Total_Miss;
    
    trial = trial + 1;
    
end

%% SAVES TO SAVE_PATH

save([save_path filename], 'excluded')



