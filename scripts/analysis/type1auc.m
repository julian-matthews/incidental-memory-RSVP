%% 2015-12-17 Julian - Type-I AUC calculator
% Objective Performance modified for -4 to 4 confidence judgments

% Input signal truth ('signal') = [-1 1] or Left & Right
% Input choices ('decision') = [-4 : 4] or 1:4 Left & 1:4 Right

% Output is a pure frequency table and cumulative frequencies
% Also Type-I AUC calculated using AreaUnderROC

function [Frequencies, Cumulative_Frequencies, Type_One_AUC] = type1auc(signal,decision)

Frq = zeros(2,8);

for row = 1:length(signal)
    for confidence = 1:4 % Right responses
        if decision(row) == confidence && signal(row) > 0
            Frq(2,confidence+4) = (Frq(2,confidence+4)+1); % correct_rejection
        elseif decision(row) == confidence && signal(row) < 0
            Frq(1,(confidence+4)) = (Frq(1,(confidence+4)))+1; % miss
        end
    end
    for confidence = -4:-1 % Left responses
        if decision(row) == confidence && signal(row) < 0
            Frq(1,(confidence+5)) = (Frq(1,(confidence+5)))+1; % hit
        elseif decision(row) == confidence && signal(row) > 0
            Frq(2,(confidence+5)) = (Frq(2,(confidence+5)))+1; % false alarm
        end
    end
    
end

% Save Frequencies table
Frequencies = Frq;

% Convert to proportions
for column = 1:length(Frq)
    Frq_Pro(1,column) = (Frq(1,column)/sum(Frq(1,:)));
    Frq_Pro(2,column) = (Frq(2,column)/sum(Frq(2,:)));
end

% Cumulative proportions
for column = 1:length(Frq_Pro)
    Frq_Cum(1,column) = sum(Frq_Pro(1,(1:column)));
    Frq_Cum(2,column) = sum(Frq_Pro(2,(1:column)));
end

% Save Cumulative Frequencies table
Cumulative_Frequencies = Frq_Cum;

% Alternative method using trapz seems to give same result as AUC function
% Check the plot:
% plot([0 Frq_Cum(2,:)],[0 Frq_Cum(1,:)])
% trapz([0 Frq_Cum(2,:)],[0 Frq_Cum(1,:)])

% Calculate area under ROC curve and save as Type_One_AUC
Type_One_AUC = AreaUnderROC([Frq_Cum(1,:);Frq_Cum(2,:)]');

end

%% INCLUDE AreaUnderROC FUNCTION TO MAKE PORTABLE

function area = AreaUnderROC(ROC)
% area = AreaUnderROC(ROC)
%
% Compute the area under an ROC curve.
%
% xx/xx/xx  dhb  Wrote it.

[NFA,index] = sort(ROC(:,2));
NROC(:,1) = ROC(index,1);
NROC(:,2) = ROC(index,2);
[m,n] = size(NROC);

FROC = zeros(m+2,n);
FROC(1,:) = [0, 0];
FROC(m+2,:) = [1, 1];
FROC(2:m+1,:) = NROC;

area = 0;
totwidth = 0;
for i = 1:m+1
    meanhgt = (FROC(i,1)+FROC(i+1,1))/2;
    width = FROC(i+1,2)-FROC(i,2);
    area = area+meanhgt*width;
    totwidth = totwidth+width;
end

end