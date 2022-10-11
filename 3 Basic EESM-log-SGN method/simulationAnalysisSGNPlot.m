%% Introduction 
% This file is the main script to run the basic EESM-log-SGN
% corresponding to Fig.2 in the IEEE TCOM paper:
% "Efficient PHY Layer Abstraction for Fast Simulations in Complex 
% System Environments"
%% Load data
clear all
% Obtain log-SGN parameter under the RX SNR: snrs(snrIdx) in dB
snrIdx = 1; 
% Load Post-MIMO processing SINR matrix
load('sinrPer_Config192_Model-B_1-by-2_MCS5_error01.mat')
sinrStore = results{snrIdx}.sinrStore;
% Load optimized EESM parameter beta
load('eesmEffSinr_Config192_Model-B_1-by-2_MCS5_error01.mat')
% Load basic setup
dataLength = cfgHE.User{1}.APEPLength;
coding = 'LDPC'; % Channel coding
format = 'HE_MU';  % OFDM/OFDMA MIMO/MU-MIMO setup
abstraction = tgaxEESMLinkPerformanceModel;
% Calculate effective SINR histogram
gammaEffdB = effectiveSinrVec(abstraction,sinrStore,betaOpt);
gammaEffLinear = 10.^(gammaEffdB/10);
%% Log-SGN parameters optimization
logSGNParamBest = logSGNFitting(gammaEffLinear);
%% Save log-SGN parameter in file
% filename = sprintf('snr_LogSGNParam_Config%d_%s_%s-by-%s_MCS%s.mat',allocationIndex,char(chan),num2str(numTxRx(1)),num2str(numTxRx(2)),num2str(mcs));
% m = matfile(filename, 'Writable', true);
% % Set saved SNR index
% savedSnrIdx = snrIdx; 
% % Store optimized log-SGN parameters
% m.logSGNParam(savedSnrIdx,1:4) = logSGNParamBest;
% % Store corresponding RX SNR in dB
% m.snrs(savedSnrIdx,1) = snrs(snrIdx);
%% Generate and plot EESM-log-SGN predicted effective SINR histogram
tic;
% Obtain effective SINR and average PER predicted by EESM-log-SGN
% The following line of the code implements the basic EESM-log-SGN method shown
% in Fig. 2 of our IEEE TCOM paper:
% "Efficient PHY Layer Abstraction for Fast Simulations in Complex 
% System Environments"
[effSinrdB,logSGNAvgPer] = logSGNGeneration(abstraction,coding,mcs,dataLength,format,logSGNParamBest);
tEndAbs = toc; % Simulation time of the basic EESM-log-SGN method 
%% Plot EESM-log-SGN fitting result
histogram(gammaEffdB, 'normalization', 'pdf')
hold on
% [pdfEffSnrdB xEffSnrdB]=ksdensity(effSinrdB);
% plot(xEffSnrdB, pdfEffSnrdB,'LineWidth',2)
load('SNR9_1x2_error01.mat');
m = gamma_effective_list;
gammaEffdB = gamma_effective_list;
histogram(real(gammaEffdB), 'normalization', 'pdf')
hold on
[pdfEffSnrdB xEffSnrdB]=ksdensity(real(m));
plot(xEffSnrdB, pdfEffSnrdB,'LineWidth',2)

% title('SNR = 7')
grid('on')
xlabel('Effective SINR (dB)')
ylabel('PDF')
legend('Simulation steps (\sigma_e = 0.1)', 'Analytical steps (\sigma_e = 0.1)', 'Log-SGN fitting');
% legend('Traditional (Perfect Estimation)','EESM-log-SGN (Perfect Estimation)','Traditional (Imperfect Estimation)','EESM-log-SGN (Imperfect Estimation)');
% h =legend('Traditional (Perfect Estimation)','EESM-log-SGN (Perfect Estimation)','Traditional (Imperfect Estimation)','EESM-log-SGN (Imperfect Estimation)');
% set(h, 'FontSize',12)
% legend('Traditional (Perfect estimation)','EESM-log-SGN')