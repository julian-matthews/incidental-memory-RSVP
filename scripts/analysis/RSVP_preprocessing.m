% 2015-08-21 - RSVP data preprocessing
% Run this one first: collects data for each participant, performs some
% rudimentary analysis and saves into a preprocessed file

% 14/01/2016 - Made changes to include RandFace_inverted support

function RSVP_preprocessing(files, raw_data_path, test_type)

% Specify raw_data path, this is done in RSVP_analysis otherwise
% raw_data_path = '../../data/raw/';

processed_path = ['../../data/preprocessed_data/' test_type '/'];

% Specify participants, this is done in RSVP_analysis otherwise
% files = {'98_JM/98_JM_'};

for subj = 1:length(files);
           
    for session = 1:2
        for run = 1:4
            
            if exist([raw_data_path files{subj} num2str(session) '_' num2str(run) '.mat'], 'file');
                
                % Load data for this participant
                load([raw_data_path files{subj} num2str(session) '_' num2str(run)], 'TR');
                load([raw_data_path files{subj} num2str(session) '_' num2str(run) '_Settings'], 'Gral');
                
                % Save subject number from settings.mat
                Data.Subject_Number = str2double(Gral.subjNo);
                
                %% SEPARATE MISSED/FALSE ALARM TRIALS
                % Trials where TR.lag_flag = 1, 2, 3, or 4
                % 0 == Target Detected! Response screen presented
                % 1 == False Alarm! Clicked too early
                % 2 == False Alarm! Target detection <100ms (shorter than motor response)
                % 3 == Target Missed! Clicked too late
                % 4 == Target Missed! Didn't click at all
                
                keep = 1;
                remove = 1;
                false = 0;
                miss = 0;
                                                
                for trial = 1:length(TR)
                    if TR(trial).lag_flag == 1 || TR(trial).lag_flag == 2
                        % False alarm trial
                        Data.Exclude(remove) = TR(trial);
                        remove = remove + 1;
                        false = false + 1;
                    elseif TR(trial).lag_flag == 3 || TR(trial).lag_flag == 4
                        % Miss trial
                        Data.Exclude(remove) = TR(trial);
                        remove = remove + 1;
                        miss = miss + 1;
                    elseif isempty(TR(trial).lag_flag)
                        % No response for whatever reason
                        Data.Exclude(remove) = TR(trial);
                        remove = remove + 1;
                    else
                        % Target detected
                        Data.TR(keep) = TR(trial);
                        keep = keep + 1;
                    end
                end
                
                Data.False_Alarms = false;
                Data.Misses = miss;
                
                % Target performance
                Data.Target_Performance = length(Data.TR)/40;
                
                % Mean target detection time (from moment target presented)
                time_mat = [Data.TR(:).detectTargetSecs];
                Data.Target_Time = mean(time_mat);
                
                % Mean performance
                response_mat = [Data.TR(:).response];
                Data.Probe_Performance = mean(response_mat);
                
                % Mean confidence
                confid_mat = [Data.TR(:).confidence];
                Data.Mean_Confidence = mean(confid_mat);
                
                % AUC
                frequencies = zeros(2,4);
                
                for row = 1:2
                    for column = 1:4
                        frequencies(row,column) = ...
                            sum([Data.TR(:).confidence] == column ...
                            & [Data.TR(:).response] ~= row-1);
                    end
                end
                
                Data.Frequencies = frequencies;
                
                [~, Data.AUC] = calculate_AUC(frequencies);               
                
                %% SAVE
                if ~exist([processed_path files{subj}(1:5)],'dir')
                    mkdir(processed_path, files{subj}(1:5));
                end
                
                fileName = [processed_path files{subj} num2str(session) '_' num2str(run) '_preprocessed.mat'];
                save(fileName, 'Data')
                
                %% Save txt form of mean, by-run results 
                
                dataName = [processed_path files{subj} num2str(session) '_' num2str(run)];
                
                % Some basic ID info for saving
                person = files{subj}(1:5);
                if session == 1
                    tmp_run = run;
                elseif session == 2
                    tmp_run = run + 4;
                end
                
                fid = fopen([dataName '_basic_results.txt'],'w');
                
                fprintf(fid,'Subject: \t\t%s\n',person);
                fprintf(fid,'Run: \t\t\t%1.0f\n',tmp_run);
                fprintf(fid,'(T) Accuracy: \t\t%.0f%%\n',Data.Target_Performance*100);
                fprintf(fid,'(T) Time: \t\t%.2f seconds\n',Data.Target_Time);
                fprintf(fid,'(P) Accuracy: \t\t%.0f%%\n',Data.Probe_Performance*100);
                fprintf(fid,'(P) Confidence: \t%1.1f\n',Data.Mean_Confidence);
                fprintf(fid,'(P) Metacognition: \t%.2f\n',Data.AUC);
                fprintf(fid,'False Alarms: \t\t%.0f\n',false);
                fprintf(fid,'Misses: \t\t%.0f\n',miss);
                                
                fclose(fid);
                
                % Reset Data struct for each subject
                clear Data;
                
            end
        end
    end
end

end