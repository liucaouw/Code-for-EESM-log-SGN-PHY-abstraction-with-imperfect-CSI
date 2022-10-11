PERvsSNR_error0 = [0.9269, 0.5683, 0.2016, 0.0451, 0.0118];
PERvsSNR_error01 = [0.9630, 0.7597, 0.5078, 0.3453, 0.2795];
snr = [17, 21, 25, 29, 32];
semilogy(snr,PERvsSNR_error0,'-o', 'linewidth', 1.0)
hold on;
semilogy(snr,PERvsSNR_error01,'-s', 'linewidth', 1.0)
legend('Full PHY: Perfect estimation (\sigma_e = 0)', 'Full PHY: Imperfect estimation (\sigma_e = 0.1)');
xlabel('RX SNR (dB)');
ylabel('Average PER');
xlim([17, 32]);
grid on