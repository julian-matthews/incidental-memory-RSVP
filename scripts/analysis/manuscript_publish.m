% BEHAVIOURAL RSVP: MANUSCRIPT PUBLISH SCRIPT
% Creates summary of data for Behavioural RSVP Manuscript
 
% Run the following to conduct analysis:
% low_level_analysis % Or load RSVP-repeated-subj-data.mat
simple_analysis % Computes within-subject error using O'Brien & Cousinea (2014)

%% EXPERIMENT 1a: WITHIN-SCENE, UPRIGHT, INCIDENTAL MEMORY 
% Twelve subjects took part in our replication of Kaunitz et al. (2016).
% This is the first experiment we ran. Faces were drawn from a separate 
% crowd photograph on each of the 160 trials per session with subjects
% performing two sessions on separate days.

%% Target accuracy (hits versus misses/false alarms)

figure;
hits = COND(1).RUNS.NUMS./40;
deviation_hits = within_subject_error(hits); % within-subj SEM
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
% incidental memory task. Incidental memory was only tested if the target 
% was successfully detected.

%% Probe Objective Performance at each Lag Position

% Implement within_subject_error.m
figure;
% SEM_subj = nanstd(COND(1).LAGS.OBJPER)/sqrt(size(COND(1).LAGS.OBJPER,1)); % SEM
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

figure;
SEM_subj = nanstd(COND(1).LAGS.META)/sqrt(size(COND(1).LAGS.META,2)); % SEM
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

figure;
SEM_subj = nanstd(COND(1).LAGS.CONFID)/sqrt(size(COND(1).LAGS.CONFID,2)); % SEM
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

figure;
hits = COND(2).RUNS.NUMS./40;
deviation_hits = std(hits,0,2)/sqrt(size(hits,2));
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

figure;
SEM_subj = nanstd(COND(2).LAGS.OBJPER)/sqrt(size(COND(2).LAGS.OBJPER,2)); % SEM
barwitherr(SEM_subj,COND(2).LAGS.OP_means);
hold on
eb = errorbar(COND(2).LAGS.OP_means,COND(2).LAGS.OP_SEMs);
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
title('Experiment 1b: Probe Objective Performance');

%%
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

figure;
SEM_subj = nanstd(COND(2).LAGS.META)/sqrt(size(COND(2).LAGS.META,2));
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

figure;
SEM_subj = nanstd(COND(2).LAGS.CONFID)/sqrt(size(COND(2).LAGS.CONFID,2));
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

%% EXPERIMENT 2a: ACROSS-SCENE, UPRIGHT, INCIDENTAL MEMORY 
% Our novel procedure that combined face stimuli from all of our crowd
% photographs (4225 faces in total). This experiment was performed with a
% new set of participants when compared to Experiment 1, this group also
% conducted the upright version of our "no-target" experiment (3a).

%% Target accuracy (hits versus misses/false alarms)

figure;
hits = COND(3).RUNS.NUMS./40;
deviation_hits = std(hits,0,2)/sqrt(size(hits,2));
over_hits = sum(COND(3).RUNS.NUMS,2)./320;
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
title('Experiment 2a: Target Accuracy');

%%
%
% NB. These are new subjects compared to Experiment 1
%
% Proportion of targets accurately detected for each participant in
% Experiment 2a. Error bars reflect standard error of the mean between
% experimental blocks (8 in total).
%
% Proportion of hits is very high for all subjects. Seems unlikely that
% undue attention was paid to the probe task for these participants.

%% Probe Objective Performance at each Lag Position

figure;
SEM_subj = nanstd(COND(3).LAGS.OBJPER)/sqrt(size(COND(3).LAGS.OBJPER,2));
barwitherr(SEM_subj,COND(3).LAGS.OP_means);
hold on
eb = errorbar(COND(3).LAGS.OP_means,COND(3).LAGS.OP_SEMs);
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
title('Experiment 2a: Probe Objective Performance');

%%
% Objective Performance (Type-I AUC) for probe detection at each lag 
% position in Experiment 2a. Black error bars reflect standard error of 
% the mean between subjects. Error is considerably lower between blocks,
% these values are superimposed in red (averaged between subjects).
%
% We see strong probe detection for all lags with a steady moderation in
% performance as probes appear further from the target. Performance appears
% above chance for all lags and is especially strong for lag position -1
% (approaching ceiling for some subjects judging from between subject
% error). 
%
% There appears to be no significant difference between lags -5 and -7 
% possibly as a result of a primacy effect for the -7 position.

%% Probe Metacognition at each Lag Position

figure;
SEM_subj = nanstd(COND(3).LAGS.META)/sqrt(size(COND(3).LAGS.META,2));
barwitherr(SEM_subj,COND(3).LAGS.Meta_means);
hold on
eb = errorbar(COND(3).LAGS.Meta_means,COND(3).LAGS.Meta_SEMs);
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
title('Experiment 2a: Probe Metacognition');

%%
% Metacognition (Type-II AUC) for probe detection at each lag position in
% Experiment 2a. Error bars as usual.
%
% Metacognition appears to be strong for all lag positions and, like
% performance, drops as the probe appears further from the target. No
% obvious difference in the -5 & -7 lags which is possibly moderated by the
% primacy effect discussed above.

%% Probe Confidence at each Lag Position

figure;
SEM_subj = nanstd(COND(3).LAGS.CONFID)/sqrt(size(COND(3).LAGS.CONFID,2));
barwitherr(SEM_subj,COND(3).LAGS.Conf_means);
hold on
eb = errorbar(COND(3).LAGS.Conf_means,COND(3).LAGS.Conf_SEMs);
box off
colormap('white');
set(eb, 'LineStyle','none','LineWidth',4,'Color','r')
set(gca,'XTickLabel',{'-1','-3','-5','-7'});
set(gca,'YTick',1:4);
ylim([0.75 4.25])
xlim([0 5])
ylabel('Confidence Level');
xlabel('Lag Position relative to Target');
title('Experiment 2a: Probe Confidence');

%%
% Confidence for probe detection at each lag position in Experiment 2a.
% Error bars are reflected in the same way as the above analyses.
%
% Confidence varies slightly between the lag positions but is unlikely to
% reach significance. Overall, confidence is lower for this experiment than
% the upright, within-scene version but these are different participants so
% between subject statistics would be required to support a significant
% difference.

%% EXPERIMENT 2b: ACROSS-SCENE, INVERTED, INCIDENTAL MEMORY 
% The inverted version of our novel experiment that combined face images
% from all crowd photographs, further limiting the influence of semantic
% coherency and contextual cues that might be present in each image but
% emphasising the influence of memorable, low-level details from specific
% faces.
%
% This analysis was performed for a new set of participants when compared
% to Experiment 2a (and Experiment 1) so if statistical comparison is made,
% it will be between subjects.

%% Target accuracy (hits versus misses/false alarms)

figure;
hits = COND(4).RUNS.NUMS./40;
deviation_hits = std(hits,0,2)/sqrt(size(hits,2));
over_hits = sum(COND(4).RUNS.NUMS,2)./320;
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
title('Experiment 2b: Target Accuracy');

%%
% NB. These are NOT the same subjects as Experiment 2a 
%
% Proportion of targets accurately detected for each participant in
% Experiment 2b. Error bars reflect standard error of the mean between
% experimental blocks (8 in total).
%
% Strong performance on this task overall and certainly better than the
% within-scene version of this inverted face task. Using across-scene faces
% may have introduced a greater number of salient low-level details that
% permitted strong performance in this task.

%% Probe Objective Performance at each Lag Position

figure;
SEM_subj = nanstd(COND(4).LAGS.OBJPER)/sqrt(size(COND(4).LAGS.OBJPER,2));
barwitherr(SEM_subj,COND(4).LAGS.OP_means);
hold on
eb = errorbar(COND(4).LAGS.OP_means,COND(4).LAGS.OP_SEMs);
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
title('Experiment 2b: Probe Objective Performance');

%%
% Objective Performance (Type-I AUC) for probe detection at each lag 
% position in Experiment 2b. Usual error bars reflecting SEMs between
% subjects and, in red, over blocks while averaging between subjects.
%
% Probe performance is still quite strong for the across-scene task and
% appears stronger than the inverted, within-scene version of this
% experiment (although that was conducted with a different set of subjects
% so between subject statistics apply).
%
% We see the influence of primacy and receny effects as discussed for other
% versions of this task though statistically significant differences are
% only obvious between lags -1 and -3 (such that lag -1 is associated with
% the strongest probe performance).

%% Probe Metacognition at each Lag Position

figure;
SEM_subj = nanstd(COND(4).LAGS.META)/sqrt(size(COND(4).LAGS.META,2));
barwitherr(SEM_subj,COND(4).LAGS.Meta_means);
hold on
eb = errorbar(COND(4).LAGS.Meta_means,COND(4).LAGS.Meta_SEMs);
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
title('Experiment 2b: Probe Metacognition');

%%
% Metacognition (Type-II AUC) for probe detection at each lag position in
% Experiment 2b. Error bars as above.
%
% Again, metacognition appears to be above chance for all lag positions but
% quite unlikely that a significant difference exists between any of the
% positions. In comparison to Experiment 1b, metacognition seems stronger 
% overall but between subject statistics would be required to show this.

%% Probe Confidence at each Lag Position

figure;
SEM_subj = nanstd(COND(4).LAGS.CONFID)/sqrt(size(COND(4).LAGS.CONFID,2));
barwitherr(SEM_subj,COND(4).LAGS.Conf_means);
hold on
eb = errorbar(COND(4).LAGS.Conf_means,COND(4).LAGS.Conf_SEMs);
box off
colormap('white');
set(eb, 'LineStyle','none','LineWidth',4,'Color','r')
set(gca,'XTickLabel',{'-1','-3','-5','-7'});
set(gca,'YTick',1:4);
ylim([0.75 4.25])
xlim([0 5])
ylabel('Confidence Level');
xlabel('Lag Position relative to Target');
title('Experiment 2b: Probe Confidence');

%%
% Confidence for probe detection at each lag position in Experiment 2b.
% Error bars as usual.
%
% Confidence appears unchanged between lags. Overall, this inverted version
% has slightly lower confidence than the upright, across-scene experiment
% but this is a between subjects difference so statistics may not bear it
% out.

%% EXPERIMENT 3a: ACROSS-SCENE, UPRIGHT, EXPLICIT MEMORY 
% The contrasting conditions for Experiment 2. This version of the
% across-scene task did not involve target search. Instead, subjects were
% instructed to explicitly remember every face. The subjects from
% Experiment 2a also participated in Experiment 3a.
%
% Since no target search was required we will skip straight to our analysis
% of probe measures.

%% Probe Objective Performance at each Lag Position

figure;
SEM_subj = nanstd(COND(5).LAGS.OBJPER)/sqrt(size(COND(5).LAGS.OBJPER,2));
barwitherr(SEM_subj,COND(5).LAGS.OP_means);
hold on
eb = errorbar(COND(5).LAGS.OP_means,COND(5).LAGS.OP_SEMs);
h = line([0 5],[.5 .5]);
set(h, 'LineStyle',':','Color','k')
box off
colormap('white');
set(eb, 'LineStyle','none','LineWidth',4,'Color','r')
set(gca,'XTickLabel',{'-1','-3','-5','-7'});
ylim([0.4 .9])
xlim([0 5])
ylabel('Type-I AUC');
xlabel('Lag Position relative to final face');
title('Experiment 3a: Probe Objective Performance');

%%
% Objective Performance (Type-I AUC) for probe detection at each lag 
% position in Experiment 3a. We use the typical error bar conventions for
% this document.
%
% These results are comparative to the incidental memory version of this
% task (2a) although performance is slightly stronger for each lag.
% Within-subjects statistics can be used to examine whether the difference
% reaches significance.
%
% There is unlikely to be a significant difference in performance between
% the -5 and -7 lags although this might be the result of a small primacy
% effect as discussed above.

%% Probe Metacognition at each Lag Position

figure;
SEM_subj = nanstd(COND(5).LAGS.META)/sqrt(size(COND(5).LAGS.META,2));
barwitherr(SEM_subj,COND(5).LAGS.Meta_means);
hold on
eb = errorbar(COND(5).LAGS.Meta_means,COND(5).LAGS.Meta_SEMs);
h = line([0 5],[.5 .5]);
set(h, 'LineStyle',':','Color','k')
box off
colormap('white');
set(eb, 'LineStyle','none','LineWidth',4,'Color','r')
set(gca,'XTickLabel',{'-1','-3','-5','-7'});
ylim([0.4 .75])
xlim([0 5])
ylabel('Type-II AUC');
xlabel('Lag Position relative to final face');
title('Experiment 3a: Probe Metacognition');

%%
% Metacognition (Type-II AUC) for probe detection at each lag position in
% Experiment 3a. Error bars as usual.
%
% Again, we see strong metacognition for all lag positions which is
% unlikely to differ significantly. 

%% Probe Confidence at each Lag Position

figure;
SEM_subj = nanstd(COND(5).LAGS.CONFID)/sqrt(size(COND(5).LAGS.CONFID,2));
barwitherr(SEM_subj,COND(5).LAGS.Conf_means);
hold on
eb = errorbar(COND(5).LAGS.Conf_means,COND(5).LAGS.Conf_SEMs);
box off
colormap('white');
set(eb, 'LineStyle','none','LineWidth',4,'Color','r')
set(gca,'XTickLabel',{'-1','-3','-5','-7'});
set(gca,'YTick',1:4);
ylim([0.75 4.25])
xlim([0 5])
ylabel('Confidence Level');
xlabel('Lag Position relative to final face');
title('Experiment 3a: Probe Confidence');

%%
% Confidence for probe detection at each lag position in Experiment 3a.
% Standard SEM error bars.
%
% A trend of confidence lowering as probes appear eariler in the sequence
% can be seen but this is unlikely to reach significance judging from the
% error bars between blocks. Confidence judgments do not appear to differ
% drastically when compared to the incidental version of this task.

%% EXPERIMENT 3b: ACROSS-SCENE, INVERTED, EXPLICIT MEMORY 
% The inverted version of our explicit memory experiment. As in Experiment
% 3a, no target search was conducted. Subjects focussed on all items in the
% sequence.
%
% The subjects in this experiment also conducted Experiment 2b.

%% Probe Objective Performance at each Lag Position

figure;
SEM_subj = nanstd(COND(6).LAGS.OBJPER)/sqrt(size(COND(6).LAGS.OBJPER,2));
barwitherr(SEM_subj,COND(6).LAGS.OP_means);
hold on
eb = errorbar(COND(6).LAGS.OP_means,COND(6).LAGS.OP_SEMs);
h = line([0 5],[.5 .5]);
set(h, 'LineStyle',':','Color','k')
box off
colormap('white');
set(eb, 'LineStyle','none','LineWidth',4,'Color','r')
set(gca,'XTickLabel',{'-1','-3','-5','-7'});
ylim([0.4 .9])
xlim([0 5])
ylabel('Type-I AUC');
xlabel('Lag Position relative to final face');
title('Experiment 3b: Probe Objective Performance');

%%
% Objective Performance (Type-I AUC) for probe detection at each lag 
% position in Experiment 3b. Error bars as usual.
%
% Probe performance is strong for the inverted version of the explicit
% memory task. All lag positions should be significantly above chance. We
% appear to see a stronger effect between lag positions than in other
% versions of the task. Lag -1 is definitely stronger than the later lags.

%% Probe Metacognition at each Lag Position

figure;
SEM_subj = nanstd(COND(6).LAGS.META)/sqrt(size(COND(6).LAGS.META,2));
barwitherr(SEM_subj,COND(6).LAGS.Meta_means);
hold on
eb = errorbar(COND(6).LAGS.Meta_means,COND(6).LAGS.Meta_SEMs);
h = line([0 5],[.5 .5]);
set(h, 'LineStyle',':','Color','k')
box off
colormap('white');
set(eb, 'LineStyle','none','LineWidth',4,'Color','r')
set(gca,'XTickLabel',{'-1','-3','-5','-7'});
ylim([0.4 .75])
xlim([0 5])
ylabel('Type-II AUC');
xlabel('Lag Position relative to final face');
title('Experiment 3b: Probe Metacognition');

%%
% Metacognition (Type-II AUC) for probe detection at each lag position in
% Experiment 3b. Error bars as above.
%
% Metacognition is likely to be above chance for all lag positions although
% we see an almost step-like difference between the -1/-3 lags and the
% later lags of -5/-7. This is likely to hold up to significance testing.

%% Probe Confidence at each Lag Position

figure;
SEM_subj = nanstd(COND(6).LAGS.CONFID)/sqrt(size(COND(6).LAGS.CONFID,2));
barwitherr(SEM_subj,COND(6).LAGS.Conf_means);
hold on
eb = errorbar(COND(6).LAGS.Conf_means,COND(6).LAGS.Conf_SEMs);
box off
colormap('white');
set(eb, 'LineStyle','none','LineWidth',4,'Color','r')
set(gca,'XTickLabel',{'-1','-3','-5','-7'});
set(gca,'YTick',1:4);
ylim([0.75 4.25])
xlim([0 5])
ylabel('Confidence Level');
xlabel('Lag Position relative to final face');
title('Experiment 3b: Probe Confidence');

%%
% Confidence for probe detection at each lag position in Experiment 3b.
% Error bars as usual.
%
% Confidence is quite comparative between lag positions. Appears to be
% lower overall than the upright version of this task and possibly lower
% than the incidental memory version of this task which might reflect
% changes in metacognition between these experiments.

%% COMPARISONS BETWEEN CONDITIONS
% Here is a summary of some basic comparisons between relevant conditions.

figure;
MEAN_subj = zeros(6,4);
SEM_subj = zeros(6,4);
for condition = 1:6
    MEAN_subj(condition,:) = nanmean(COND(condition).LAGS.OBJPER);
    SEM_subj(condition,:) = nanstd(COND(condition).LAGS.OBJPER)...
        /sqrt(size(COND(condition).LAGS.OBJPER,2)); % SEM
end
xvalues = [.75:.1:1.25;1.75:.1:2.25;2.75:.1:3.25;3.75:.1:4.25];
errorbar(xvalues,MEAN_subj',SEM_subj','o');
hold on
h = line([0 5],[.5 .5]);
set(h, 'LineStyle',':','Color','k')
box off
set(gca,'XTick',1:4,'XTickLabel',{'-1','-3','-5','-7'});
ylim([0.4 1])
xlim([0.25 4.75])
legend('1a: TWU','1b: TWI','2a: TAU','2b: TAI','3a: NAU','3b: NAI')
legend BOXOFF
ylabel('Type-I AUC');
xlabel('Lag Position');
title('Objective Performance comparison across lags');

%%
% NB. Subjects (n=12) shared between:

%% 
% * Experiments 1a & 1b
% * Experiments 2a & 3a
% * Experiments 2b & 3b

%% REPORTABLE STATISTICS
% Here's a summary of values that might be reported in the manuscript and
% some basic significance testing.

