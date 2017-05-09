%% 2017-01-25 LOW LEVEL COMPARISON
% Examines the low level features of the probe and distractor and puts the
% resulting similarity alongside the decision (2AFC+confidence) and whether
% it's correct
% Also the low level similarity between probe+target and distractor+target

function [ qck_dat , the_data] = low_level_comparison( files , folder, scaling )

dbstop if error

if nargin == 2
    % Default scale to 32x32
    scaling = 32;
end

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
                    
                    the_data(count).probe = TR(trial).imgDat_probe;
                    the_data(count).targ = TR(trial).imgDat_target;
                    the_data(count).dist = TR(trial).imgDat_distractor;
                    
                    % Create vector of faces that weren't target or probe
                    before_probe = TR(trial).trial_vector(1:(TR(trial).target_lag + TR(trial).probe_lag - 1));
                    
                    if TR(trial).probe_lag < -1
                        before_target = TR(trial).trial_vector((TR(trial).target_lag + TR(trial).probe_lag + 1):(TR(trial).target_lag-1));
                    end
                    
                    after_target = TR(trial).trial_vector((TR(trial).target_lag + 1):(TR(trial).target_lag + 2));
                    
                    if TR(trial).probe_lag < -1
                        ballast_faces = horzcat(before_probe,before_target,after_target);
                    else
                        ballast_faces = horzcat(before_probe,after_target);
                    end
                    
                    % Input these faces into the stream variable
                    the_data(count).stream = ballast_faces;
                    
                    % Comparison
                    imgP = nan(scaling,scaling);
                    imgT = nan(scaling,scaling);
                    imgD = nan(scaling,scaling);
                    
                    imgP = imresize(TR(trial).imgDat_probe,[scaling scaling]);
                    imgT = imresize(TR(trial).imgDat_target,[scaling scaling]);
                    imgD = imresize(TR(trial).imgDat_distractor,[scaling scaling]);
                    
                    imgP = norm_imgs(imgP);
                    imgT = norm_imgs(imgT);
                    imgD = norm_imgs(imgD);
                    
                    TP_diff = mean(abs(double(imgT(:))-double(imgP(:))));
                    TD_diff = mean(abs(double(imgT(:))-double(imgD(:))));
                    PD_diff = mean(abs(double(imgP(:))-double(imgD(:))));
                    
                    the_data(count).TP = TP_diff/255;
                    the_data(count).TD = TD_diff/255;
                    the_data(count).PD = PD_diff/255;
                    
                    % Comparison with trial vector
                    % trial_imgs = TR(trial).trial_vector{1:(TR(trial).target_lag+TR(trial).probe_lag-1)}
                    
                    % Collect faces excluding target, probe, and final (always unseen) face
                    %                     firsts = TR(trial).trial_vector(1:(TR(trial).target_lag+TR(trial).probe_lag-1));
                    %                     mids = TR(trial).trial_vector((TR(trial).target_lag+TR(trial).probe_lag+1):(TR(trial).target_lag-1));
                    %                     ends = TR(trial).trial_vector((TR(trial).target_lag+1):end-1);
                    %
                    ballast = ballast_faces;
                    
                    sumface = zeros(scaling,scaling);
                    for face = 1:length(ballast)
                        temp = imresize(ballast{face},[scaling scaling]);
                        sumface = sumface + double(temp);
                    end
                    
                    meanface = sumface/length(ballast);
                    
                    imgM = norm_imgs(uint8(meanface));
                    
                    MT_diff = mean(abs(double(imgM(:))-double(imgT(:))));
                    MP_diff = mean(abs(double(imgM(:))-double(imgP(:))));
                    MD_diff = mean(abs(double(imgM(:))-double(imgD(:))));
                    
                    the_data(count).MT = MT_diff/255;
                    the_data(count).MP = MP_diff/255;
                    the_data(count).MD = MD_diff/255;
                    
                    % The rest
                    
                    the_data(count).correct = TR(trial).response;
                    the_data(count).choice = TR(trial).keyid * TR(trial).confidence;
                    
                    the_data(count).subj = subj;
                    the_data(count).subj = files{subj}(1:5);
                    the_data(count).sesh = session;
                    the_data(count).run = run;
                    
                    qck_dat(count,1) = subj;
                    qck_dat(count,2) = TR(trial).response;
                    qck_dat(count,3) = TR(trial).confidence;
                    qck_dat(count,4) = TP_diff/255;
                    qck_dat(count,5) = TD_diff/255;
                    qck_dat(count,6) = PD_diff/255;
                    
                    qck_dat(count,7) = TR(trial).probe_lag;
                    qck_dat(count,8) = TR(trial).target_lag;
                    qck_dat(count,9) = TR(trial).detectTargetSecs;
                    
                    qck_dat(count,10) = MT_diff/255;
                    qck_dat(count,11) = MP_diff/255;
                    qck_dat(count,12) = MD_diff/255;
                    
                    qck_dat(count,13) = 999;
                    qck_dat(count,14) = session;
                    qck_dat(count,15) = run;
                else
                    continue;
                end
                
            end
        end
    end
end

cd(original_dir);

end








% DATA COLUMNS:
% 1- subject number
% 2- response (-4:4 - left to right)
% 3- accuracy (1: correct, 0: incorrect)
% 4- stream length (12:19)
% 5- target lag (8:15)
% 6- probe lag (relative to target: -1, -3, -5, -7
% 7- probe position (-1 or 1 = probe left or right)
% 8- target detect time (seconds)
% 9- run (1:8)
% 10- session num

% % Create number string from the date (convertible with 'datestr' function)
% date_string = mat2str(datenum(date));
% filename = [date_string '_RSVP_allTrials.mat'];
%
% % Specify paths
% processed_path = ['../../data/preprocessed_data/' test_type '/'];
% % save_path = '../../data/across_subjects/';
%
% % Specify participants, otherwise this is done in RSVP_analysis
% % files = {'98_JM/98_JM_'};
%
% % Set starting points for building data matrix
% trial = 1;
%
% % Check number of applicable runs in final analysis
% inclusion_count = 0;
% eligible_count = 0;
%
% for subj = 1:length(files);
%
%     for session = 1:2
%         for run = 1:4
%
%             if threshold == 1
%
%                 % Check if target detection above limit (normally 70%)
%                 if exist([processed_path files{subj} num2str(session) ...
%                         '_' num2str(run) '_preprocessed.mat'], 'file');
%
%                     eligible_count = eligible_count + 1;
%
%                     % Load data for this participant
%                     load([processed_path files{subj} num2str(session) ...
%                         '_' num2str(run) '_preprocessed.mat'], 'Data');
%                 end
%
%                 if Data.Target_Performance < limit
%                     continue
%                 end
%
%                 % If performance is eligible, add to included runs
%                 inclusion_count = inclusion_count + 1;
%
%             elseif threshold == 0
%
%                 if exist([processed_path files{subj} num2str(session) ...
%                         '_' num2str(run) '_preprocessed.mat'], 'file');
%
%                     % Load data for this participant
%                     load([processed_path files{subj} num2str(session) ...
%                         '_' num2str(run) '_preprocessed.mat'], 'Data');
%                 else
%                     continue
%                 end
%             end
%
%             for tr = 1:length(Data.TR);
%                 %% COLUMN 1
%                 % Save subject number from preprocessed
%
%                 data(trial, 1) = Data.Subject_Number;
%
%                 %% COLUMN 2
%                 % Convert response & confidence data into combined measure
%                 % Allows retention of left/right bias (if it exists)
%                 % Left response will be -ve, right response will be +ve
%
%                 data(trial, 2) = Data.TR(tr).confidence * Data.TR(tr).keyid;
%
%                 %% COLUMN 3
%                 % Save accuracy from preprocessed data
%
%                 data(trial, 3) = Data.TR(tr).response;
%
%                 %% COLUMN 4
%                 % Stream length, read from TR data
%
%                 data(trial, 4) = length(Data.TR(tr).trial_vector);
%
%                 %% COLUMN 5
%                 % Target lag, read directly from TR data
%
%                 data(trial, 5) = Data.TR(tr).target_lag;
%
%                 %% COLUMN 6
%                 % Probe lag relative to target, also direct from TR data
%
%                 data(trial, 6) = Data.TR(tr).probe_lag;
%
%                 %% COLUMN 7
%                 % Probe position, can be inferred from col 2/3 but meh
%                 % As usual, left is -ve and right +ve
%
%                 data(trial, 7) = Data.TR(tr).response_side;
%
%                 %% COLUMN 8
%                 % Time to detect target, from presentation of target to
%                 % mouse click. Measured in seconds
%
%                 data(trial,8) = Data.TR(tr).detectTargetSecs;
%
%                 %% COLUMN 9
%                 % Run, from 1 to 8
%
%                 if session == 1
%                     data(trial,9) = run;
%                 elseif session == 2
%                     data(trial,9) = run + 4;
%                 end
%
%                 %% COLUMN 10
%                 % Session number
%
%                 data(trial,10) = session;
%
%                 % Move to next line of main data matrix
%                 trial = trial + 1;
%
%             end
%
%         end
%     end
% end
%
% %% SAVE & STATE INCLUDED RUN NUMBER IF THRESHOLDING
%
% if threshold == 1
%
%     loss_dot_jpg = (inclusion_count/eligible_count) * 100;
%
%     attrition = sprintf('%d runs out of %d total included in analysis: %2.0f%%',...
%         inclusion_count, eligible_count, loss_dot_jpg);
%
%     disp(attrition)
%
% end
%
% save([save_path filename], 'data')
%
% end
