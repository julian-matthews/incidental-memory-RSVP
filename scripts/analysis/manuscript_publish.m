% Manuscript analysis publish version
%
% Creates summary of data for Behavioural RSVP Manuscript
 
% Load smp_dat from RSVP-repeated-subj-data.m file or run the following:
%
% low_level_analysis
% simple_analysis

%% EXPERIMENT 1a: WITHIN-SCENE, UPRIGHT, INCIDENTAL MEMORY 
% Twelve subjects took part in our replication of Kaunitz et al. (2016).
% This is the first experiment we ran. Faces were drawn from a separate 
% crowd photograph on each of the 160 trials per session with subjects
% performing two sessions on separate days.

%% Target accuracy (hits versus misses/false alarms)

hits = COND(1).RUNS.NUMS./40;
deviation_hits = std(hits,0,2);
over_hits = sum(COND(1).RUNS.NUMS,2)./320;
barwitherr(deviation_hits,over_hits);
hold on
line([0 13],[.5 .5],'k')
box off
colormap('white');
ylim([0.5 1])
xlim([0 13])
ylabel('Proportion of Hits');
xlabel('Subject');
title('Experiment 1a: Target Accuracy');

%%
% Proportion of targets accurately detected for each participant in
% Experiment 1a. Error bars reflect standard error of the mean between
% experimental blocks (8 in total).
%
% If proportion of target hits is low this raises the
% possibility that this subject may have paid undue attention to the
% incidental memory task.Incidental memory was only tested if the target 
% was successfully detected.

%% Objective Performance