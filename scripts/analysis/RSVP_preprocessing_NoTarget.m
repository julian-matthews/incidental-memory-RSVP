% 2015-08-21 - RSVP data preprocessing
% Run this one first: collects data for each participant, performs some
% rudimentary analysis and saves into a preprocessed file

function RSVP_preprocessing_NoTarget(files, raw_data_path)

% Specify raw_data path, this is done in RSVP_analysis otherwise
% raw_data_path = '../../data/raw/';

processed_path = '../../data/preprocessed_data/';

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
                
                keep = 1;
                                                
                for trial = 1:length(TR)
                        % Target detected
                        Data.TR(keep) = TR(trial);
                        keep = keep + 1;
                end
                
                % Raw detection
                Data.Target_Performance = length(Data.TR)/40;
                
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
                fprintf(fid,'(P) Accuracy: \t\t%.0f%%\n',Data.Probe_Performance*100);
                fprintf(fid,'(P) Confidence: \t%1.1f\n',Data.Mean_Confidence);
                fprintf(fid,'(P) Metacognition: \t%.2f\n',Data.AUC);
                                
                fclose(fid);
                
                % Reset Data struct for each subject
                clear Data;
                
            end
        end
    end
end

end