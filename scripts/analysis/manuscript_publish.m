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
ylim([0.2 1])
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
ylim([0.4 .9])
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
ylim([0.4 .75])
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
% Metacognition appears to be above chance at each lag position and are
% unlikely to differ significantly between lag positions. We see a slight
% dip at lag position -5 when compared to lag position -7 which may reflect
% some slight primacy effects at the "earliest" lag relative to the
% sequence. This would be moderated by the fact that sequences ranged from
% 8 to 15 items in length so a lag of -7 is only in such a position in a 
% small proportion of trials.

%% Probe Confidence at each Lag Position

SEM_subj = nanstd(COND(1).LAGS.CONFID);
barwitherr(SEM_subj,COND(1).LAGS.Conf_means);
hold on
eb = errorbar(COND(1).LAGS.Conf_means,COND(1).LAGS.Conf_SEMs);
box off
colormap('white');
set(eb, 'LineStyle','none','LineWidth',4,'Color','r')
set(gca,'XTickLabel',{'-1','-3','-5','-7'});
set(gca,'YTick',1:4);
ylim([0.75 4.25])
xlim([0 5])
ylabel('Confidence Level');
xlabel('Lag Position relative to Target');
title('Experiment 1a: Probe Confidence');

%%
% Confidence for probe detection at each lag position in Experiment 1a.
% Error bars are reflected in the same way as the above analyses.
%
% Confidence does not appear to differ significantly between lags although
% a slight trend can be seen such that confidence is higher for probes that
% appeared closer to the target (early lags relative to the target).
%
% Confidence is also quite high overall (~3). This will be an interesting 
% contrast with the inverted condition of this within-scene experiment 
% since these are the same subjects. Anecdotally, we might expect confidence
% to be lower for the inverted condition since this felt more difficult to
% me and according to many of our participants.

%% EXPERIMENT 1b: WITHIN-SCENE, INVERTED, INCIDENTAL MEMORY 
% The second phase of our Kaunitz et al. (2016) replication. This
% analysis was performed for the same set of participants that took part in
% Experiment 1a and excludes 3 subjects that did not take part in the
% upright version. 

%% Target accuracy (hits versus misses/false alarms)

hits = COND(2).RUNS.NUMS./40;
deviation_hits = std(hits,0,2);
over_hits = sum(COND(2).RUNS.NUMS,2)./320;
barwitherr(deviation_hits,over_hits);
hold on
h = line([0 13],[.5 .5]);
set(h, 'LineStyle',':','Color','k')
box off
colormap('white');
ylim([0.2 1])
xlim([0 13])
ylabel('Proportion of Hits');
xlabel('Subject');
title('Experiment 1b: Target Accuracy');

%%
% NB. These are the same subjects as Experiment 1a but the subject numbers
% are not matched (i.e. Subject #1 here is not Subject #1 from Exp 1a)! 
%
% Proportion of targets accurately detected for each participant in
% Experiment 1b. Error bars reflect standard error of the mean between
% experimental blocks (8 in total).
%
% If proportion of target hits is low this raises the possibility that 
% this subject may have paid undue attention to the incidental memory task.
% This is a potential for 3 of our participants here although the
% incidental memory test was only performed when the target was detected so
% these subjects only contributed a small number of trials to the overall
% analysis.

%% Probe Objective Performance at each Lag Position

SEM_subj = nanstd(COND(2).LAGS.OBJPER);
barwitherr(SEM_subj,COND(2).LAGS.OP_means);
hold on
eb = errorbar(COND(2).LAGS.OP_means,COND(2).LAGS.OP_SEMs);
h = line([0 5],[.5 .5]);
set(h, 'LineStyle',':','Color','k')
box off
colormap('white');
set(eb, 'LineStyle','none','LineWidth',4,'Color','r')
set(gca,'XTickLabel',{'-1','-3','-5','-7'});
ylim([0.4 .8])
xlim([0 5])
ylabel('Type-I AUC');
xlabel('Lag Position relative to Target');
title('Experiment 1b: Probe Objective Performance');

%%
%
% NB. Change in y-axes compared to Experiment 1a
%
% Objective Performance (Type-I AUC) for probe detection at each lag 
% position in Experiment 1b. Black error bars reflect standard error of 
% the mean between subjects. Error is considerably lower between blocks,
% these values are superimposed in red (averaged between subjects).
%
% It still appears that probes are detected above chance at each lag
% position though performance is moderated compared to the upright version.
% The lag -1 advantage seems apparent here too which might confirm that a
% "reverse attentional blink" does not occur for this form of task. There
% doesn't appear to be a significant difference in performance for the
% other conditions.

%% Probe Metacognition at each Lag Position

SEM_subj = nanstd(COND(2).LAGS.META);
barwitherr(SEM_subj,COND(2).LAGS.Meta_means);
hold on
eb = errorbar(COND(2).LAGS.Meta_means,COND(2).LAGS.Meta_SEMs);
h = line([0 5],[.5 .5]);
set(h, 'LineStyle',':','Color','k')
box off
colormap('white');
set(eb, 'LineStyle','none','LineWidth',4,'Color','r')
set(gca,'XTickLabel',{'-1','-3','-5','-7'});
ylim([0.4 .75])
xlim([0 5])
ylabel('Type-II AUC');
xlabel('Lag Position relative to Target');
title('Experiment 1b: Probe Metacognition');

%%
% NB. Y-axis is same as that reflected in Experiment 1a
%
% Metacognition (Type-II AUC) for probe detection at each lag position in
% Experiment 1b. Error bars as usual.
%
% Metacognition is likely to be above chance for all lag positions
% (although lag -3 requires examination). We might see a slight moderation
% of metacognition when compared to Experiment 1a but it isn't much if it
% exists. The tasks certainly "feel" different so this is interesting.
%
% We see the same metacognitive primacy effect as in Experiment 1a
% although this is unlikely to reach significance.

%% Probe Confidence at each Lag Position

SEM_subj = nanstd(COND(2).LAGS.CONFID);
barwitherr(SEM_subj,COND(2).LAGS.Conf_means);
hold on
eb = errorbar(COND(2).LAGS.Conf_means,COND(2).LAGS.Conf_SEMs);
box off
colormap('white');
set(eb, 'LineStyle','none','LineWidth',4,'Color','r')
set(gca,'XTickLabel',{'-1','-3','-5','-7'});
set(gca,'YTick',1:4);
ylim([0.75 4.25])
xlim([0 5])
ylabel('Confidence Level');
xlabel('Lag Position relative to Target');
title('Experiment 1b: Probe Confidence');

%%
% Confidence for probe detection at each lag position in Experiment 1b.
% Error bars are reflected in the same way as the above analyses.
%
% Confidence does not appear to differ significantly between lags although
% a slight trend can be seen such that confidence is higher for probes that
% appeared closer to the target (early lags relative to the target). This
% is the same general trend that was seen in Experiment 1a.
%
% Confidence remains quite high overall although might be .5 of a level
% lower than in Experiment 1a. This matches the difficulty that people
% reportedly had with this task when compared to the upright version.
% Within-subject statistics can be performed here to reveal such a
% difference.

