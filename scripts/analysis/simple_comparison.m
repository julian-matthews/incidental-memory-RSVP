%% 2017-01-25 LOW LEVEL COMPARISON
% Examines the low level features of the probe and distractor and puts the
% resulting similarity alongside the decision (2AFC+confidence) and whether
% it's correct
% Also the low level similarity between probe+target and distractor+target

function [ qck_dat ] = simple_comparison( files , folder )

dbstop if error

original_dir = pwd;

addpath(original_dir);

% Set current folder to 'raw' Data folder of Google Drive
cd('../../Data/raw');

processed_path = ['./' folder '/'];

count = 0;

for subj = 1:length(files);
    
    for session = 1:2
        for run = 1:4
            
            if exist([processed_path files{subj} '/' files{subj}(1:5) '_' num2str(session) ...
                    '_' num2str(run) '.mat'], 'file');
                
                % Load data for this participant
                load([processed_path files{subj} '/' files{subj}(1:5) '_' num2str(session) ...
                    '_' num2str(run) '.mat'], 'TR');
            else
                continue
            end
            
            for trial = 1:length(TR)
                if ~isempty(TR(trial).response)
                    count = count+1;                                      
                                        
                    the_data(count).subj = subj;
                    the_data(count).subj = files{subj}(1:5);
                    the_data(count).sesh = session;
                    the_data(count).run = run;
                    
                    qck_dat(count,1) = subj;
                    qck_dat(count,2) = session;
                    qck_dat(count,3) = run;
                    qck_dat(count,4) = TR(trial).response;
                    qck_dat(count,5) = TR(trial).confidence;
                    
                    qck_dat(count,6) = TR(trial).probe_lag;
                    qck_dat(count,7) = TR(trial).target_lag;
                    
                    if isempty(strfind(folder,'No-Target'))
                        qck_dat(count,8) = TR(trial).detectTargetSecs;
                    else
                        qck_dat(count,8) = nan;
                    end
                    
                    qck_dat(count,9) = TR(trial).response_side;
                    qck_dat(count,10) = TR(trial).keyid;
                    
                else
                    continue;
                end
                
            end
        end
    end
end

cd(original_dir);

end