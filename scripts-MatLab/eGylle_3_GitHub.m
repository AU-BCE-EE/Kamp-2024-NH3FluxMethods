%% Script to import NH3 data from Picarro analyzer
% JK November 2021
% Wind tunnel and bLS comparison measurements in WUR November 2021
%
% 3rd measurement in NL

cd '... /'

% CRDS #1: Background (G2103)
% CRDS #2: Plot (G2103)

clear

tic

PLOT_SWITCH = 1; % Plot: 0 = NO, 1 = YES
PLOT_SWITH_COMP = 1;
SAVE_FIG = 0;

foldout = '... \Figures';

load('eGylle3_WT.mat')
load('IHF_emis_3rd.mat')
load('IHF_conc_3rd.mat')
load('IHF_bLS.mat')
load('TT_Buckets.mat')
load('WTbLS_ALFAM2_2&3.mat')
load('WTbLS_TT_CRDS_3rd.mat')
load('WTbLS_TT_rain_3rd.mat')
load('WTbLS_TT_bLS_3rd.mat')

%% ALFAM2 estimates
ALFAM2_3 = ALFAM2emis(ALFAM2emis.field == 'WUR',:);


%% IHF Comparison
TT_IHF = table2timetable(IHF_conc);
TT_IHF.Properties.DimensionNames{1}='Time';

TT_IHF.z_sonic = ones(height(TT_IHF),1)*2;
TT_IHF.ShiftTime = IHF_emis.ShiftTime;

% Compare concentrations from IHF and CRDS - create average variables for bLS calculations in R
for o=1:height(TT_IHF)
    TT_IHF.CRDS(o) = mean(TT_bLS.NH3(TT_bLS.Time>TT_IHF.Time(o) & TT_bLS.Time<TT_IHF.et(o)), "omitnan");
    TT_IHF.CRDS_std(o) = std(TT_bLS.NH3(TT_bLS.Time>TT_IHF.Time(o) & TT_bLS.Time<TT_IHF.et(o)), "omitnan");
    TT_IHF.CRDS_BG(o) = mean(TT_bLS.NH3_bg(TT_bLS.Time>TT_IHF.Time(o) & TT_bLS.Time<TT_IHF.et(o)), "omitnan");
    TT_IHF.CRDS_BG_std(o) = std(TT_bLS.NH3_bg(TT_bLS.Time>TT_IHF.Time(o) & TT_bLS.Time<TT_IHF.et(o)), "omitnan");
    TT_IHF.UST(o) = mean(TT_bLS.Ustar(TT_bLS.Time>TT_IHF.Time(o) & TT_bLS.Time<TT_IHF.et(o)), "omitnan");
    TT_IHF.L(o) = mean(TT_bLS.L(TT_bLS.Time>TT_IHF.Time(o) & TT_bLS.Time<TT_IHF.et(o)), "omitnan");
    TT_IHF.z0(o) = mean(TT_bLS.Zo(TT_bLS.Time>TT_IHF.Time(o) & TT_bLS.Time<TT_IHF.et(o)), "omitnan");
    TT_IHF.WD(o) = mean(TT_bLS.WD(TT_bLS.Time>TT_IHF.Time(o) & TT_bLS.Time<TT_IHF.et(o)), "omitnan");
    TT_IHF.d(o) = mean(TT_bLS.d(TT_bLS.Time>TT_IHF.Time(o) & TT_bLS.Time<TT_IHF.et(o)), "omitnan");
    TT_IHF.sUu(o) = mean(TT_bLS.sUu(TT_bLS.Time>TT_IHF.Time(o) & TT_bLS.Time<TT_IHF.et(o)), "omitnan");
    TT_IHF.sVu(o) = mean(TT_bLS.sVu(TT_bLS.Time>TT_IHF.Time(o) & TT_bLS.Time<TT_IHF.et(o)), "omitnan");
    TT_IHF.sWu(o) = mean(TT_bLS.sWu(TT_bLS.Time>TT_IHF.Time(o) & TT_bLS.Time<TT_IHF.et(o)), "omitnan");
    TT_IHF.CRDS_emis(o) = mean(TT_bLS.emis_NH3_BUH(TT_bLS.Time>TT_IHF.Time(o) & TT_bLS.Time<TT_IHF.et(o)), "omitnan");
end

% Calculate mean bLS emissions from by averaging bLS emission value from each height:
temp = [mean(IHF_bLS.emis(IHF_bLS.rn == 1),"omitnan") mean(IHF_bLS.emis(IHF_bLS.rn == 2),"omitnan") mean(IHF_bLS.emis(IHF_bLS.rn == 3),"omitnan") mean(IHF_bLS.emis(IHF_bLS.rn == 4),"omitnan") mean(IHF_bLS.emis(IHF_bLS.rn == 5),"omitnan") mean(IHF_bLS.emis(IHF_bLS.rn == 6),"omitnan") mean(IHF_bLS.emis(IHF_bLS.rn == 7),"omitnan") mean(IHF_bLS.emis(IHF_bLS.rn == 8),"omitnan")];
temp_std = [std(IHF_bLS.emis(IHF_bLS.rn == 1),"omitnan") std(IHF_bLS.emis(IHF_bLS.rn == 2),"omitnan") std(IHF_bLS.emis(IHF_bLS.rn == 3),"omitnan") std(IHF_bLS.emis(IHF_bLS.rn == 4),"omitnan") std(IHF_bLS.emis(IHF_bLS.rn == 5),"omitnan") std(IHF_bLS.emis(IHF_bLS.rn == 6),"omitnan") std(IHF_bLS.emis(IHF_bLS.rn == 7),"omitnan") std(IHF_bLS.emis(IHF_bLS.rn == 8),"omitnan")];

IHF_bLS_temp = IHF_bLS;
IHF_bLS_temp(IHF_bLS_temp.Sensor == 4 | IHF_bLS_temp.Sensor == 5, :) = [];

% Calculate mean bLS emissions from by averaging bLS emission value from lowest three heights:
temp1 = [mean(IHF_bLS_temp.emis(IHF_bLS_temp.rn == 1),"omitnan") mean(IHF_bLS_temp.emis(IHF_bLS_temp.rn == 2),"omitnan") mean(IHF_bLS_temp.emis(IHF_bLS_temp.rn == 3),"omitnan") mean(IHF_bLS_temp.emis(IHF_bLS_temp.rn == 4),"omitnan") mean(IHF_bLS_temp.emis(IHF_bLS_temp.rn == 5),"omitnan") mean(IHF_bLS_temp.emis(IHF_bLS_temp.rn == 6),"omitnan") mean(IHF_bLS_temp.emis(IHF_bLS_temp.rn == 7),"omitnan") mean(IHF_bLS_temp.emis(IHF_bLS_temp.rn == 8),"omitnan")];
temp_std1 = [std(IHF_bLS_temp.emis(IHF_bLS_temp.rn == 1),"omitnan") std(IHF_bLS_temp.emis(IHF_bLS_temp.rn == 2),"omitnan") std(IHF_bLS_temp.emis(IHF_bLS_temp.rn == 3),"omitnan") std(IHF_bLS_temp.emis(IHF_bLS_temp.rn == 4),"omitnan") std(IHF_bLS_temp.emis(IHF_bLS_temp.rn == 5),"omitnan") std(IHF_bLS_temp.emis(IHF_bLS_temp.rn == 6),"omitnan") std(IHF_bLS_temp.emis(IHF_bLS_temp.rn == 7),"omitnan") std(IHF_bLS_temp.emis(IHF_bLS_temp.rn == 8),"omitnan")];


TT_IHF.bLS_IHF_emis_avg_3 = temp1';
TT_IHF.bLS_IHF_emis_std_3 = temp_std1';
TT_IHF.bLS_IHF_emis_std_Perc_3 = TT_IHF.bLS_IHF_emis_std_3 ./ TT_IHF.bLS_IHF_emis_avg_3*100;

TT_IHF.bLS_IHF_emis_avg = temp';
TT_IHF.bLS_IHF_emis_std = temp_std';
TT_IHF.bLS_IHF_emis_std_Perc = TT_IHF.bLS_IHF_emis_std ./ TT_IHF.bLS_IHF_emis_avg*100;
clearvars temp temp_std temp1 temp_std1
% writetimetable(TT_IHF, [PATH, '\eGylle_3_IHF_int.txt'], 'Delimiter','tab') % Table used for bLS calculations of the IHF concentrations in R


%% TAN loss
% Loss of TAN - 7 days after application
% kg ammonium-N pr ton (TAN) = 1.726 g/kg
% 17.5 ton slurry/ha
% 20 ton slurry/ha for WT
% DM = 6.91 %
% Total N = 3.47 g/kg
TAN_slurry = 17.50466 * 1.726E5 * 17.031 / 14.0067; % Basis for TAN er N mens flux er NH3
TAN_slurry_WT = 20.0 * 1.726E5 * 17.031 / 14.0067; % Basis for TAN er N mens flux er NH3


TT_IHF.IHF_emis = IHF_emis.Emis_ugm2s;
TT_IHF.bLS_CRDS_cum_emis = cumsum(TT_IHF.CRDS_emis.* TT_IHF.ShiftTime*60*60/(TAN_slurry)*100, 'omitnan');
TT_IHF.bLS_IHF_cum_emis = cumsum(TT_IHF.bLS_IHF_emis_avg .* TT_IHF.ShiftTime*60*60/(TAN_slurry)*100, 'omitnan'); % CHANGED
TT_IHF.bLS_IHF_cum_emis_3 = cumsum(TT_IHF.bLS_IHF_emis_avg_3 .* TT_IHF.ShiftTime*60*60/(TAN_slurry)*100, 'omitnan');
TT_IHF.IHF_cum_emis = cumsum(TT_IHF.IHF_emis .* TT_IHF.ShiftTime*60*60/(TAN_slurry)*100, 'omitnan');

% Uncertainty of cum for bLS-IHF
TT_IHF.bLS_IHF_cum_emis_3 = cumsum(TT_IHF.bLS_IHF_emis_avg_3 .* TT_IHF.ShiftTime*60*60/(TAN_slurry)*100, 'omitnan');


%% WT TAN

TT_WT.T_dif = zeros(height(TT_WT),1);
TT_WT.C_dif = zeros(height(TT_WT),1);

for o = 2:height(TT_WT)
    TT_WT.T_dif(o) = hours(datetime(TT_WT.Time(o))-datetime(TT_WT.Time(o-1)));
    TT_WT.C_dif(o) = (TT_WT.flux(o)+TT_WT.flux(o-1))/2;
end

TT_WT.flux_cum = cumsum(TT_WT.C_dif .* TT_WT.T_dif *seconds(hours(1))/(TAN_slurry_WT)*100,'omitnan');

%% Gap filling, Averages and TAN
Time_Lim7 = [datetime(2021,11,9,10,0,0), datetime(2021,11,16,10,0,0)];
Time_LimIHF = [datetime(2021,11,9,10,0,0), TT_IHF.et(end)];

TT_bLS.emis_NH3_soft_gap = fillmissing(TT_bLS.emis_NH3_soft,'linear');
TT_bLS.emis_NH3_hard_gap = fillmissing(TT_bLS.emis_NH3_hard, 'linear');
TT_bLS.emis_NH3_BUH_gap = fillmissing(TT_bLS.emis_NH3_BUH, 'linear');

disp('Average Flag Bühler and gap filling - 7 days')
disp([nanmean(TT_bLS.emis_NH3_BUH(TT_bLS.Time >= Time_Lim7(1) & TT_bLS.Time < Time_Lim7(2))) nanmean(TT_bLS.emis_NH3_BUH_gap(TT_bLS.Time > Time_Lim7(1) & TT_bLS.Time < Time_Lim7(2)))])

disp('Cumulated rain fall - 7 days')
disp(sum(rmmissing(TT_rain.mm(TT_rain.Time >= Time_Lim7(1) & TT_rain.Time < Time_Lim7(2)))))

disp('Avg temp - 7 days')
disp(nanmean(TT_bLS.airT(TT_bLS.Time >= Time_Lim7(1) & TT_bLS.Time < Time_Lim7(2))))

disp('Avg WS - 7 days')
disp(nanmean(TT_bLS.WS(TT_bLS.Time >= Time_Lim7(1) & TT_bLS.Time < Time_Lim7(2))))

TAN_BUH = cumsum(TT_bLS.emis_NH3_BUH(TT_bLS.Time >= Time_Lim7(1) & TT_bLS.Time < Time_Lim7(2))*1800/(TAN_slurry)*100, 'omitnan');
TAN_BUH_gap = cumsum(TT_bLS.emis_NH3_BUH_gap(TT_bLS.Time >= Time_Lim7(1) & TT_bLS.Time < Time_Lim7(2))*1800/(TAN_slurry)*100, 'omitnan');

TAN_IHF = cumsum(IHF_emis.Emis_ugm2s .* IHF_emis.ShiftTime*60*60/(TAN_slurry)*100, 'omitnan');

% OBS: Limited to 7 days after application for gap
disp('TAN loss: BUH,    BUH gap')
disp([TAN_BUH(end) TAN_BUH_gap(end)])

% TAN loss from bLS CRDS when time limited to IHF time
TAN_BUH_gap_4days = cumsum(TT_bLS.emis_NH3_BUH_gap(TT_bLS.Time >= Time_LimIHF(1) & TT_bLS.Time <= Time_LimIHF(2))*1800/(TAN_slurry)*100, 'omitnan');

disp('TAN loss: bLS CRDS, bLS CRDS (IHF time), bLS CRDS avg , bLS IHF, IHF')
disp([TAN_BUH_gap(end) TAN_BUH_gap_4days(end) TT_IHF.bLS_CRDS_cum_emis(end) TT_IHF.bLS_IHF_cum_emis_3(end) TT_IHF.IHF_cum_emis(end)])

disp('Removed data (%)')
disp(100-size(rmmissing(TT_bLS.emis_NH3_BUH))/size(TT_bLS.emis_NH3_BUH)*100)


%% Cum bLS
TT_bLS.T_dif = zeros(height(TT_bLS),1);
TT_bLS.C_dif = zeros(height(TT_bLS),1);

for o = 2:height(TT_bLS)
    TT_bLS.T_dif(o) = hours(datetime(TT_bLS.Time(o))-datetime(TT_bLS.Time(o-1)));
    TT_bLS.C_dif(o) = (TT_bLS.emis_NH3_BUH_gap(o)+TT_bLS.emis_NH3_BUH_gap(o-1))/2;
end

TT_bLS.T_dif(TT_bLS.Time < Time_Lim7(1) | TT_bLS.Time >= Time_Lim7(2)) = NaN;

TT_bLS.flux_cum = cumsum(TT_bLS.C_dif .* TT_bLS.T_dif *seconds(hours(1))/(TAN_slurry)*100,'omitnan');
TT_bLS.flux_cum(TT_bLS.Time < Time_Lim7(1) | TT_bLS.Time >= Time_Lim7(2)) = NaN;


TT_bLS.TAN = nan(height(TT_bLS),1);
TT_bLS.TAN(TT_bLS.Time >= Time_Lim7(1) & TT_bLS.Time < Time_Lim7(2)) = cumsum(TT_bLS.emis_NH3_BUH_gap(TT_bLS.Time >= Time_Lim7(1) & TT_bLS.Time < Time_Lim7(2))*1800/(TAN_slurry)*100, 'omitnan');

ALFAM2_3.TAN = cumsum(ALFAM2_3.fluxpred2*1800/(TAN_slurry)*100, 'omitnan');

ii = 2;

%% Plots
if PLOT_SWITCH == 1
    TimeLim = [datetime('2021-11-08 16:00:00'), datetime('2021-11-15 15:30:00')];
    ii = 51;

    SizeOfFont = 11;
    SizeOfFontLgd = 10;

    fig51=figure(ii); % FIGURE 5
    subplot(3,1,1)
    bar(TT_rain.Time, TT_rain.mm);
    ylabel({'Precipitation', '(mm hr^{-1})'},'FontSize',SizeOfFont, 'color','k')
    grid minor
    xlim(TimeLim)
    ylim([0 1.8])

    subplot(3,1,2)
    plot(TT_bLS.Time, TT_bLS.WS)
    ylabel({'Wind speed', '(m s^{-1})'},'FontSize',SizeOfFont, 'color','k')
    grid minor
    xlim(TimeLim)
    ylim([0 4.5])

    subplot(3,1,3)
    plot(TT_bLS.Time, TT_bLS.airT)
    grid minor
    ylabel({'Temperature', '(^oC)'},'FontSize',SizeOfFont, 'color','k')
    xlim(TimeLim)
    ylim([0 13])

    samexaxis('join','abc','xmt','on','yld',1,'YLabelDistance',1.0,'XLim',TimeLim)

    ii = ii + 1;

    if SAVE_FIG == 1
        FigFileName = '3rd_Atmos 3 panel';
        fullFileName = fullfile(foldout, FigFileName);
        fig51 = gcf;
        fig51.PaperUnits = 'centimeters';
        fig51.PaperPosition = [0 0 19 10];
        print(fullFileName,'-dpng','-r800')
    end
end

if PLOT_SWITH_COMP == 1

    % Remove value in the interval just before application to avoid line
    % going into the first point in stairs plot
    TT_bLS.emis_NH3_BUH_gap(35) = NaN;
    TT_bLS.emis_NH3_BUH(35) = NaN;

    % --------------------------------------------------- %
    % Error band on WT:
    opts = spreadsheetImportOptions("NumVariables", 5);
    opts.Sheet = "Sheet1";
    opts.DataRange = "E2:I188";
    opts.VariableNames = ["Time", "flux", "fluxsd", "ConfP", "ConfM"];
    opts.VariableTypes = ["datetime", "double", "double", "double", "double"];
    opts = setvaropts(opts, "Time", "InputFormat", "");
    WTplot = readtable("... \WT_plot.xlsx", opts, "UseExcel", false);

    clear opts

    xconf_WT = [WTplot.Time; WTplot.Time(end:-1:1)];
    yconf_WT = [WTplot.ConfP; WTplot.ConfM(end:-1:1)];
    % --------------------------------------------------- %
    % Error band on FC:
    opts = spreadsheetImportOptions("NumVariables", 5);
    opts.Sheet = "Plot";
    opts.DataRange = "E2:I23";
    opts.VariableNames = ["Time", "flux", "fluxsd", "ConfP", "ConfM"];
    opts.VariableTypes = ["datetime", "double", "double", "double", "double"];
    opts = setvaropts(opts, "Time", "InputFormat", "");
    FCplot = readtable("... \SumExp1.xlsx", opts, "UseExcel", false);

    clear opts
    
    xconf_FC = [FCplot.Time; FCplot.Time(end:-1:1)];
    yconf_FC = [FCplot.ConfP; FCplot.ConfM(end:-1:1)];
    % --------------------------------------------------- %
    % Error band on bLS-IHF:
    opts = spreadsheetImportOptions("NumVariables", 5);
    opts.Sheet = "Plot";
    opts.DataRange = "E2:I15";
    opts.VariableNames = ["Time", "flux", "fluxsd", "ConfP", "ConfM"];
    opts.VariableTypes = ["datetime", "double", "double", "double", "double"];
    opts = setvaropts(opts, "Time", "InputFormat", "");
    bLS_IHF_plot = readtable("... \bLS_IHF_plot.xlsx", opts, "UseExcel", false);

    clear opts
    
    xconf_bLS_IHF = [bLS_IHF_plot.Time; bLS_IHF_plot.Time(end:-1:1)];
    yconf_bLS_IHF = [bLS_IHF_plot.ConfP; bLS_IHF_plot.ConfM(end:-1:1)];
    % --------------------------------------------------- %

    x_stairs_10 = [TT_IHF.Time; {'2021-11-13 10:46:00'}];
    y_stairs_10 = [[TT_IHF.IHF_emis;NaN]];
    y_stairs_11 = [[TT_IHF.bLS_IHF_emis_avg_3;NaN]];
    y_stairs_12 = [[TT_IHF.CRDS_emis;NaN]];
    TT_bLS.emis_NH3_BUH(35) = NaN; % Remove point before application for nicer plot

    fig58=figure(ii); % FIGURE 9
%     h7 = stairs(ALFAM2_3.tstart, ALFAM2_3.fluxpred2, 'LineWidth', 1, 'Marker', 'd', 'color', rgb('dark yellow')); % ALFAM2
%     hold on
    h1 = stairs(x_stairs_10, y_stairs_10, 'LineWidth', 1, 'Marker', 'v', 'color', rgb('purple')); % IHF
    hold on
    p = fill(xconf_bLS_IHF, yconf_bLS_IHF, 'red');
    p.FaceColor = rgb('light red');
    p.FaceAlpha = 0.15;
    p.EdgeColor = 'none';
    hold on
    h2 = stairs(x_stairs_10, y_stairs_11, 'LineWidth', 1, 'Marker', '^', 'color', rgb('light red')); % bLS-Impinger
    hold on
    h3 = stairs(x_stairs_10, y_stairs_12, 'LineWidth', 1, 'Marker', '>', 'color', rgb('dark red')); % bLS-CRDS avg.
    hold on
    h4 = stairs(TT_bLS.Time, TT_bLS.emis_NH3_BUH, 'LineWidth', 1, 'Marker', 'x', 'color', rgb('red')); % bLS-CRDS
    hold on
    p = fill(xconf_WT, yconf_WT, 'red');
    p.FaceColor = rgb('blue');
    p.FaceAlpha = 0.15;
    p.EdgeColor = 'none';
    hold on
    h5 = stairs(TT_WT.Time, TT_WT.flux, 'LineWidth', 1, 'Marker', 'o', 'color', rgb('blue')); % WT
    hold on
    p = fill(xconf_FC, yconf_FC, 'red');
    p.FaceColor = rgb('green');
    p.FaceAlpha = 0.15;
    p.EdgeColor = 'none';
    hold on
    h6 = stairs(TT_Buckets.Time, TT_Buckets.Emis_avg,'LineWidth', 1, 'Marker', '<', 'color', rgb('green')); % FC
%     legend([h4 h5 h6 h1 h2 h3 h7], 'bLS-CRDS', 'WT', 'FC', 'IHF', 'bLS-Impinger', 'bLS-CRDS avg', 'ALFAM2');
    legend([h4 h5 h6 h1 h2 h3], 'bLS-CRDS', 'WT', 'FC', 'IHF', 'bLS-Impinger', 'bLS-CRDS avg');
    grid minor
    ylabel('NH_3 flux (\mug m^{-2} s^{-1})')%, 'FontSize', 14)
    xlim([datetime(2021,11,9,9,45,0), datetime(2021,11,11,9,30,0)])
    ylim([-1 21])
    ii = ii + 1;

    if SAVE_FIG == 1
        FigFileName = 'Flux eGylle3 Fig error';
        fullFileName = fullfile(foldout, FigFileName);
        fig58 = gcf;
        fig58.PaperUnits = 'centimeters';
        fig58.PaperPosition = [0 0 18 12];
        print(fullFileName,'-dpng','-r800')
    end


    TT_WT.cum_sd = TT_WT.cumemissd / TT_WT.cumemismn * TT_WT.flux_cum;

    fig59=figure(ii); % Figure 10
    h4 = plot(TT_IHF.Time, TT_IHF.IHF_cum_emis, 'v-', 'color', rgb('purple')); % IHF
    hold on
    h5 = plot(TT_IHF.Time, TT_IHF.bLS_IHF_cum_emis_3, '^-', 'color', rgb('light red')); % bLS-Impinger
    hold on
    h6 = plot(TT_IHF.Time, TT_IHF.bLS_CRDS_cum_emis, '>-', 'color', rgb('dark red')); % bLS-CRDS avg.
    hold on
    h1 = plot(TT_bLS.Time, TT_bLS.TAN, 'x-', 'color', rgb('red')); % bLS-CRDS
    hold on
    h2 = errorbar(TT_WT.Time, TT_WT.flux_cum, TT_WT.cum_sd, "vertical", 'o-', 'color', rgb('blue')); % WT
    hold on
    h3 = errorbar(TT_Buckets.Time, TT_Buckets.Cum_avg, TT_Buckets.Cum_std, '<-', 'color', rgb('green')); % FC
%     hold on
%     h7 = plot(ALFAM2_3.tstart, ALFAM2_3.erelpred2*100, 'diamond-', 'color', rgb('dark yellow')); % ALFAM2
    grid minor
    legend('IHF', 'bLS-Impingers', 'bLS-CRDS avg', 'bLS-CRDS', 'WT', 'FC', 'NumColumns', 3, 'Location','northoutside');
    legend([h1 h2 h3 h4 h5 h6], 'bLS-CRDS', 'WT', 'FC', 'IHF', 'bLS-Impingers', 'bLS-CRDS avg', 'NumColumns', 3, 'Location','northoutside');
    ylabel('Loss of TAN (% of applied)')%, 'FontSize',14)
    xlim([datetime(2021,11,9,9,0,0), datetime(2021,11,16,9,30,0)])
    ii = ii + 1;

    if SAVE_FIG == 1
        FigFileName = 'TAN_loss';
        fullFileName = fullfile(foldout, FigFileName);
        fig59 = gcf;
        fig59.PaperUnits = 'centimeters';
        fig59.PaperPosition = [0 0 18 16];
        print(fullFileName,'-dpng','-r800')
    end


    x_stairs_20 = [TT_IHF.Time; {'2021-11-13 10:46:00'}];
    y_stairs_20 = [[TT_IHF.c_104; NaN], [TT_IHF.CRDS; NaN]]; % NaN added to make the last line have a duration

    fig60=figure(ii); % FIGURE S11
    stairs(x_stairs_20, y_stairs_20,'LineWidth',1)
    hold on
    plot(TT_bLS.Time, TT_bLS.NH3, '.:')
    legend('Impinger', 'CRDS avg', 'CRDS')
    grid minor
    ylabel('NH_3 (\mug NH_3 m^{-3})')
    xlabel('Time')
    xlim([datetime(2021,11,9,10,0,0), datetime(2021,11,13,11,0,0)])
    ii = ii + 1;

    if SAVE_FIG == 1
        FigFileName = 'Conc IHF and CRDS';
        fullFileName = fullfile(foldout, FigFileName);
        fig60 = gcf;
        fig60.PaperUnits = 'centimeters';
        fig60.PaperPosition = [0 0 18 12];
        print(fullFileName,'-dpng','-r800')
    end


    x_stairs_30 = [TT_IHF.Time; {'2021-11-13 10:46:00'}];
    y_stairs_30 = [[TT_IHF.c_bg; NaN], [TT_IHF.CRDS_BG; NaN]]; % NaN added to make the last line have a duration

    fig61=figure(ii); % FIGURE S12
    stairs(x_stairs_30, y_stairs_30,'LineWidth',1)
    hold on
    plot(TT_bLS.Time, TT_bLS.NH3_bg, '.:')
    legend('Impinger', 'CRDS avg', 'CRDS')
    grid minor
    ylabel('NH_3 (\mug NH_3 m^{-3})')
    xlabel('Time')
    xlim([datetime(2021,11,9,10,0,0), datetime(2021,11,13,11,0,0)])
    ii = ii + 1;

    if SAVE_FIG == 1
        FigFileName = 'Conc IHF and CRDS background';
        fullFileName = fullfile(foldout, FigFileName);
        fig61 = gcf;
        fig61.PaperUnits = 'centimeters';
        fig61.PaperPosition = [0 0 18 12];
        print(fullFileName,'-dpng','-r800')
    end

    %% Pairs plot

    [deming1, sigma, x_est, y_est, stats_deming1] = deming(TT_IHF.bLS_IHF_emis_avg_3(1:7), TT_IHF.IHF_emis(1:7));
    [deming2, sigma, x_est, y_est, stats_deming2] = deming(TT_IHF.CRDS_emis(1:7), TT_IHF.IHF_emis(1:7));
    [deming3, sigma, x_est, y_est, stats_deming3] = deming(TT_IHF.IHF_emis(1:7), TT_IHF.bLS_IHF_emis_avg_3(1:7));
    [deming4, sigma, x_est, y_est, stats_deming4] = deming(TT_IHF.CRDS_emis, TT_IHF.bLS_IHF_emis_avg_3);
    [deming5, sigma, x_est, y_est, stats_deming5] = deming(TT_IHF.IHF_emis(1:7), TT_IHF.CRDS_emis(1:7));
    [deming6, sigma, x_est, y_est, stats_deming6] = deming(TT_IHF.bLS_IHF_emis_avg_3, TT_IHF.CRDS_emis);

    % stats.s_e: Standard error of regression estimate

    edges = [0:1:10];
    xylim = ([0 10]);

    fig63=figure(ii);
    tiledlayout(3,3, 'TileSpacing', 'compact');

    nexttile % 1
    histogram(TT_IHF.IHF_emis,edges)
    grid minor
    tickCell = {'XTickLabel',{}};
    set(gca,tickCell{:});
    ylabel('IHF')

    nexttile % 2
    plot(TT_IHF.bLS_IHF_emis_avg_3, TT_IHF.IHF_emis, 'o')
    grid minor
    refline(deming1(2), deming1(1))
    tickCell = {'XTickLabel',{},'YTickLabel',{}};
    set(gca,tickCell{:});
    ax = refline(1,0);
    ax.Color = 'Red';
    xlim(xylim)
    ylim(xylim)
    txt = ['y = ' num2str(deming1(2),'%.3f') 'x - ' num2str(abs(deming1(1)),'%.3f')];
    text(0.01*xylim(2),0.99*xylim(2),txt,'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')

    nexttile % 3
    plot(TT_IHF.CRDS_emis, TT_IHF.IHF_emis, 'o')
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
    plot(TT_IHF.IHF_emis, TT_IHF.bLS_IHF_emis_avg_3, 'o')
    grid minor
    tickCell = {'XTickLabel',{}};
    set(gca,tickCell{:});
    ylabel('bLS-Impinger')
    refline(deming3(2), deming3(1))
    ax = refline(1,0);
    ax.Color = 'Red';
    xlim(xylim)
    ylim(xylim)
    txt = ['y = ' num2str(deming3(2),'%.3f') 'x + ' num2str(abs(deming3(1)),'%.3f')];
    text(0.01*xylim(2),0.99*xylim(2),txt,'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')

    nexttile % 5
    histogram(TT_IHF.bLS_IHF_emis_avg_3, edges)
    grid minor
    tickCell = {'XTickLabel',{},'YTickLabel',{}};
    set(gca,tickCell{:});

    nexttile % 6
    plot(TT_IHF.CRDS_emis, TT_IHF.bLS_IHF_emis_avg_3, 'o')
    grid minor
    tickCell = {'XTickLabel',{},'YTickLabel',{}};
    set(gca,tickCell{:});
    refline(deming4(2), deming4(1))
    ax = refline(1,0);
    ax.Color = 'Red';
    xlim(xylim)
    ylim(xylim)
    txt = ['y = ' num2str(deming4(2),'%.3f') 'x + ' num2str(abs(deming4(1)),'%.3f')];
    text(0.01*xylim(2),0.99*xylim(2),txt,'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')

    nexttile % 7
    plot(TT_IHF.IHF_emis, TT_IHF.CRDS_emis, 'o')
    grid minor
    xlabel('bLS-IHF')
    ylabel('bLS-CRDS')
    refline(deming5(2), deming5(1))
    ax = refline(1,0);
    ax.Color = 'Red';
    xlim(xylim)
    ylim(xylim)
    txt = ['y = ' num2str(deming5(2),'%.3f') 'x + ' num2str(abs(deming5(1)),'%.3f')];
    text(0.01*xylim(2),0.99*xylim(2),txt,'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')

    nexttile % 8
    plot(TT_IHF.bLS_IHF_emis_avg_3, TT_IHF.CRDS_emis, 'o')
    grid minor
    tickCell = {'YTickLabel',{}};
    set(gca,tickCell{:});
    xlabel('bLS-Impinger')
    refline(deming6(2), deming6(1))
    ax = refline(1,0);
    ax.Color = 'Red';
    xlim(xylim)
    ylim(xylim)
    txt = ['y = ' num2str(deming6(2),'%.3f') 'x - ' num2str(abs(deming6(1)),'%.3f')];
    text(0.01*xylim(2),0.99*xylim(2),txt,'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')

    nexttile % 9
    histogram(TT_IHF.CRDS_emis, edges)
    grid minor
    tickCell = {'YTickLabel',{}};
    set(gca,tickCell{:});
    xlabel('bLS-CRDS')
    ii = ii + 1;

    if SAVE_FIG == 1
        FigFileName = 'Flux pairs plot';
        fullFileName = fullfile(foldout, FigFileName);
        fig63 = gcf;
        fig63.PaperUnits = 'centimeters';
        fig63.PaperPosition = [0 0 18 14];
        print(fullFileName,'-dpng','-r800')
    end

    TT_ALFAM = synchronize(table2timetable(ALFAM2_3,"RowTimes","tstart"), TT_bLS);

    TT_ALFAM_plot = rmmissing(TT_ALFAM,'DataVariables',{'fluxpred2','emis_NH3_BUH'});

    [deming1, sigma, x_est, y_est, stats_deming2] = deming(TT_ALFAM_plot.emis_NH3_BUH, TT_ALFAM_plot.fluxpred2);
    [deming2, sigma, x_est, y_est, stats_deming1] = deming(TT_ALFAM_plot.fluxpred2, TT_ALFAM_plot.emis_NH3_BUH);
    

    % stats.s_e: Standard error of regression estimate

    edges = [0:1:8];
    xylim = ([0 8]);

    fig72=figure(ii);
    tiledlayout(2,2, 'TileSpacing', 'compact');

    nexttile % 1
    histogram(TT_ALFAM_plot.fluxpred2,edges)
    grid minor
    tickCell = {'XTickLabel',{}};
    set(gca,tickCell{:});
    ylabel('ALFAM2 model')

    nexttile % 2
    plot(TT_ALFAM_plot.emis_NH3_BUH, TT_ALFAM_plot.fluxpred2, 'o')
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
    plot(TT_ALFAM_plot.fluxpred2, TT_ALFAM_plot.emis_NH3_BUH, 'o')
    grid minor
    refline(deming2(2), deming2(1))
    ax = refline(1,0);
    ax.Color = 'Red';
    xlabel('ALFAM2 model')
    ylabel('bLS-CRDS')
    xlim(xylim)
    ylim(xylim)
    txt = ['y = ' num2str(deming2(2),'%.3f') 'x - ' num2str(abs(deming2(1)),'%.3f')];
    text(0.01*xylim(2),0.99*xylim(2),txt,'HorizontalAlignment', 'left', 'VerticalAlignment', 'top')
    
    nexttile % 4
    histogram(TT_ALFAM_plot.emis_NH3_BUH,edges)
    grid minor
    tickCell = {'YTickLabel',{}};
    set(gca,tickCell{:});
    xlabel('bLS-CRDS')
    ii = ii + 1;

    if SAVE_FIG == 1
        FigFileName = 'Flux cross plot deming ALFAM';
        fullFileName = fullfile(foldout, FigFileName);
        fig72 = gcf;
        fig72.PaperUnits = 'centimeters';
        fig72.PaperPosition = [0 0 10 8];
        print(fullFileName,'-dpng','-r800')
    end


end


toc