% 28/08/2015 - Julian
% Lisandro & Elise crowd-search metacognition replication using RSVP

%% 2015-10-21 - MODIFIED TO ALLOW MORE TIME FOR TARGET DETECTION
% Response now counted if detection happens within target_lag + 2

function RSVP_runExp

% Input subject number, ID, session, and run.
Gral.subjNo = input('Enter subject number, 01-99:\n','s'); % '99'
Gral.subjID = input('Enter subject initials:\n','s'); % 'JM'
Gral.seshID = input('Session number, 1 or 2:\n','s'); % '1'
Gral.runID = input('Run number, 1-4:\n','s'); % '4'

Gral.invert = input('Invert faces, y/n:\n','s'); % Only 'y' or 'Y' will invert

if strcmp(Gral.invert,'y') || strcmp(Gral.invert,'Y')
    invert = 1;
    tex_angle = 180;
else
    invert = 0;
    tex_angle = 0;
end

% Define path to preprocessed trials
Exp.addParams.trial_prepro_dir = '../../stimuli_trimmed/preprocessed_trials/';

% Define path for raw data
Exp.addParams.raw_data = '../../data/raw/';

% Flag for graceful exit if just creating trials
graceful_finish = 0;

% Check if trial setup for this subject/session/run exists & load data
% If not, prompt user and run RSVP_create_trials

if exist([Exp.addParams.trial_prepro_dir Gral.subjNo '/' ...
        Gral.subjNo '_s' Gral.seshID '_r' Gral.runID '.mat'],'file')
    
    load_text = sprintf('Loading trial data for subject #%s\n* Session %s * Run %s *', ...
        Gral.subjNo, Gral.seshID, Gral.runID);
    disp(load_text)
    
    load([Exp.addParams.trial_prepro_dir Gral.subjNo '/' ...
        Gral.subjNo '_s' Gral.seshID '_r' Gral.runID '.mat'], ...
        'Details','TR')
    
else
    
    tried_text = sprintf('\nAttempted to find trials for subject #%s, session %s, run %s but no dice...', ...
        Gral.subjNo, Gral.seshID, Gral.runID);
    disp(tried_text)
    
    create_trials = input('\nDo you want to create trials now? (Y/N)\n','s');
    
    if create_trials == 'y' || create_trials == 'Y'
        leave_text = sprintf('\nPassing control to RSVP_create_trials, retry when complete\n');
        disp(leave_text)
        RSVP_create_trials;
        graceful_finish = 1;
    else
        graceful_finish = 1;
    end
end

if graceful_finish == 0
    
    % Check if folder exists for this participant's data, create if not
    if ~exist([Exp.addParams.raw_data Gral.subjNo '_' Gral.subjID],'dir');
        mkdir('../../data/raw/', [Gral.subjNo '_' Gral.subjID]);
    end
    
    % Define path for saving data
    saving_path = [Exp.addParams.raw_data Gral.subjNo '_' Gral.subjID '/' ...
        Gral.subjNo '_' Gral.subjID '_' Gral.seshID '_' Gral.runID];
    
    % Load randperm seed from loaded block
    rng(Details.RNG_seed);
    
    % Parameter and screen setup
    Exp = RSVP_parameters;
    
    % Number of trials is defined by block data, standard is 40
    Exp.Trials = Details.trials_per_run;
    
    %% PRESENTATION TIME SETTINGS
    
    % If set to 1 the target, flip & blank SOAs will be jittered by 5%
    add_jitter = 0;
    
    % Target presentation time (3 seconds in L&E)
    target_time = 3;
    
    % SOA interval for each image (seconds)
    flip_time = 0.2; %200ms
    
    % SOA interval for blank screen between faces (seconds)
    blank_time = 0.08; %80ms
    
    % Flashing interval for false alarm & target miss screens
    flash_time = 0.08; %80ms red then 80s black
    flash_repeats = 3; % Flashes red/black 5 times
    
    % Display interval for gaussian mask (seconds)
    mask_time = 0.5;
    
    %% FIRST SCREEN
    
    Screen('FillRect', Exp.Cfg.win, Exp.Cfg.Color.black);
    DrawFormattedText(Exp.Cfg.win,Exp.Title,'center','center',Exp.Cfg.Color.white);
    Screen('Flip', Exp.Cfg.win, [], Exp.Cfg.AuxBuffers);
    
    while (1)
        [~,~,buttons] = GetMouse(Exp.Cfg.win);
        if buttons(1) || KbCheck
            break;
        end
    end
    
    % Prepare vector of lags in each trial to store presentation time of stimuli
    for trial = 1:Exp.Trials
        TR(trial).lag_times = nan((length(TR(trial).trial_vector)),1); %#ok<*AGROW>
    end
    
    Screen('FillRect', Exp.Cfg.win, Exp.Cfg.Color.gray);
    Screen('Flip', Exp.Cfg.win, [], Exp.Cfg.AuxBuffers);
    
    WaitSecs(0.25);
    
    %% TARGET IMAGE FOR 3 SECONDS
    
    if add_jitter
        % Save timing defaults for jitter
        default_target_time = target_time;
        default_flip_time = flip_time;
        default_blank_time = blank_time;
    end
    
    for trial = 1:Exp.Trials
        
        HideCursor;
        
        % Clear screen
        Screen('FillRect', Exp.Cfg.win, Exp.Cfg.Color.gray);
        Screen('Flip', Exp.Cfg.win, [], Exp.Cfg.AuxBuffers);
        
        % Create textures for this trial
        Targ_Tex = Screen('MakeTexture',Exp.Cfg.win, TR(trial).imgDat_target);
        Mask_Tex = Screen('MakeTexture',Exp.Cfg.win, TR(trial).imgDat_mask);
        
        Probe_Tex = Screen('MakeTexture',Exp.Cfg.win, TR(trial).imgDat_probe);
        Distr_Tex = Screen('MakeTexture',Exp.Cfg.win, TR(trial).imgDat_distractor);
        
        Trial_Tex = zeros(1,size(TR(trial).trial_vector,2));
        
        for imgDat = 1:size(TR(trial).trial_vector,2)
            Trial_Tex(imgDat) = Screen('MakeTexture',Exp.Cfg.win, TR(trial).trial_vector{imgDat});
        end
        
        if add_jitter
            % Add or subtract 5% of default target time for presentation
            targ_jitter = default_target_time*(0.1*(rand(1)-.5));
            target_time = default_target_time + targ_jitter;
            
            % Record target_time to TR struct
            TR(trial).target_time = target_time;
            
            % Create blank vectors for recording jittered times
            TR(trial).flip_vector = nan((length(TR(trial).trial_vector)),1);
            TR(trial).blank_vector = nan((length(TR(trial).trial_vector)),1);
            
            % Reset blank_time to default (80ms)
            blank_time = default_blank_time;
        end
        
        % Show target image for 3 seconds
        time_remaining = target_time;
        targetSecs = GetSecs;
        
        while time_remaining > 0
            
            Screen('DrawTexture', Exp.Cfg.win, Targ_Tex, [], [], tex_angle);
            
            Screen('Flip', Exp.Cfg.win, [], Exp.Cfg.AuxBuffers);
            
            time_elapsed = GetSecs - targetSecs;
            time_remaining = target_time - time_elapsed;
            
        end
        
        % Blank screen for 80ms
        blank_remaining = blank_time;
        blankSecs = GetSecs;
        
        % Present blank screen for 80ms (blank_time)
        while blank_remaining > 0
            
            Screen('FillRect', Exp.Cfg.win, Exp.Cfg.Color.gray);
            Screen('Flip', Exp.Cfg.win, [], Exp.Cfg.AuxBuffers);
            
            time_elapsed = GetSecs - blankSecs;
            blank_remaining = blank_time - time_elapsed;
            
        end
        
        %% PRESENT RSVP STREAM
        
        flag = 0;
        
        while(1)
            
            for lag = 1:length(TR(trial).trial_vector)
                
                if lag == TR(trial).target_lag
                    startTargetSecs = GetSecs;
                end
                
                tic;
                
                if add_jitter
                    % This wasn't used in our experiment but I've included
                    % the code in case a future manipulation jitters
                    % presentation
                    
                    % Add or subtract 5% of default times for presentation
                    flip_jitter = default_flip_time*(0.1*(rand(1)-.5)); %#ok<*UNRCH>
                    flip_time = default_flip_time + flip_jitter;
                    
                    blank_jitter = default_blank_time*(0.1*(rand(1)-.5));
                    blank_time = default_blank_time + blank_jitter;
                    
                    % Record flip & blank times to TR struct
                    TR(trial).flip_vector(lag) = flip_time;
                    TR(trial).blank_vector(lag) = blank_time;
                end
                
                % Prepare while-loop timing
                time_remaining = flip_time;
                blank_remaining = blank_time;
                
                startSecs = GetSecs;
                
                %% Present face for 200ms (flip_time)
                while time_remaining > 0
                    
                    Screen('DrawTexture', Exp.Cfg.win, Trial_Tex(lag), [], [], tex_angle);
                    
                    Screen('Flip', Exp.Cfg.win, [], Exp.Cfg.AuxBuffers);
                    
                    time_elapsed = GetSecs - startSecs;
                    time_remaining = flip_time - time_elapsed;
                    
                    [~,~,buttons] = GetMouse(Exp.Cfg.win);
                    
                    % Probably not going to need this anymore but saving
                    % just in case (2015-09-03)
                    % if lag == TR(trial).target_lag
                    %    detectTargetSecs = GetSecs - startTargetSecs;
                    % end
                    
                    if buttons(1)
                        flag = 1;
                        break
                    end
                    
                end
                
                if flag == 1;
                    break
                end
                
                blankSecs = GetSecs;
                
                %% Present blank screen for 80ms (blank_time)
                while blank_remaining > 0
                    
                    Screen('FillRect', Exp.Cfg.win, Exp.Cfg.Color.gray);
                    Screen('Flip', Exp.Cfg.win, [], Exp.Cfg.AuxBuffers);
                    
                    time_elapsed = GetSecs - blankSecs;
                    blank_remaining = blank_time - time_elapsed;
                    
                    [~,~,buttons] = GetMouse(Exp.Cfg.win);
                    
                    if buttons(1)
                        flag = 1;
                        break
                    end
                    
                end
                
                TR(trial).lag_times(lag) = toc;
                
                if flag == 1;
                    break
                end
                
            end
            
            %% Record how long it took to detect target
            % This will be used both to flag trials that were responded to
            % faster than an action can be prepared (here <100ms) and also
            % for analysis of target reaction times
            if lag >= TR(trial).target_lag
                detectTargetSecs = GetSecs - startTargetSecs;
                
                TR(trial).detectTargetSecs = detectTargetSecs;
            end
                                          
            %% Flag trials in response to target detection
            % Five conditions for TR.lag_flag:
            % 0 == Target Detected! Response screen presented
            % 1 == False Alarm! Clicked too early
            % 2 == False Alarm! Target detection <100ms (shorter than motor response)
            % 3 == Target Missed! Clicked too late
            % 4 == Target Missed! Didn't click at all
            
            TR(trial).lag_end = lag;
            
            if lag < TR(trial).target_lag
                
                % Mouse click before target, false alarm!
                TR(trial).lag_flag = 1;
                
            elseif detectTargetSecs < 0.1
                
                % Mouse clicked faster than target response can be made
                TR(trial).lag_flag = 2;
                
            elseif lag > (TR(trial).target_lag+2)
                
                % Mouse clicked too late
                TR(trial).lag_flag = 3;
                
            else
                
                % Mouse click on target
                TR(trial).lag_flag = 0;
                                               
                mask_remaining = mask_time;
                maskSecs = GetSecs;
                
                % Present mask for (mask_time)
                while mask_remaining > 0
                    
                    Screen('FillRect', Exp.Cfg.win, Exp.Cfg.Color.gray);
                    Screen('DrawTexture', Exp.Cfg.win, Mask_Tex, [], [], tex_angle);
                    Screen('Flip', Exp.Cfg.win, [], Exp.Cfg.AuxBuffers);
                    
                    time_elapsed = GetSecs - maskSecs;
                    mask_remaining = mask_time - time_elapsed;
                    
                end
                
            end
            
            if flag == 0
                
                % Mouse not pressed, miss trial!
                TR(trial).lag_flag = 4;
                
            end
            
            break
            
        end
        
        ShowCursor;
        
        % Blank screen for 80ms before presenting response wheel/flash
        Screen('FillRect', Exp.Cfg.win, Exp.Cfg.Color.gray);
        Screen('Flip', Exp.Cfg.win, [], Exp.Cfg.AuxBuffers);
        
        WaitSecs(0.08);
        
        %% RESPONSE SCREEN
        
        if TR(trial).lag_flag == 0
            
            ShowCursor;
            
            % Draw'n'flip confidence wheel
            [Exp, TR] = RSVP_response(Exp,TR,trial,Probe_Tex,Distr_Tex,invert);
            
            WaitSecs(.3);
            
            clicks = 0;
            
            % Wait until subject has given a response
            while clicks == 0
                
                [x,y] = getMouseResponse();
                
                % Check whether the click went inside a box area
                for m = 1 : size(Exp.polyL, 1)
                    idxs_left(m) = inpolygon(x,y,squeeze(Exp.polyL(m,1,:)),squeeze(Exp.polyL(m,2,:)));
                    
                    idxs_right(m) = inpolygon(x,y,squeeze(Exp.polyR(m,1,:)),squeeze(Exp.polyR(m,2,:)));
                end
                
                idx_pos_left = find(idxs_left == 1);
                idx_pos_right = find(idxs_right == 1);
                
                % Left boxes click
                if length(idx_pos_left) == 1 %~isempty(idx_pos_left)
                    keyid = -1;
                    keyid2 = idx_pos_left;
                    
                    clicks = 1;
                    
                    % Paint selected box blue
                    Screen('FillPoly', Exp.Cfg.win, [0 0 255], squeeze(Exp.polyL(idx_pos_left,:,:))',1);
                    for wait = 1:10
                        Screen('Flip', Exp.Cfg.win,  [], Exp.Cfg.AuxBuffers);
                    end
                    
                end
                
                if length(idx_pos_right) == 1 %~isempty(idx_pos_right)
                    keyid = 1;
                    keyid2 = idx_pos_right;
                    
                    clicks= 1;
                    
                    % Paint selected box blue
                    Screen('FillPoly', Exp.Cfg.win, [0 0 255], squeeze(Exp.polyR(idx_pos_right,:,:))',1);
                    for wait = 1:10
                        Screen('Flip', Exp.Cfg.win,  [], Exp.Cfg.AuxBuffers);
                    end
                    
                end
            end
            
            % Check response
            if keyid == -1
                response = 'left';
            elseif keyid == 1
                response = 'right';
            end
            
            if TR(trial).response_side < 0 % Probe on left
                trialType = 'left';
            else % Probe on right
                trialType = 'right';
            end
            
            %% SAVE RESPONSES AFTER EACH TRIAL
            
            TR(trial).keyid = keyid;
            TR(trial).response = strcmp(response, trialType);
            TR(trial).confidence = keyid2;
            
            TR(trial).mouse_pos = [x y];
            
            save([saving_path '.mat'], 'TR');
            
        elseif TR(trial).lag_flag == 1 || TR(trial).lag_flag == 2
            % Mouse clicked too early or <100ms after target onset
            flash_string = 'TOO EARLY!';
            
            flash_screen(Exp,flash_repeats,flash_time,flash_string);
            
        elseif TR(trial).lag_flag == 3 || TR(trial).lag_flag == 4
            % Mouse click too late or not at all
            flash_string = 'TARGET MISSED!';
            
            flash_screen(Exp,flash_repeats,flash_time,flash_string);
            
        end
        
    end
    
    %% END OF SESSION
    Screen('FillRect', Exp.Cfg.win, Exp.Cfg.Color.gray);
    DrawFormattedText(Exp.Cfg.win,Exp.End_Sesh,'center','center',Exp.Cfg.Color.black);
    Screen('Flip', Exp.Cfg.win, [], Exp.Cfg.AuxBuffers);
    
    save([saving_path '.mat'], 'TR');
    save([saving_path '_Settings.mat'], 'Exp', 'Gral');
    
    WaitSecs(4.5);
    
    sca;
    
elseif graceful_finish == 1
    
    cheers_emoticon = sprintf('\n\\{''3''}/\n');
    disp(cheers_emoticon)
    
end

end


