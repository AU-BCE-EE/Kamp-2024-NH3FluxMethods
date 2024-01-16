%% Script to import NH3 data from Picarro analyzer
% JK August 2021
% Wind tunnel and bLS comparison measurements in Foulum August 2021
%
% 2nd measurement

cd '... /'

clear

tic

PLOT_SWITCH = 1; % Plot: 0 = NO, 1 = YES
PLOT_SWITH_COMP = 1;
SAVE_FIG = 0;

% Set your own paths
foldout = '... \Figures';

% Load data
load('DE_DTM.mat')
load('DE_DTM_new.mat')
load('DE_alpha_1.mat')
load('DE_alpha_2.mat')
load('eGylle2_WT.mat')
load('WTbLS_ALFAM2_2&3.mat')
load('WTbLS_TT_bLS_2nd.mat')
load('WTbLS_TT_bLS_Alpha1_2nd.mat')
load('WTbLS_TT_bLS_Alpha2_2nd.mat')
load('WTbLS_TT_CRDS_2nd.mat')
load('WTbLS_Vejr_2nd.mat')


%% ALFAM2 estimates

ALFAM2_2 = ALFAM2emis(ALFAM2emis.field == 'FoulumgårdD',:);


%% Emission estimates and flags

TT_bLS.emis_NH3 = (TT_bLS.NH3 - TT_bLS.NH3_bg) ./ TT_bLS.CE;
TT_bLS.emis_CH4 = (TT_bLS.CH4 - TT_bLS.CH4_bg) ./ TT_bLS.CE;

FLAG_UST005 = TT_bLS.Ustar > 0.05;
FLAG_UST15 = TT_bLS.Ustar > 0.15;

FLAG_L2 = abs(TT_bLS.L) > 2;
FLAG_L10 = abs(TT_bLS.L) > 10;

FLAG_sigU = TT_bLS.sUu < 4.5;
FLAG_sigV = TT_bLS.sVu < 4.5;

FLAG_C0 = TT_bLS.C0 < 10;

FLAG_BUH = and(and(and(and(FLAG_UST005, FLAG_L2),FLAG_sigU), FLAG_sigV),FLAG_C0); % UST > 0.05, L2, sigU < 4.5, sigV < 4.5, C0 < 10 - from Bühler et al., 2021

TT_bLS.emis_NH3_soft = TT_bLS.emis_NH3;
TT_bLS.emis_NH3_hard = TT_bLS.emis_NH3;
TT_bLS.emis_NH3_BUH = TT_bLS.emis_NH3;

TT_bLS.emis_NH3_BUH(~FLAG_BUH) = NaN;

%% Gap filling, Averages and TAN
Time_Lim7 = [datetime(2021,8,20,11,0,0), datetime(2021,8,27,11,0,0)];

TT_bLS.emis_NH3_BUH_gap = fillmissing(TT_bLS.emis_NH3_BUH, 'linear');

disp('Average Flag Bühler and gap filling - 7 days')
disp([nanmean(TT_bLS.emis_NH3_BUH(TT_bLS.Time >= Time_Lim7(1) & TT_bLS.Time < Time_Lim7(2))) nanmean(TT_bLS.emis_NH3_BUH_gap(TT_bLS.Time > Time_Lim7(1) & TT_bLS.Time < Time_Lim7(2)))])

disp('Cumulated rain fall - 7 days')
disp(sum(rmmissing(TT_Vejr.prec(TT_Vejr.Time >= Time_Lim7(1) & TT_Vejr.Time < Time_Lim7(2)))))

disp('Avg temp - 7 days')
disp(nanmean(TT_Vejr.TempAir(TT_Vejr.Time >= Time_Lim7(1) & TT_Vejr.Time < Time_Lim7(2))))

disp('Avg WS - 7 days')
disp(nanmean(TT_bLS.WS(TT_bLS.Time >= Time_Lim7(1) & TT_bLS.Time < Time_Lim7(2))))

disp('Removed data (%)')
disp(100-size(rmmissing(TT_bLS.emis_NH3_BUH))/size(TT_bLS.emis_NH3_BUH)*100)

% Loss of TAN - 7 days after application
% kg ammonium-N pr ton (TAN) = 1.95 g/kg
% 35.9 ton/ha slurry.
TAN_slurry = 35.9*1.95E5 * 17.031 / 14.0067; % Basis for TAN er N mens flux er NH3


TAN_BUH = cumsum(TT_bLS.emis_NH3_BUH(TT_bLS.Time >= Time_Lim7(1) & TT_bLS.Time < Time_Lim7(2))*1800/(TAN_slurry)*100, 'omitnan');
TAN_BUH_gap = cumsum(TT_bLS.emis_NH3_BUH_gap(TT_bLS.Time >= Time_Lim7(1) & TT_bLS.Time < Time_Lim7(2))*1800/(TAN_slurry)*100, 'omitnan');

TT_bLS.TAN = nan(height(TT_bLS),1);
TT_bLS.TAN(TT_bLS.Time >= Time_Lim7(1) & TT_bLS.Time < Time_Lim7(2)) = cumsum(TT_bLS.emis_NH3_BUH_gap(TT_bLS.Time >= Time_Lim7(1) & TT_bLS.Time < Time_Lim7(2))*1800/(TAN_slurry)*100, 'omitnan');

%% Timetables and TAN loss Alpha, DTM, and WT
%% DTM
% DTM (is corrected for slurry coverage)
TT_DTM = table2timetable(DE_DTM);
TT_DTM.Properties.DimensionNames{1}='Time';
TT_DTM.Emis_time(1) = 0;

TT_DTM.Emis_betw = zeros(height(TT_DTM),1);

for o = 2:height(TT_DTM)
    TT_DTM.Emis_betw(o) = (TT_DTM.Emis_cor(o)+TT_DTM.Emis_cor(o-1))/2;
end

TT_DTM.DTM_cum = cumsum(seconds(hours(TT_DTM.expPeriod)) .* TT_DTM.Emis_betw/(TAN_slurry)*100,'omitnan');
TT_DTM.Emis_cor_sd = TT_DTM.Emis_cor.*TT_DTM.EmisRelStd/100;


% New files
TT_DTM_new_1 = table2timetable(DTM_new(DTM_new.plot==1,:), 'RowTimes','timestamp');
TT_DTM_new_2 = table2timetable(DTM_new(DTM_new.plot==2,:), 'RowTimes','timestamp');
TT_DTM_new_3 = table2timetable(DTM_new(DTM_new.plot==3,:), 'RowTimes','timestamp');
TT_DTM_new_1.Properties.DimensionNames{1}='Time';
TT_DTM_new_2.Properties.DimensionNames{1}='Time';
TT_DTM_new_3.Properties.DimensionNames{1}='Time';

%% Alphas
% Alpha bLS estimates


% Alpha concentration and flux
TT_Alpha1 = table2timetable(DE_alpha_1);
TT_Alpha1.Properties.DimensionNames{1}='Time';

TT_Alpha1.Alpha_cum = cumsum(TT_Alpha1.Emis .* seconds(days(TT_Alpha1.ExpPeriod))/(TAN_slurry)*100,'omitnan');

% Compare concentrations from alpha and CRDS
for o=1:height(TT_Alpha1)
    TT_Alpha1.CRDS(o) = mean(TT_bLS.NH3(TT_bLS.Time>TT_Alpha1.Time(o) & TT_bLS.Time<TT_Alpha1.et(o)),'omitnan');
    TT_Alpha1.CRDS_std(o) = std(TT_bLS.NH3(TT_bLS.Time>TT_Alpha1.Time(o) & TT_bLS.Time<TT_Alpha1.et(o)),'omitnan');
    TT_Alpha1.CRDS_BG(o) = mean(TT_bLS.NH3_bg(TT_bLS.Time>TT_Alpha1.Time(o) & TT_bLS.Time<TT_Alpha1.et(o)),'omitnan');
    TT_Alpha1.CRDS_BG_std(o) = std(TT_bLS.NH3_bg(TT_bLS.Time>TT_Alpha1.Time(o) & TT_bLS.Time<TT_Alpha1.et(o)),'omitnan');
    TT_Alpha1.CE_check(o) = mean(TT_bLS_Alpha1.CE(TT_bLS_Alpha1.Time>TT_Alpha1.Time(o) & TT_bLS_Alpha1.Time<TT_Alpha1.et(o)),'omitnan');

    TT_Alpha1.CRDS_emis(o) = mean(TT_bLS.emis_NH3_BUH(TT_bLS.Time>TT_Alpha1.Time(o) & TT_bLS.Time<TT_Alpha1.et(o)),'omitnan');
end
TT_Alpha1.EmisNH3_check = (TT_Alpha1.NH3Conc-TT_Alpha1.NH3ConcBG)./TT_Alpha1.CE_check; % Hannah averaged the CE values for the periods needed to match the exposure time for Alpha-samplers.
TT_Alpha1.CRDS_emis_cum = cumsum((TT_Alpha1.CRDS_emis .* seconds(TT_Alpha1.et - TT_Alpha1.Time)/TAN_slurry)*100, 'omitnan');

% TAN_alpha_1 = cumsum((DE_alpha_1.Emis .* seconds(DE_alpha_1.et-DE_alpha_1.st)) / (TAN_slurry)*100, 'omitnan');

% Alpha bLS estimates

% Alpha concentration and flux
TT_Alpha2 = table2timetable(DE_alpha_2);
TT_Alpha2.Properties.DimensionNames{1}='Time';

TT_Alpha2.Alpha_cum = cumsum(TT_Alpha2.Emis .* seconds(days(TT_Alpha2.ExpPeriod))/(TAN_slurry)*100,'omitnan');

% Compare concentrations from alpha and CRDS
for o=1:height(TT_Alpha2)
    TT_Alpha2.CRDS(o) = mean(TT_bLS.NH3(TT_bLS.Time>TT_Alpha2.Time(o) & TT_bLS.Time<TT_Alpha2.et(o)),'omitnan');
    TT_Alpha2.CRDS_std(o) = std(TT_bLS.NH3(TT_bLS.Time>TT_Alpha2.Time(o) & TT_bLS.Time<TT_Alpha2.et(o)),'omitnan');
    TT_Alpha2.CRDS_BG(o) = mean(TT_bLS.NH3_bg(TT_bLS.Time>TT_Alpha2.Time(o) & TT_bLS.Time<TT_Alpha2.et(o)),'omitnan');
    TT_Alpha2.CRDS_BG_std(o) = std(TT_bLS.NH3_bg(TT_bLS.Time>TT_Alpha2.Time(o) & TT_bLS.Time<TT_Alpha2.et(o)),'omitnan');
    TT_Alpha2.CE_check(o) = mean(TT_bLS_Alpha2.CE(TT_bLS_Alpha2.Time>TT_Alpha2.Time(o) & TT_bLS_Alpha2.Time<TT_Alpha2.et(o)),'omitnan');

    TT_Alpha2.CRDS_emis(o) = mean(TT_bLS.emis_NH3_BUH(TT_bLS.Time>TT_Alpha2.Time(o) & TT_bLS.Time<TT_Alpha2.et(o)),'omitnan');
end
TT_Alpha2.EmisNH3_check = (TT_Alpha2.NH3Conc-TT_Alpha2.NH3ConcBG)./TT_Alpha2.CE_check; % Hannah averaged the CE values for the periods needed to match the exposure time for Alpha-samplers.
TT_Alpha2.CRDS_emis_cum = cumsum((TT_Alpha2.CRDS_emis .* seconds(TT_Alpha2.et - TT_Alpha2.Time)/TAN_slurry)*100, 'omitnan');

%% WT
TT_WT7 = table2timetable(WT(WT.treat==7,:));
TT_WT25 = table2timetable(WT(WT.treat==25,:)); % Focus on AER=25
TT_WT54 = table2timetable(WT(WT.treat==54,:));

TT_WT7.T_dif = zeros(height(TT_WT7),1);
TT_WT25.T_dif = zeros(height(TT_WT25),1);
TT_WT54.T_dif = zeros(height(TT_WT54),1);

TT_WT7.C_dif = zeros(height(TT_WT7),1);
TT_WT25.C_dif = zeros(height(TT_WT25),1);
TT_WT54.C_dif = zeros(height(TT_WT54),1);

for o = 2:height(TT_WT25)
    TT_WT25.T_dif(o) = hours(datetime(TT_WT25.Time(o))-datetime(TT_WT25.Time(o-1)));
    TT_WT25.C_dif(o) = (TT_WT25.flux(o)+TT_WT25.flux(o-1))/2;
end

for o = 2:height(TT_WT7)
    TT_WT7.T_dif(o) = hours(datetime(TT_WT7.Time(o))-datetime(TT_WT7.Time(o-1)));
    TT_WT7.C_dif(o) = (TT_WT7.flux(o)+TT_WT7.flux(o-1))/2;
end

for o = 2:height(TT_WT54)
    TT_WT54.T_dif(o) = hours(datetime(TT_WT54.Time(o))-datetime(TT_WT54.Time(o-1)));
    TT_WT54.C_dif(o) = (TT_WT54.flux(o)+TT_WT54.flux(o-1))/2;
end

TT_WT7.WT_cum = cumsum(TT_WT7.C_dif .* TT_WT7.T_dif *seconds(hours(1))/(TAN_slurry)*100,'omitnan');
TT_WT25.WT_cum = cumsum(TT_WT25.C_dif .* TT_WT25.T_dif *seconds(hours(1))/(TAN_slurry)*100,'omitnan');
TT_WT54.WT_cum = cumsum(TT_WT54.C_dif .* TT_WT54.T_dif *seconds(hours(1))/(TAN_slurry)*100,'omitnan');



%% TAN loss
% OBS: Limited to 7 days after application for gap

disp('TAN loss: BUH,    BUH gap')
disp([TAN_BUH(end) TAN_BUH_gap(end)])

disp('TAN loss: bLS')
disp([TAN_BUH_gap(end)])

disp('TAN loss: Alpha_1, Alpha_2')
disp([TT_Alpha1.Alpha_cum(end) TT_Alpha2.Alpha_cum(end)])

disp('TAN loss: DTM')
disp([TT_DTM.DTM_cum(end)])

disp('TAN loss: WT')
disp([TT_WT25.WT_cum(end)])

ii = 2;
%% Plots

if PLOT_SWITCH == 1
    TimeLim = [datetime('2021-08-20 08:00:00'), datetime('2021-08-27 07:30:00')];
    ii = 50;

    SizeOfFont = 11;
    SizeOfFontLgd = 10;

    fig51=figure(ii); % FIGURE 4
    subplot(3,1,1)
    bar(TT_Vejr.Time, TT_Vejr.prec);
    ylabel({'Precipitation', '(mm hr^{-1})'},'FontSize',SizeOfFont, 'color','k')
    % legend({'Precipitation'}, 'FontSize',SizeOfFontLgd)
    grid minor
    xlim(TimeLim)
    ylim([0 0.9])

    subplot(3,1,2)
    plot(TT_bLS.Time, TT_bLS.WS)
    ylabel({'Wind speed', '(m s^{-1})'},'FontSize',SizeOfFont, 'color','k')
    % legend({'Wind speed'}, 'FontSize',SizeOfFontLgd)
    grid minor
    xlim(TimeLim)
    ylim([0 6.9])

    subplot(3,1,3)
    plot(TT_Vejr.Time, TT_Vejr.TempAir, TT_Vejr.Time, TT_Vejr.Temp10cm)
    grid minor
    ylabel({'Temperature', '(^oC)'},'FontSize',SizeOfFont, 'color','k')
    legend({'Air', 'Soil'}, 'FontSize',SizeOfFontLgd)
    xlim(TimeLim)
    ylim([7 22.9])

    samexaxis('join','abc','xmt','on','yld',1,'YLabelDistance',1.0,'XLim',TimeLim)

    ii = ii + 1;


    if SAVE_FIG == 1
        FigFileName = '2nd_Atmos 3 panel';
        fullFileName = fullfile(foldout, FigFileName);
        fig51 = gcf;
        fig51.PaperUnits = 'centimeters';
        fig51.PaperPosition = [0 0 19 10];
        print(fullFileName,'-dpng','-r800')
    end



end

if PLOT_SWITH_COMP == 1
    ii = 1;
    
    % --------------------------------------------------- %
    % Error band on WT:
    opts = spreadsheetImportOptions("NumVariables", 5);
    opts.Sheet = "AER7";
    opts.DataRange = "E2:I256";
    opts.VariableNames = ["Time", "flux", "fluxsd", "ConfP", "ConfM"];
    opts.VariableTypes = ["datetime", "double", "double", "double", "double"];
    opts = setvaropts(opts, "Time", "InputFormat", "");
    WTplot_AER7 = readtable("... \WT_plot.xlsx", opts, "UseExcel", false);

    opts.Sheet = "AER25";
    WTplot_AER25 = readtable("... \WT_plot.xlsx", opts, "UseExcel", false);

    opts.Sheet = "AER54";
    WTplot_AER54 = readtable("... \WT_plot.xlsx", opts, "UseExcel", false);

    clear opts

    xconf_WT_7 = [WTplot_AER7.Time; WTplot_AER7.Time(end:-1:1)];
    yconf_WT_7 = [WTplot_AER7.ConfP; WTplot_AER7.ConfM(end:-1:1)];

    xconf_WT_25 = [WTplot_AER25.Time; WTplot_AER25.Time(end:-1:1)];
    yconf_WT_25 = [WTplot_AER25.ConfP; WTplot_AER25.ConfM(end:-1:1)];

    xconf_WT_54 = [WTplot_AER54.Time; WTplot_AER54.Time(end:-1:1)];
    yconf_WT_54 = [WTplot_AER54.ConfP; WTplot_AER54.ConfM(end:-1:1)];
    % --------------------------------------------------- %
    % Error band on ALPHA:
    opts = spreadsheetImportOptions("NumVariables", 5);
    opts.Sheet = "Sheet1";
    opts.DataRange = "E2:I36";
    opts.VariableNames = ["Time", "flux", "fluxsd", "ConfP", "ConfM"];
    opts.VariableTypes = ["datetime", "double", "double", "double", "double"];
    opts = setvaropts(opts, "Time", "InputFormat", "");
    ALPHAplot = readtable("... \ALPHA_plot.xlsx", opts, "UseExcel", false);

    clear opts

    xconf_ALPHA = [ALPHAplot.Time; ALPHAplot.Time(end:-1:1)];
    yconf_ALPHA = [ALPHAplot.ConfP; ALPHAplot.ConfM(end:-1:1)];

    % --------------------------------------------------- %

    fig58=figure(ii); % FIGURE 6
%     h10 = stairs(ALFAM2_2.tstart, ALFAM2_2.fluxpred2, 'LineWidth', 1, 'Marker', 'diamond','color',rgb('dark yellow'));
%     hold on
    h1 = stairs(TT_bLS.Time(FLAG_BUH), TT_bLS.emis_NH3(FLAG_BUH), 'LineWidth', 1, 'Marker', 'x','color',rgb('red'));
    hold on
    h2 = errorbar(TT_DTM.Time, TT_DTM.Emis_cor, TT_DTM.Emis_cor_sd, TT_DTM.Emis_cor_sd, 's-','color',rgb('light purple'));
    hold on
    p = fill(xconf_WT_7, yconf_WT_7, 'red');
    p.FaceColor = rgb('dark blue');
    p.FaceAlpha = 0.15;
    p.EdgeColor = 'none';
    hold on
    h5 = stairs(TT_WT7.Time, TT_WT7.flux, 'LineWidth', 1, 'Marker', 'o', 'color', rgb('light blue'));
    hold on
    p = fill(xconf_WT_25, yconf_WT_25, 'red');
    p.FaceColor = rgb('blue');
    p.FaceAlpha = 0.15;
    p.EdgeColor = 'none';
    hold on
    h6 = stairs(TT_WT25.Time, TT_WT25.flux, 'LineWidth', 1, 'Marker', 'o','color',rgb('blue'));
    hold on
    p = fill(xconf_WT_54, yconf_WT_54, 'red');
    p.FaceColor = rgb('light blue');
    p.FaceAlpha = 0.3;
    p.EdgeColor = 'none';
    hold on
    h7 = stairs(TT_WT54.Time, TT_WT54.flux, 'LineWidth', 1, 'Marker', 'o','color',rgb('dark blue'));
    hold on
    h9 = stairs(TT_Alpha1.Time, mean([TT_Alpha1.Emis, TT_Alpha2.Emis],2), 'LineWidth', 1, 'Marker', '*', 'color',rgb('dark red'));
    hold on
    p = fill(xconf_ALPHA, yconf_ALPHA, 'red');
    p.FaceColor = rgb('red');
    p.FaceAlpha = 0.15;
    p.EdgeColor = 'none';
    legend([h1 h5 h6 h7 h2 h9],'bLS-CRDS', 'WT (AER 7)', 'WT (AER 25)', 'WT (AER 54)', 'DTM', 'bLS-ALPHA');
%     legend([h1 h5 h6 h7 h2 h9 h10],'bLS-CRDS', 'WT (AER 7)', 'WT (AER 25)', 'WT (AER 54)', 'DTM', 'bLS-ALPHA', 'ALFAM2');
    ylabel('NH_3 flux (\mug m^{-2} s^{-1})')
    ylim([0 210])
    xlim([datetime(2021,08,20,10,55,0), datetime(2021,08,22,10,30,0)])
    grid minor
    ii = ii + 1;

    if SAVE_FIG == 1
        FigFileName = 'Flux eGylle2 fig errorbar';
        fullFileName = fullfile(foldout, FigFileName);
        fig58 = gcf;
        fig58.PaperUnits = 'centimeters';
        fig58.PaperPosition = [0 0 18 12];
        print(fullFileName,'-dpng','-r800')
    end


    TT_WT7.cum_sd = TT_WT7.cumemissd / TT_WT7.cumemismn * TT_WT7.WT_cum;
    TT_WT25.cum_sd = TT_WT25.cumemissd / TT_WT25.cumemismn * TT_WT25.WT_cum;
    TT_WT54.cum_sd = TT_WT54.cumemissd / TT_WT54.cumemismn * TT_WT54.WT_cum;

    TAN_bLS = table([datetime('2021-08-20 10:59:00'); TT_bLS.Time(TT_bLS.Time >= Time_Lim7(1) & TT_bLS.Time < Time_Lim7(2))], [0; TAN_BUH_gap], 'VariableNames',{'Time', 'TAN'});
    TAN_DTM = table([datetime('2021-08-20 10:59:00'); TT_DTM.Time], [0;TT_DTM.DTM_cum], 'VariableNames',{'Time', 'TAN'});
    TAN_DTM_1 = table([datetime('2021-08-20 10:59:00'); TT_DTM_new_1.Time], [0;TT_DTM_new_1.DTM_cum], 'VariableNames',{'Time', 'TAN'});
    TAN_DTM_2 = table([datetime('2021-08-20 10:59:00'); TT_DTM_new_2.Time], [0;TT_DTM_new_2.DTM_cum], 'VariableNames',{'Time', 'TAN'});
    TAN_DTM_3 = table([datetime('2021-08-20 10:59:00'); TT_DTM_new_3.Time], [0;TT_DTM_new_3.DTM_cum], 'VariableNames',{'Time', 'TAN'});
    TAN_Alpha1 = table([datetime('2021-08-20 10:59:00'); TT_Alpha1.Time], [0;TT_Alpha1.Alpha_cum], 'VariableNames',{'Time', 'TAN'});
    TAN_Alpha2 = table([datetime('2021-08-20 10:59:00'); TT_Alpha2.Time], [0;TT_Alpha2.Alpha_cum], 'VariableNames',{'Time', 'TAN'});
    TAN_WT_7 = table([datetime('2021-08-20 10:59:00'); TT_WT7.Time], [0;TT_WT7.WT_cum], [0; TT_WT7.cum_sd], 'VariableNames',{'Time', 'TAN', 'sd'});
    TAN_WT_25 = table([datetime('2021-08-20 10:59:00'); TT_WT25.Time], [0;TT_WT25.WT_cum], [0; TT_WT25.cum_sd], 'VariableNames',{'Time', 'TAN', 'sd'});
    TAN_WT_54 = table([datetime('2021-08-20 10:59:00'); TT_WT54.Time], [0;TT_WT54.WT_cum], [0; TT_WT54.cum_sd], 'VariableNames',{'Time', 'TAN', 'sd'});
    
    TAN_DTM_w_sd = table(TAN_DTM_2.Time(1:37), TAN_DTM_1.TAN(1:37), TAN_DTM_2.TAN(1:37), TAN_DTM_3.TAN(1:37), 'VariableNames',{'Time', 'DTM1', 'DTM2', 'DTM3'});
    TAN_DTM_w_sd.cum_avg = mean([TAN_DTM_w_sd.DTM1, TAN_DTM_w_sd.DTM2, TAN_DTM_w_sd.DTM3],2);
    TAN_DTM_w_sd.cum_std = std([TAN_DTM_w_sd.DTM1, TAN_DTM_w_sd.DTM2, TAN_DTM_w_sd.DTM3],0,2);

    TAN_ALPHA_w_sd = table(TAN_Alpha1.Time, TAN_Alpha1.TAN, TAN_Alpha2.TAN, 'VariableNames',{'Time', 'ALPHA1', 'ALPHA2'});
    TAN_ALPHA_w_sd.cum_avg = mean([TAN_ALPHA_w_sd.ALPHA1, TAN_ALPHA_w_sd.ALPHA2],2);
    TAN_ALPHA_w_sd.cum_std = std([TAN_ALPHA_w_sd.ALPHA1, TAN_ALPHA_w_sd.ALPHA2],0,2);


    fig59=figure(ii); % FIGURE 7
    plot(TAN_bLS.Time, TAN_bLS.TAN, 'x-','color',rgb('red'))
    hold on
    errorbar(TAN_WT_7.Time, TAN_WT_7.TAN, TAN_WT_7.sd, TAN_WT_7.sd,  'o-','color',rgb('light blue'))
    hold on
    errorbar(TAN_WT_25.Time, TAN_WT_25.TAN, TAN_WT_25.sd, TAN_WT_25.sd, 'o-','color',rgb('blue'))
    hold on
    errorbar(TAN_WT_54.Time, TAN_WT_54.TAN, TAN_WT_54.sd, TAN_WT_54.sd, 'o-','color',rgb('dark blue'))
    hold on
    errorbar(TAN_DTM_w_sd.Time, TAN_DTM_w_sd.cum_avg, TAN_DTM_w_sd.cum_std, TAN_DTM_w_sd.cum_std, 's-','color',rgb('light purple'))
    hold on
    errorbar(TAN_ALPHA_w_sd.Time, TAN_ALPHA_w_sd.cum_avg, TAN_ALPHA_w_sd.cum_std, TAN_ALPHA_w_sd.cum_std, '*-','color',rgb('dark red'))
%     hold on
%     plot(ALFAM2_2.tstart, ALFAM2_2.erelpred2 * 100, 'diamond-', 'color',rgb('dark yellow'))
    grid minor
    lgd = legend({'bLS-CRDS', 'WT (AER 7)', 'WT (AER 25)', 'WT (AER 54)', 'DTM','bLS-ALPHA'}, 'NumColumns', 4, 'Location','northoutside'); % , 'ALFAM2'
    xlim([datetime(2021,08,20,10,30,0), datetime(2021,08,27,11,00,0)])
    ylabel('Loss of TAN (% of applied)')%, 'FontSize', 12)
    ii = ii + 1;

    if SAVE_FIG == 1
        FigFileName = 'TAN_loss eGylle2 fig errorbar';
        fullFileName = fullfile(foldout, FigFileName);
        fig59 = gcf;
        fig59.PaperUnits = 'centimeters';
        fig59.PaperPosition = [0 0 18 16];
        print(fullFileName,'-dpng','-r800')
    end


    % Plots of concentration with CRDS and alphas

    x_stairs_2 = [TT_Alpha1.Time; {'2021-08-30 09:10:00'}];
    y_stairs_2 = [[TT_Alpha1.NH3Conc; NaN]]; % NaN added to make the last line have a duration

    x_stairs_3 = [TT_Alpha2.Time; {'2021-08-30 09:10:00'}];
    y_stairs_3 = [[TT_Alpha2.NH3Conc; NaN]]; % NaN added to make the last line have a duration

    x_stairs_4 = [TT_Alpha2.Time; {'2021-08-30 09:10:00'}];
    y_stairs_4 = [[TT_Alpha1.CRDS; NaN]]; % NaN added to make the last line have a duration

    fig63=figure(ii); % FIGURE S5
    stairs(x_stairs_2, y_stairs_2,'LineWidth',1,'color',rgb('light red'))
    hold on
    stairs(x_stairs_3, y_stairs_3,'LineWidth',1,'color',rgb('red'))
    hold on
    stairs(x_stairs_4, y_stairs_4,'LineWidth',1,'color',rgb('dark blue'))
    hold on
    plot(TT_bLS.Time, TT_bLS.NH3, '.:','color',rgb('blue'))
    legend('ALPHA1', 'ALPHA2', 'CRDS avg', 'CRDS')
    grid minor
    ylabel('NH_3 (\mug NH_3 m^{-3})')
    xlabel('Time')
    xlim([datetime(2021,08,20,11,0,0), datetime(2021,08,30,9,30,0)])
    ii = ii + 1;

    if SAVE_FIG == 1
        FigFileName = 'Conc Alpha and CRDS';
        fullFileName = fullfile(foldout, FigFileName);
        fig63 = gcf;
        fig63.PaperUnits = 'centimeters';
        fig63.PaperPosition = [0 0 18 12];
        print(fullFileName,'-dpng','-r800')
    end

    x_stairs_5 = [TT_Alpha2.Time; {'2021-08-30 09:10:00'}];
    y_stairs_5 = [[TT_Alpha2.NH3ConcBG; NaN]]; % NaN added to make the last line have a duration

    x_stairs_6 = [TT_Alpha2.Time; {'2021-08-30 09:10:00'}];
    y_stairs_6 = [[TT_Alpha1.CRDS_BG; NaN]]; % NaN added to make the last line have a duration

    fig64=figure(ii); % FIGURE S6
    stairs(x_stairs_5, y_stairs_5,'LineWidth',1,'color',rgb('red'))
    hold on
    stairs(x_stairs_6, y_stairs_6,'LineWidth',1,'color',rgb('dark blue'))
    hold on
    plot(TT_bLS.Time, TT_bLS.NH3_bg, '.:','color',rgb('blue'))
    legend('ALPHA', 'CRDS avg', 'CRDS')
    grid minor
    ylabel('NH_3 (\mug NH_3 m^{-3})')
    xlabel('Time')
    xlim([datetime(2021,08,20,11,0,0), datetime(2021,08,30,9,30,0)])
    ii = ii + 1;

    if SAVE_FIG == 1
        FigFileName = 'Conc Alpha and CRDS background';
        fullFileName = fullfile(foldout, FigFileName);
        fig64 = gcf;
        fig64.PaperUnits = 'centimeters';
        fig64.PaperPosition = [0 0 18 12];
        print(fullFileName,'-dpng','-r800')
    end
    
    %% Deming regression and pairs plot
    % https://se.mathworks.com/matlabcentral/answers/477956-how-to-remove-labels-and-grey-space-between-subplots-so-that-the-subplots-fill-up-the-entire-figure

    [deming1, sigma, x_est, y_est, stats_deming1] = deming(TT_Alpha2.Emis, TT_Alpha1.Emis); % b positive
    [deming2, sigma, x_est, y_est, stats_deming2] = deming(TT_Alpha1.CRDS_emis, TT_Alpha1.Emis); % b negative
    [deming3, sigma, x_est, y_est, stats_deming3] = deming(TT_Alpha1.Emis, TT_Alpha2.Emis); % b negative
    [deming4, sigma, x_est, y_est, stats_deming4] = deming(TT_Alpha1.CRDS_emis, TT_Alpha2.Emis); % b negative
    [deming5, sigma, x_est, y_est, stats_deming5] = deming(TT_Alpha1.Emis, TT_Alpha1.CRDS_emis); % b positive
    [deming6, sigma, x_est, y_est, stats_deming6] = deming(TT_Alpha2.Emis, TT_Alpha1.CRDS_emis); % b positive

    % stats.s_e: Standard error of regression estimate

    edges = [-5:5:80];
    xylim = ([0 85]);

    fig65=figure(ii); % Figure S3, S4
    tiledlayout(3,3, 'TileSpacing', 'compact');

    nexttile % 1
    histogram(TT_Alpha1.Emis,edges)
    grid minor
    tickCell = {'XTickLabel',{}};
    set(gca,tickCell{:});
    ylabel('bLS-ALPHA1')

    nexttile % 2
    plot(TT_Alpha2.Emis, TT_Alpha1.Emis, 'o')
    grid minor
    tickCell = {'XTickLabel',{},'YTickLabel',{}};
    set(gca,tickCell{:});
    refline(deming1(2), deming1(1))
    ax = refline(1,0);
    ax.Color = 'Red';
    xlim(xylim)
    ylim(xylim)
    txt = ['y = ' num2str(deming1(2),'%.3f') 'x + ' num2str(abs(deming1(1)),'%.3f')];
    text(0.01*xylim(2),0.99*xylim(2),txt,'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')

    nexttile % 3
    plot(TT_Alpha2.CRDS_emis, TT_Alpha1.Emis, 'o')
    grid minor
    tickCell = {'XTickLabel',{},'YTickLabel',{}};
    set(gca,tickCell{:});
    refline(deming2(2), deming2(1))
    ax = refline(1,0);
    ax.Color = 'Red';
    xlim(xylim)
    ylim(xylim)
    txt = ['y = ' num2str(deming2(2),'%.3f') 'x - ' num2str(abs(deming2(1)),'%.3f')];
    text(0.01*xylim(2),0.99*xylim(2),txt,'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')

    nexttile % 4
    plot(TT_Alpha1.Emis, TT_Alpha2.Emis, 'o')
    grid minor
    tickCell = {'XTickLabel',{}};
    set(gca,tickCell{:});
    
    ylabel('bLS-ALPHA2')
    refline(deming3(2), deming3(1))
    ax = refline(1,0);
    ax.Color = 'Red';
    xlim(xylim)
    ylim(xylim)
    txt = ['y = ' num2str(deming3(2),'%.3f') 'x - ' num2str(abs(deming3(1)),'%.3f')];
    text(0.01*xylim(2),0.99*xylim(2),txt,'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')

    nexttile % 5
    histogram(TT_Alpha2.Emis,edges)
    grid minor
    tickCell = {'XTickLabel',{},'YTickLabel',{}};
    set(gca,tickCell{:});

    nexttile % 6
    plot(TT_Alpha2.CRDS_emis, TT_Alpha2.Emis, 'o')
    grid minor
    tickCell = {'XTickLabel',{},'YTickLabel',{}};
    set(gca,tickCell{:});
    refline(deming4(2), deming4(1))
    ax = refline(1,0);
    ax.Color = 'Red';
    xlim(xylim)
    ylim(xylim)
    txt = ['y = ' num2str(deming4(2),'%.3f') 'x - ' num2str(abs(deming4(1)),'%.3f')];
    text(0.01*xylim(2),0.99*xylim(2),txt,'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')

    nexttile % 7
    plot(TT_Alpha1.Emis, TT_Alpha2.CRDS_emis, 'o')
    grid minor
    xlabel('bLS-ALPHA1')
    ylabel('bLS-CRDS')
    refline(deming5(2), deming5(1))
    ax = refline(1,0);
    ax.Color = 'Red';
    xlim(xylim)
    ylim(xylim)
    txt = ['y = ' num2str(deming5(2),'%.3f') 'x + ' num2str(abs(deming5(1)),'%.3f')];
    text(0.01*xylim(2),0.99*xylim(2),txt,'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')

    nexttile % 8
    plot(TT_Alpha2.Emis, TT_Alpha2.CRDS_emis, 'o')
    grid minor
    tickCell = {'YTickLabel',{}};
    set(gca,tickCell{:});
    xlabel('bLS-ALPHA2')
    refline(deming6(2), deming6(1))
    ax = refline(1,0);
    ax.Color = 'Red';
    xlim(xylim)
    ylim(xylim)
    txt = ['y = ' num2str(deming6(2),'%.3f') 'x + ' num2str(abs(deming6(1)),'%.3f')];
    text(0.01*xylim(2),0.99*xylim(2),txt,'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')

    nexttile % 9
    histogram(TT_Alpha2.CRDS_emis, edges)
    grid minor
    tickCell = {'YTickLabel',{}};
    set(gca,tickCell{:});
    xlabel('bLS-CRDS')
    ii = ii + 1;


    if SAVE_FIG == 1
        FigFileName = 'Flux cross plot deming';
        fullFileName = fullfile(foldout, FigFileName);
        fig65 = gcf;
        fig65.PaperUnits = 'centimeters';
        fig65.PaperPosition = [0 0 18 12];
        print(fullFileName,'-dpng','-r800')
    end


%% Remove first high point
    [deming1, sigma, x_est, y_est, stats_deming1] = deming(TT_Alpha2.Emis(2:end), TT_Alpha1.Emis(2:end)); % b negative
    [deming2, sigma, x_est, y_est, stats_deming2] = deming(TT_Alpha1.CRDS_emis(2:end), TT_Alpha1.Emis(2:end)); % b negative
    [deming3, sigma, x_est, y_est, stats_deming3] = deming(TT_Alpha1.Emis(2:end), TT_Alpha2.Emis(2:end)); % b positive
    [deming4, sigma, x_est, y_est, stats_deming4] = deming(TT_Alpha1.CRDS_emis(2:end), TT_Alpha2.Emis(2:end)); % b negative
    [deming5, sigma, x_est, y_est, stats_deming5] = deming(TT_Alpha1.Emis(2:end), TT_Alpha1.CRDS_emis(2:end)); % b positive
    [deming6, sigma, x_est, y_est, stats_deming6] = deming(TT_Alpha2.Emis(2:end), TT_Alpha1.CRDS_emis(2:end)); % b positive

    % stats.s_e: Standard error of regression estimate

    edges = [-2:1:10];
    xylim = ([0 10]);

    fig65=figure(ii); % Figure 8
    tiledlayout(3,3, 'TileSpacing', 'compact');

    nexttile % 1
    histogram(TT_Alpha1.Emis,edges)
    grid minor
    tickCell = {'XTickLabel',{}};
    set(gca,tickCell{:});
    ylabel('bLS-ALPHA1')

    nexttile % 2
    plot(TT_Alpha2.Emis, TT_Alpha1.Emis, 'o')
    grid minor
    tickCell = {'XTickLabel',{},'YTickLabel',{}};
    set(gca,tickCell{:});
    refline(deming1(2), deming1(1))
    ax = refline(1,0);
    ax.Color = 'Red';
    xlim(xylim)
    ylim(xylim)
    txt = ['y = ' num2str(deming1(2),'%.3f') 'x - ' num2str(abs(deming1(1)),'%.3f')];
    text(0.01*xylim(2),0.99*xylim(2),txt,'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')

    nexttile % 3
    plot(TT_Alpha2.CRDS_emis, TT_Alpha1.Emis, 'o')
    grid minor
    tickCell = {'XTickLabel',{},'YTickLabel',{}};
    set(gca,tickCell{:});
    refline(deming2(2), deming2(1))
    ax = refline(1,0);
    ax.Color = 'Red';
    xlim(xylim)
    ylim(xylim)
    txt = ['y = ' num2str(deming2(2),'%.3f') 'x - ' num2str(abs(deming2(1)),'%.3f')];
    text(0.01*xylim(2),0.99*xylim(2),txt,'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')

    nexttile % 4
    plot(TT_Alpha1.Emis, TT_Alpha2.Emis, 'o')
    grid minor
    tickCell = {'XTickLabel',{}};
    set(gca,tickCell{:});
    
    ylabel('bLS-ALPHA2')
    refline(deming3(2), deming3(1))
    ax = refline(1,0);
    ax.Color = 'Red';
    xlim(xylim)
    ylim(xylim)
    txt = ['y = ' num2str(deming3(2),'%.3f') 'x + ' num2str(abs(deming3(1)),'%.3f')];
    text(0.01*xylim(2),0.99*xylim(2),txt,'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')

    nexttile % 5
    histogram(TT_Alpha2.Emis,edges)
    grid minor
    tickCell = {'XTickLabel',{},'YTickLabel',{}};
    set(gca,tickCell{:});

    nexttile % 6
    plot(TT_Alpha2.CRDS_emis, TT_Alpha2.Emis, 'o')
    grid minor
    tickCell = {'XTickLabel',{},'YTickLabel',{}};
    set(gca,tickCell{:});
    refline(deming4(2), deming4(1))
    ax = refline(1,0);
    ax.Color = 'Red';
    xlim(xylim)
    ylim(xylim)
    txt = ['y = ' num2str(deming4(2),'%.3f') 'x - ' num2str(abs(deming4(1)),'%.3f')];
    text(0.01*xylim(2),0.99*xylim(2),txt,'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')

    nexttile % 7
    plot(TT_Alpha1.Emis, TT_Alpha2.CRDS_emis, 'o')
    grid minor
    xlabel('bLS-ALPHA1')
    ylabel('bLS-CRDS')
    refline(deming5(2), deming5(1))
    ax = refline(1,0);
    ax.Color = 'Red';
    xlim(xylim)
    ylim(xylim)
    txt = ['y = ' num2str(deming5(2),'%.3f') 'x + ' num2str(abs(deming5(1)),'%.3f')];
    text(0.01*xylim(2),0.99*xylim(2),txt,'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')

    nexttile % 8
    plot(TT_Alpha2.Emis, TT_Alpha2.CRDS_emis, 'o')
    grid minor
    tickCell = {'YTickLabel',{}};
    set(gca,tickCell{:});
    xlabel('bLS-ALPHA2')
    refline(deming6(2), deming6(1))
    ax = refline(1,0);
    ax.Color = 'Red';
    xlim(xylim)
    ylim(xylim)
    txt = ['y = ' num2str(deming6(2),'%.3f') 'x + ' num2str(abs(deming6(1)),'%.3f')];
    text(0.01*xylim(2),0.99*xylim(2),txt,'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')

    nexttile % 9
    histogram(TT_Alpha2.CRDS_emis, edges)
    grid minor
    tickCell = {'YTickLabel',{}};
    set(gca,tickCell{:});
    xlabel('bLS-CRDS')
    ii = ii + 1;

    if SAVE_FIG == 1
        FigFileName = 'Flux cross plot deming short';
        fullFileName = fullfile(foldout, FigFileName);
        fig65 = gcf;
        fig65.PaperUnits = 'centimeters';
        fig65.PaperPosition = [0 0 18 12];
        print(fullFileName,'-dpng','-r800')
    end

    
end


toc