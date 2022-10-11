load('sinrPer_Config192_Model-B_1-by-2_MCS5_error0.mat')
H_store = results{1, 1}.HtxrxStore;
Wtx_store = results{1, 1}.WtxStore;
H_store_size = size(H_store);
n_sc_size = H_store_size(1);
n_pkt_size = H_store_size(4);
beta_opt = 39.31;
% beta_opt = 37.64;
gamma_effective_list = [];
sigma_e = 0.1/sqrt(2);
RX_SNR = 9;
Nt = 1;
Nr = 2; 
Nst = min(Nt, Nr);
for n_pkt = 1:n_pkt_size
    sum = 0;
    for n_stream = 1:Nst
        for n_sc = 1:n_sc_size
            H = zeros(Nr,Nt);
            F = zeros(Nt,Nst);
            for i =1:Nr
                for j =1:Nt
                    H(i,j) = H_store(n_sc, j, i, n_pkt);
                end
            end
            for i =1:Nt
                for j =1:Nst
                    F(i,j) = Wtx_store(n_sc, j, i, n_pkt);
                end             
            end

            H_c = (H*F)'*(H*F);       
            H_c_size = size(H_c);
            H = H* F;
            K = inv(H_c + 10^(-RX_SNR/10)*eye(H_c_size(1)));
            W = inv(H_c+10^(-RX_SNR/10)*eye(H_c_size(1)))*H';

            C1 = sigma_e^2*trace(K*H_c*H_c*K')*K*H_c*K';
            C2 = sigma_e^2*trace(H*K*H_c*H_c*K'*H')*K*K';
            C3 = - sigma_e^2*trace(H*K*H_c*H')*K*K';
            C4 = -sigma_e^2*trace(H*H_c*K'*H')*K*K';
            C5 = sigma_e^2*trace(H*H')*K*K';
            C6 = 10^(-RX_SNR/10)*W*W';
            C7 = 10^(-RX_SNR/10)*sigma_e^2*trace(K*H_c*K')*K*H_c*K';
            C8 = 10^(-RX_SNR/10)*sigma_e^2*trace(H*K*H_c*K'*H')*K*K';
            C9 = -10^(-RX_SNR/10)*sigma_e^2*trace(H*K*H')*K*K';
            C10 = -10^(-RX_SNR/10)*sigma_e^2*trace(H*K'*H')*K*K';
            C11 = 10^(-RX_SNR/10)*sigma_e^2*Nr*K*K';

    %         C0 = (W*H)^2;
            K1 = W*H + C1 + C2 +C3 + C4 + C5;
            C0 = K1(n_stream,n_stream)^2;
            C_s = 0;
            for m = 1: Nst
                if m ~= n_stream
                    C_s = C_s + K1(n_stream,m)^2;
                end
            end
            K2 = C6 + C7 + C8 + C9 + C10 + C11;
            C_n = K2(n_stream,n_stream);


            gamma = C0/(C_s + C_n);
    %         gamma = (W*H)^2/(C1 + C2 + C3 + C4 + C5+ C6 + C7 + C8 + C9 + C10 + C11);
    %         gamma = C0/(C1 + C2 + C3 + C4 + C5+ C6 + C7 + C8 + C9 + C10 + C11);

            sum = sum + exp(-gamma/beta_opt);
        end
    end
    sum = sum/n_sc_size/Nst;
    gamma_effective = 10*log10(-beta_opt*log(sum));
    gamma_effective_list = [gamma_effective_list gamma_effective];
end
mean(gamma_effective_list)
histogram(real(gamma_effective_list),'Normalization','pdf')
% histogram(real(gamma_effective_list))

% 10.2099 - 0.0000i