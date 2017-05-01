% 17/09/2015 - Julian
% Lisandro & Elise crowd-search metacognition replication using RSVP
% Creates target_lag+4 vector of faces with gaussian blur mask

function RSVP_create_trials

% Shuffle RNG off clock, record fresh seed & re-seed RNG from record
rng('shuffle');
Exp.RNG_seed = randi(8145060,1,1); % If you get the same seed twice, buy a lotto ticket
rng(Exp.RNG_seed);

% Test an RNG here:
% rng(2074);

% Define stimuli directories
Exp.scene_dir = '../../stimuli_trimmed/';
Exp.trial_prepro_dir = '../../stimuli_trimmed/preprocessed_trials/';

Exp.Gral.subNum = input('Subject number, 01-99:\n','s'); % '01';

Exp.Setup.sessions = 2;
Exp.Setup.runs = 4;

% Exp.Setup.sessions = input('Number of sessions, one or more:\n');
% Exp.Setup.runs = input('Number of runs, 4 maximum:\n');

% Number of trials
% Divisible by 4 & 8 for even distribution of targ/probe positions
Exp.Trials = 40;

% Define number of crowd images to draw from (fixed to 160 in test_face_num)
image_num = 160;

% Define number of faces presented from these crowd scenes
% Max varies per image but all have at least 17 faces present
% Currently set to image with greatest number of faces (img #155, 50 faces)
% This ensures an even distribution of faces from all parts of the crowd
face_num = 46;

% Specify mask type:
% If mask_type = 1, mask will be white/black (0 || 255)
% If mask_type = 2, mask will range across white/black (0 : 255)
mask_type = 2;

%% MAKE STIMULI

begin = sprintf('\nReticulating splines:');
disp(begin)

% Load struct of trimmed scene data created with test_face_num.mat
load([Exp.scene_dir 'scene_struct.mat'],'scene');


%% PREPARE TRIALS

disp('Splines reticulated, constructing trials:')

sec_check = 0;

% For each scene, select out a second target, 2 probes and 2 distractors
for crowd = 1:length(scene)
    
    % While loop with sec_flag to ensure all targets/probes/distractors are
    % [101x101] in dimension
    sec_flag = 0;
    
    while sec_flag == 0
        
        sec_flag = 1;
        
        % Confirm that the 101x101 size check is working
        sec_check = sec_check + 1;
        
        % Randperm of N_caras
        scene_perm = randperm(scene(crowd).N_caras);
        
        % Select out second target
        scene(crowd).target_one = scene(crowd).caras(scene_perm(1));
        
        if size(scene(crowd).target_one.face_dat,1) ~= 101 || size(scene(crowd).target_one.face_dat,2) ~= 101
            sec_flag = 0;
            continue
        end
        
        %% PROBE & DISTRACTOR ONE
        % Select out first probe (session 1)
        scene(crowd).probe_one = scene(crowd).caras(scene_perm(2));
        probe_one_y_coords = scene(crowd).caras(scene_perm(2)).coords(2);
        
        if size(scene(crowd).probe_one.face_dat,1) ~= 101 || size(scene(crowd).probe_one.face_dat,2) ~= 101
            sec_flag = 0;
            continue
        end
        
        % Update scene_perm to remaining faces and create blank vector for
        % coords
        scene_perm = scene_perm(3:end);
        y_vector = zeros(length(scene_perm),3);
        
        % Find closest face on Y-axis
        for pos = 1:length(scene_perm)
            y_vector(pos,1) = pos;
            y_vector(pos,2) = scene(crowd).caras(scene_perm(pos)).coords(2);
            y_vector(pos,3) = abs(y_vector(pos,2) - probe_one_y_coords);
        end
        
        % Sortrows to find shortest distance from probe & save face number
        y_positions = sortrows(y_vector,-3);
        close_face = y_positions(end,1);
        
        % Select out first distractor
        scene(crowd).distractor_one = scene(crowd).caras(scene_perm(close_face));
        
        if size(scene(crowd).distractor_one.face_dat,1) ~= 101 || size(scene(crowd).distractor_one.face_dat,2) ~= 101 
            sec_flag = 0;
            continue
        end
        
        % Update scene_perm to remove first distractor face
        scene_perm = [scene_perm(1:close_face-1) scene_perm(close_face+1:end)];
        
        %% PROBE & DISTRACTOR TWO
        % Select out second probe (session 2)
        scene(crowd).probe_two = scene(crowd).caras(scene_perm(1));
        probe_two_y_coords = scene(crowd).caras(scene_perm(1)).coords(2);
        
        if size(scene(crowd).probe_two.face_dat,1) ~= 101 || size(scene(crowd).probe_two.face_dat,2) ~= 101
            sec_flag = 0;
            continue
        end
        
        % Update scene_perm to remaining faces and create blank vector for
        % coords relative to second probe
        scene_perm = scene_perm(2:end);
        y_vector = zeros(length(scene_perm),3);
        
        % Find closest face on Y-axis to second probe
        for pos = 1:length(scene_perm)
            y_vector(pos,1) = pos;
            y_vector(pos,2) = scene(crowd).caras(scene_perm(pos)).coords(2);
            y_vector(pos,3) = abs(y_vector(pos,2) - probe_two_y_coords);
        end
        
        % Sortrows to find shortest distance from probe & save face number
        y_positions = sortrows(y_vector,-3);
        close_face = y_positions(end,1);
        
        % Select out second distractor
        scene(crowd).distractor_two = scene(crowd).caras(scene_perm(close_face));
        
        if size(scene(crowd).distractor_two.face_dat,1) ~= 101 || size(scene(crowd).distractor_two.face_dat,2) ~= 101
            sec_flag = 0;
            continue
        end
        
        % Update scene_perm to remove second distractor face
        scene_perm = [scene_perm(1:close_face-1) scene_perm(close_face+1:end)];
        
        % Remaining faces are left as ballast stream
        scene(crowd).ballast_num = length(scene_perm);
        scene(crowd).ballast_index = scene_perm;
        
    end
    
end

reperm_num = 0;

flag = 0;

while flag == 0
    
    flag = 1;
    
    % Out of interest, number of times this cycles to find relevant
    % positions
    reperm_num = reperm_num + 1;
    
    crowd = randperm(image_num);
    
    % Determines whether L&E target is first or second session
    order = randperm(Exp.Setup.sessions);
    
    % Setup counterbalanced target/probe/response conditions
    for sesh_num = 1:Exp.Setup.sessions
        
        the_order = order(sesh_num);
        
        for run_num = 1:Exp.Setup.runs
            
            % Select from probe condition (-1 -3 -5 -7)
            probe_pos = zeros(1,Exp.Trials);
            probe_pos(1:Exp.Trials/4) = -1;
            probe_pos(((Exp.Trials/4)*1+1):(Exp.Trials/4)*2) = -3;
            probe_pos(((Exp.Trials/4)*2+1):(Exp.Trials/4)*3) = -5;
            probe_pos((Exp.Trials/4)*3+1:end) = -7;
            probe_pos = Shuffle(probe_pos);
            
            % Select target condition (face 8-15)
            targ_pos = zeros(1,Exp.Trials);
            targ_pos(1:Exp.Trials/8) = 8;
            targ_pos(((Exp.Trials/8)*1+1):(Exp.Trials/8)*2) = 9;
            targ_pos(((Exp.Trials/8)*2+1):(Exp.Trials/8)*3) = 10;
            targ_pos(((Exp.Trials/8)*3+1):(Exp.Trials/8)*4) = 11;
            targ_pos(((Exp.Trials/8)*4+1):(Exp.Trials/8)*5) = 12;
            targ_pos(((Exp.Trials/8)*5+1):(Exp.Trials/8)*6) = 13;
            targ_pos(((Exp.Trials/8)*6+1):(Exp.Trials/8)*7) = 14;
            targ_pos(((Exp.Trials/8)*7+1):end) = 15;
            targ_pos = Shuffle(targ_pos);
            
            % Select side for distractor vs. probe response (DP vs. PD)
            response_pos = zeros(1,Exp.Trials);
            response_pos(1:Exp.Trials/2) = 1; % Distractor on left, probe right
            response_pos((Exp.Trials/2)+1:end) = -1; % Probe on left, distractor right
            response_pos = Shuffle(response_pos);
            
            for tr = 1:Exp.Trials
                
                % Grab trials from this run
                run_trials = (tr+(Exp.Trials*(run_num-1)));
                
                % Randomised probe lag for this trial (counterbalanced)
                TR(tr).probe_lag = probe_pos(tr);
                
                % Randomised target lag for this trial (counterbalanced)
                TR(tr).target_lag = targ_pos(tr);
                
                % Randomised response screen for this trial (counterbalanced)
                TR(tr).response_side = response_pos(tr);
                
                % Select crowd scene to draw from (1-199)
                TR(tr).crowd_img = crowd(run_trials);
                
                % Check how many faces are in this trial's crowd scene
                TR(tr).crowd_size = scene(TR(tr).crowd_img).ballast_num + 2;
                
                % Save some original values
                TR(tr).original_crowd_num = scene(TR(tr).crowd_img).original_crowd_num;
                TR(tr).total_N_caras = scene(TR(tr).crowd_img).N_caras;
                
                % Restart while loop if this randperm isn't going to work
                if TR(tr).crowd_size < TR(tr).target_lag + 3 || TR(tr).crowd_size > TR(tr).target_lag + 30
                    flag = 0;
                    break
                end
                
                % Create [101x101] gaussian blob as mask (values 0 or 255)
                if mask_type == 1
                    imgDat_mask = randi(2,101,101)-1;
                    imgDat_mask(imgDat_mask == 1) = 255;
                    TR(tr).imgDat_mask = imgDat_mask;
                elseif mask_type == 2
                    imgDat_mask = randi(255,101,101);
                    TR(tr).imgDat_mask = imgDat_mask;
                end
                
                if the_order == 1
                    
                    % Save target image data for L&E target
                    TR(tr).imgDat_target = scene(TR(tr).crowd_img).targ_dat;
                    
                    TR(tr).imgDat_distractor = ...
                        scene(TR(tr).crowd_img).distractor_one.face_dat;
                    
                    TR(tr).imgDat_probe = ...
                        scene(TR(tr).crowd_img).probe_one.face_dat;
                    
                elseif the_order == 2
                    
                    % Save target image data for second set
                    TR(tr).imgDat_target = ...
                        scene(TR(tr).crowd_img).target_one.face_dat;
                    
                    TR(tr).imgDat_distractor = ...
                        scene(TR(tr).crowd_img).distractor_two.face_dat;
                    
                    TR(tr).imgDat_probe = ...
                        scene(TR(tr).crowd_img).probe_two.face_dat;
                    
                end
                
            end
            
            if flag == 0
                break
            end
            
            %% CONTINUE FROM HERE TOMORROW
            
            % Prepare vector of trial images
            for tr = 1:Exp.Trials
                
                TR(tr).trial_vector = cell(1,TR(tr).target_lag + 2);
                
                for lag = 1:TR(tr).target_lag - 1
                    
                    TR(tr).trial_vector{lag} = scene(TR(tr).crowd_img).caras...
                        (scene(TR(tr).crowd_img).ballast_index(lag)).face_dat;
                    
                end
                
                % Insert target
                TR(tr).trial_vector{TR(tr).target_lag} = TR(tr).imgDat_target;
                
                % Copy face to be substituted by probe to target + 1
                TR(tr).trial_vector{TR(tr).target_lag+1} = TR(tr).trial_vector{TR(tr).target_lag + TR(tr).probe_lag};
                
                % Insert 2 more faces at end of stream
                for lag = 1 : 2
                    
                    trial_lag = (TR(tr).target_lag + 1) + lag;
                    ballast_lag = (TR(tr).target_lag - 1) + lag;
                    
                    TR(tr).trial_vector{trial_lag} = ...
                        scene(TR(tr).crowd_img).caras(scene(TR(tr).crowd_img). ...
                        ballast_index(ballast_lag)).face_dat;
                    
                end
                
                % Substitute in probe texture at right location
                TR(tr).trial_vector{TR(tr).target_lag + TR(tr).probe_lag} = TR(tr).imgDat_probe;
                
            end
            
            % Assign all trial data to this run
            Run(run_num).TR = TR;
            
        end
        
        if flag == 0
            break
        end
        
        Session(sesh_num).Run = Run;
        
    end
    
end


%% SAVE TO TRIAL FOLDER

Details.RNG_seed = Exp.RNG_seed;
Details.subNum = Exp.Gral.subNum;
Details.sessions = Exp.Setup.sessions;
Details.runs_per_session = Exp.Setup.runs;
Details.trials_per_run = Exp.Trials;

if ~exist([Exp.trial_prepro_dir Exp.Gral.subNum],'dir');
    mkdir('../../stimuli_trimmed/preprocessed_trials/', Exp.Gral.subNum);
end

disp('*')

for teh_session = 1:Exp.Setup.sessions
    
    sesh_string = mat2str(teh_session);
    
    for teh_run = 1:Exp.Setup.runs
        
        run_string = mat2str(teh_run);
        TR = Session(teh_session).Run(teh_run).TR;
        
        path = [Exp.trial_prepro_dir Exp.Gral.subNum '/' ...
            Exp.Gral.subNum '_s' sesh_string '_r' run_string];
        
        save([path '.mat'], 'Details', 'TR');
        
    end
end

%% PRINT MESSAGE TO INDICATE SAVE

total_trials = Exp.Setup.sessions*Exp.Setup.runs*Exp.Trials;

the_end = sprintf('\nCreated %d sessions of %d runs for subject #%s',...
    Exp.Setup.sessions,Exp.Setup.runs,Exp.Gral.subNum);
the_trials = sprintf('There''s %d trials per run so %d in total',...
    Exp.Trials, total_trials);

disp(the_end)
disp(the_trials)

end
