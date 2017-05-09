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
h = line([0 13],[.5 .5]);
set(h, 'LineStyle',':','Color','k')
box off
colormap('white');
ylim([0.4 1])
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

%% Probe Objective Performance at each Lag Position

SEM_subj = nanstd(COND(1).LAGS.OBJPER);
barwitherr(SEM_subj,COND(1).LAGS.OP_means);
hold on
eb = errorbar(COND(1).LAGS.OP_means,COND(1).LAGS.OP_SEMs);
h = line([0 5],[.5 .5]);
set(h, 'LineStyle',':','Color','k')
box off
colormap('white');
set(eb, 'LineStyle','none','LineWidth',4,'Color','r')
set(gca,'XTickLabel',{'-1','-3','-5','-7'});
ylim([0.4 1])
xlim([0 5])
ylabel('Type-I AUC');
xlabel('Lag Position relative to Target');
title('Experiment 1a: Probe Objective Performance');

%%
% Objective Performance (Type-I AUC) for probe detection at each lag 
% position in Experiment 1a. Black error bars reflect standard error of 
% the mean between subjects. Error is considerably lower between blocks,
% these values are superimposed in red (averaged between subjects).
%
% Probes are detected above chance at each lag position. It also appears
% that performance might be significantly greater at lag -1. This seems to
% nix the possibility of a "reverse attentional blink". It seems very
% unlikely that a significant difference exists between the other lag
% positions which is interesting in and of itself.

%% Probe Metacognition at each Lag Position

SEM_subj = nanstd(COND(1).LAGS.META);
barwitherr(SEM_subj,COND(1).LAGS.Meta_means);
hold on
eb = errorbar(COND(1).LAGS.Meta_means,COND(1).LAGS.Meta_SEMs);
h = line([0 5],[.5 .5]);
set(h, 'LineStyle',':','Color','k')
box off
colormap('white');
set(eb, 'LineStyle','none','LineWidth',4,'Color','r')
set(gca,'XTickLabel',{'-1','-3','-5','-7'});
ylim([0.4 .8])
xlim([0 5])
ylabel('Type-II AUC');
xlabel('Lag Position relative to Target');
title('Experiment 1a: Probe Metacognition');

%%
% NB. Change in axis dimensions to best capture results!
%
% Metacognition (Type-II AUC) for probe detection at each lag position in
% Experiment 1a. As above, black error bars reflect standard error of the 
% mean between subjects. Error is considerably lower between blocks, these 
% values are superimposed in red (averaged between subjects).
%
% Metacognition appears to be above chance at each lag position

% Probes are detected above chance at each lag position. It also appears
% that performance might be significantly greater at lag -1. This seems to
% nix the possibility of a "reverse attentional blink". It seems very
% unlikely that a significant difference exists between the other lag
% positions which is interesting in and of itself.