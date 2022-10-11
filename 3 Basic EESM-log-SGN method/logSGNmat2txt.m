% This file converts the output .mat file from eesmLogSGNBasic.m into the 
% ns-3/C++ format and saved in .txt file
clear all
load('snr_LogSGNParam_Config192_Model-B_4-by-2_MCS5_error.mat')
len = length(snrs);
fid = fopen('snr_LogSGNParam_Config192_Model-B_4-by-2_MCS5_error.txt', 'w');
for rowIdx = 1 : len
    fprintf(fid, '{%4.2f, {%6.4f, %6.4f, %6.4f, %6.4f}},\n', snrs(rowIdx), logSGNParam(rowIdx,:));
end
fclose(fid);