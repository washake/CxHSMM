clear
clf
itload('fadingProcess.it');
fd = 100; %frequency doppler
semilogy(abs(sum(fading_process_coeffs(1:500,:),2)).^2,'-b')
hold on 
semilogy(abs(rayleigh_proc_coeffc(1:500)).^2)

Y_T=rayleigh_proc_coeffc(1:500);
Y_T_db=20.*log10(abs(Y_T));        % output when length of input=T  in dB
% root mean square value of input signals
rms_Y_T=rms(abs(Y_T));                  % rms of output length = T
rms_Y_T_db=20.*log10(abs(rms_Y_T));     % rms of output length = T in dB
ten_dB_below=rms_Y_T_db-10;



%% plotting output from filters
figure
t=1:length(Y_T_db);
plot(t,Y_T_db)
hold on
plot([t(1) t(end)],[rms_Y_T_db rms_Y_T_db],'.-.black','linewidth',1)
plot([t(1) t(end)],[ten_dB_below ten_dB_below],'.-.r','linewidth',1.5)
grid
legend('AMPLITUDE','RMS LEVEL','10 dB below RMS LEVEL')
xlabel('Time[sec]');
ylabel('Magnitude [dB]');

[CN_PD_s CPV AFD_s FT]= Cross_N_PD(Y_T_db,ten_dB_below,1);

disp('Simulation Result: Number of Crossing per 0.1 sec "PD: Positive Direction"')
CN_PD_s                       % simulation crossing number during 0.1 sec

disp({'Fraction of time when signal goes below specific level';'total duration of fade per second'})
FT
disp('Simulation Result: Average Fade Duration')
AFD_s=(round(AFD_s.*1e5))/(1e5);
title({'single realization of the Amplitude';strcat(' inthis run AFD=',num2str(AFD_s),'   LCN/0.1sec=',num2str(CN_PD_s))})



%% plot filled circles at crossing points in the positive direction
hold on
loc=find(CPV);
scatter(t(loc),ten_dB_below.*ones(1,length(loc)),'filled','blue')

%% Expectation of Level Crossing Rate in Ts time and Average Fade Duration
RowdB=ten_dB_below-rms_Y_T_db;
Row=10.^(RowdB/20);
disp('Theoretical LCR "Level Crossing Rate" ')
LCR=(sqrt(2*pi).*fd.*Row.*exp(-(Row.^2)))   % Expected level Crossing rate per second
disp('Theoretical AFD "Average Fade Duration" ')
AFD=(exp(Row.^2)-1)/((sqrt(2*pi)).*fd*Row)


% figure
% semilogy(EbN0_dB, BER, 'o-')
% grid on
% xlabel('E_b/N_0 [dB]')
% ylabel('BER')