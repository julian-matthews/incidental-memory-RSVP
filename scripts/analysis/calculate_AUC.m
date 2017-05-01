function [dp, auc] = calculate_AUC (freq_table)


% input: frequency table accuracy x n confidence values observations
% (ordered from lower confidence to higher confidence)
% row 1: correct responses
% row 2: incorrect responses
% cols : confidence rating


% Build cumulative table

total = sum(freq_table, 2);
proportions = [ freq_table(1, :) / total(1) ;  freq_table(2, :) / total(2)];

for m = 1 : size(proportions, 2)
    
    % HERE WE NEED TO DO 1 - PROPORTION TO CALCULATE THE TPR AND
    % FPR FOR THE HIGH CONFIDENCE TRIALS!!! HIGH CONFIDENCE ARE
    % HITS AND FALSE ALARMS
    cumulative_table(1, m) = sum(proportions(1, (end - m+1) : end), 2); %#ok correct cumulative proportion
    cumulative_table(2, m) = sum(proportions(2, (end - m+1) : end), 2); %#ok incorrect responses cumulative proportion
end


% calculates and returns d prime and the Area Under the ROC Curve

dp = dprime(cumulative_table(1,:), cumulative_table(2,:));

auc = AreaUnderROC( cumulative_table' ); 




%% Just copied here the version of the function 'dprime' from eeglab to make it portable

function [d,beta] = dprime(pHit,pFA)

%-- Convert to Z scores, no error checking
zHit = norminv(pHit) ;
zFA  = norminv(pFA) ;

%-- Calculate d-prime
d = zHit - zFA ;

%-- If requested, calculate BETA
if (nargout > 1)
  yHit = normpdf(zHit) ;
  yFA  = normpdf(zFA) ;
  beta = yHit ./ yFA ;
end




