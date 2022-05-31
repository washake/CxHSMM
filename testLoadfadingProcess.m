clear
clf
itload('fadingProcess.it');
semilogy(abs(sum(fading_process_coeffs(1:100,:),2)).^2,'-b')
hold on 
semilogy(abs(rayleigh_proc_coeffc(1:100)).^2)
% figure
% semilogy(EbN0_dB, BER, 'o-')
% grid on
% xlabel('E_b/N_0 [dB]')
% ylabel('BER')