%% QUICK RSVP ANALYSIS

scaling = 16;

% T/W/U
folder = 'Upright_Within-Scene_Target'
files = {'01_AR' '02_JH' '03_EW' '04_ML' '05_JH' '06_HM' '07_AR' '08_TC' '09_JF' '10_VR' '11_AT' '12_AL'};

% [qck_dat.TWU,~] = low_level_comparison(files,folder,scaling);

smp_dat.TWU = simple_comparison(files,folder);

% qck_dat.TWU = horzcat(ones(length(qck_dat.TWU),1)*1,qck_dat.TWU);

% for tr = 1:length(the_data)
%     if strcmp(the_data(tr).subj,'04_ML') && the_data(tr).PD < .09
%         clear this
%         clear that
%         this = the_data(tr).probe; that = the_data(tr).dist;
%     end
% end

% T/W/I
folder = 'Inverse_Within-Scene_Target'
% files = {'01_SC' '02_VR' '03_AR' '04_TC' '05_JF' '06_MU' '07_SI' '08_JH' '09_ML' '10_EW' '11_AR' '12_JH' '13_AT' '14_AL' '15_HM'};
% Remove non-repeat subjects
files = {'02_VR' '03_AR' '04_TC' '05_JF' '08_JH' '09_ML' '10_EW' '11_AR' '12_JH' '13_AT' '14_AL' '15_HM'};

% [qck_dat.TWI,~] = low_level_comparison(files,folder,scaling);

smp_dat.TWI = simple_comparison(files,folder);

% qck_dat.TWI = horzcat(ones(length(qck_dat.TWI),1)*2,qck_dat.TWI);

% T/A/U
folder = 'Upright_Across-Scene_Target'
% files = {'01_AA' '02_NS' '03_KF' '04_TH_dnc' '05_TM' '06_ML' '07_EW' '08_VC' '09_BL' '10_IG' '11_RD' '12_WO' '96_JM'};
files = {'01_AA' '02_NS' '03_KF' '05_TM' '06_ML' '07_EW' '08_VC' '09_BL' '10_IG' '11_RD' '12_WO' '96_JM'};

% [qck_dat.TAU,~] = low_level_comparison(files,folder,scaling);

smp_dat.TAU = simple_comparison(files,folder);

% qck_dat.TAU = horzcat(ones(length(qck_dat.TAU),1)*3,qck_dat.TAU);

% T/A/I
folder = 'Inverse_Across-Scene_Target'
% files = {'01_OW' '02_GP_dnc' '03_MY' '04_AL' '05_JM' '06_NO' '07_JC' '08_TB' '09_YJ' '10_JS' '11_CQ' '12_CM' '13_CK'};
files = {'01_OW' '03_MY' '04_AL' '05_JM' '06_NO' '07_JC' '08_TB' '09_YJ' '10_JS' '11_CQ' '12_CM' '13_CK'};

% [qck_dat.TAI,~] = low_level_comparison(files,folder,scaling);

smp_dat.TAI = simple_comparison(files,folder);

% qck_dat.TAI = horzcat(ones(length(qck_dat.TAI),1)*4,qck_dat.TAI);

% NT/A/U
folder = 'Upright-No-Target'
files = {'01_BL' '02_ML' '03_EW' '04_TM' '05_VC' '06_NS' '07_AA' '08_KF' '09_WO' '10_IG' '11_RD' '99_JM'};

smp_dat.NAU = simple_comparison(files,folder);

% NT/A/I
folder = 'Inverse-No-Target'
files = {'01_AL' '02_MY' '03_OW' '04_TB' '05_NO' '06_JC' '07_YJ' '08_JS' '09_JM' '10_CQ' '11_CM' '12_CK'};

smp_dat.NAI = simple_comparison(files,folder);

% targ_dat = vertcat(qck_dat.TWU,qck_dat.TWI,qck_dat.TAU,qck_dat.TAI);

original_dir = pwd;
cd('/Users/Julian/Desktop/');

save('RSVP-repeated-subj-data.mat','smp_dat');

% xlswrite('RSVP-sim-csv',targ_dat);

cd(original_dir);

%% START LOW LEVEL COMPARISON
% Compare faces rescaled to 16x16 greyscale images
% [qck_dat,~] = low_level_comparison(files,folder,16);

% Create dataset from comparison data
% sim_set = mat2dataset(qck_dat,'VarNames',{'subject' 'correct' 'confidence' 'TP_diff' 'TD_diff' 'PD_diff'});
% 
% mdl = LinearModel.fit(sim_set,'correct ~ 1 + TP_diff + TD_diff + PD_diff');

%% WRITTEN SUMMARY
% TWU: TP & TD diff reaches significance
% TAU: TD_diff reaches significance
