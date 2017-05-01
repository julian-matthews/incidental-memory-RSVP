% 2015-09-07 'Accuracy at each confidence level & lag'
% Developed with Nao's advice, calculates mean accuracies at a variety of
% confidence & lag permutations.
% Assumes confidence = column 2, accuracy = column 3, & lag = column 6


function [MeanAccuracies] = acc_at_conf(data)

% Define max and min lag levels
all_lags = unique(data(:,6));

% Arrange from longest to shortest lag
lags = sort(all_lags,'ascend');

%% MEAN ACCURACY @ EACH CONFIDENCE LEVEL
mAcc = [];
mAcc_num = [];

iCounter = 0;

for conf = -4:4
    % Pointer to trials with confidence at a given level (conf)
    tmp = data(:,2) == conf;
        
    iCounter = iCounter + 1;
    
    % Mean accuracy for trials with confidence at a given level (conf)
    mAcc(iCounter) = mean(data(tmp,3));
    
    mAcc_num(iCounter) = sum(tmp);
    
end

mAcc = mAcc(:,~isnan(mAcc(1,:)));

%% MEAN ACCURACY @ EACH CONFIDENCE LEVEL FOR EACH LAG
mAcc_lag = [];

mAcc_lag_num = [];

for step = 1:length(lags)
    
    iCounter = 0;
    lag = lags(step);
    
    for conf = -4:4
        % Pointer to trials with (abs) conf of a particular lag
        tmp = data(:,2) == conf & data(:,6) == lag;
        
        iCounter = iCounter + 1;
        
        mAcc_lag(step,iCounter) = mean(data(tmp,3));
        
        mAcc_lag_num(step,iCounter) = sum(tmp);
    end
    
end

mAcc_lag = mAcc_lag(:,~isnan(mAcc_lag(1,:)));

%% MEAN ACCURACY @ EACH (ABSOLUTE) CONFIDENCE LEVEL
mAcc_abs = [];
mAcc_abs_num = [];
iCounter = 0;

for conf = 1:4
    % Pointer to trials with (absolute) confidence @ level (conf)
    tmp = abs(data(:,2)) == conf;
    
    iCounter = iCounter + 1;
    
    % Mean accuracy for trials with (absolute) confidence @ level (conf)
    mAcc_abs(iCounter) = mean(data(tmp,3));
    
    mAcc_abs_num(iCounter) = sum(tmp);
    
end

%% MEAN ACCURACY @ EACH (ABSOLUTE) CONFIDENCE LEVEL FOR EACH LAG
mAcc_abs_lag = [];
mAcc_abs_lag_num = [];

for step = 1:length(lags)
    
    iCounter = 0;
    lag = lags(step);
    
    for conf = 1:4
        % Pointer to trials with (abs) conf of a particular lag
        tmp = abs(data(:,2)) == conf & data(:,6) == lag;
        
        iCounter = iCounter + 1;
        
        mAcc_abs_lag(step,iCounter) = mean(data(tmp,3));
        
        mAcc_abs_lag_num(step,iCounter) = sum(tmp);
    end
    
end

%% ASSIGN TO MeanAccuracies STRUCT

for lag = 1:length(lags)
MeanAccuracies.Lag_Conditions{lag} = num2str(lags(lag));

MeanAccuracies.mAcc = mAcc;
MeanAccuracies.mAcc_num = mAcc_num;

MeanAccuracies.mAcc_abs = mAcc_abs;
MeanAccuracies.mAcc_abs_num = mAcc_abs_num;

MeanAccuracies.mAcc_lag = mAcc_lag;
MeanAccuracies.mAcc_lag_num = mAcc_lag_num;

MeanAccuracies.mAcc_abs_lag = mAcc_abs_lag;
MeanAccuracies.mAcc_abs_lag_num = mAcc_abs_lag_num;

end
