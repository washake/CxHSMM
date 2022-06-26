clear all
close all
clc

fd=100;               % doppler frequency = 100Hz
ts=0.1e-3;            % sampling time = 1 / sampling rate
Ts=100e-3;            % simulation time
t=[0:ts:Ts];          % time vector
N=length(t);          % 2M+1 complex Gaussian random variables

M=floor((N-1)/2);   
f0=fd/M;
f=[-fd:f0:fd];        % frequencies

var1=(sqrt(((fd.^2)-(f.^2)))).^(-1); % un-normalize var1 with 
%                                      % var1(0)=var1(end)= inf.
                                       % Var at +fd and -fd
%% get values by slope   var=sl*f+C where C is constanct
sl=(var1(2)-var1(3))/f0;                   % slope
C=var1(2)+sl.*f(2);                        % Constant of the straight line
%
var1(end)=sl*fd+C;                        % variance at +fd
var1(1)=var1(end);                        % variance at -fd
% 
Beta=1/sum(var1);                         % Constant of proportionality
Var=Beta*var1;                            % Normalized Variannce
sigma=sqrt(Var);                          % Standard deviation
Mean=0;                                   % mean
stem(f/fd,Var,'linewidth',2)
title('PSD  "bathtub shape" ')
xlabel('f/fd')
xlim([(-fd-f0)/fd (fd+f0)/fd])
grid on
hold on 
plot(f/fd,Var,'.-.','Color','r')
% 
%% Generate Complex Gaussian Random Variable  CRV-frequency domain
% CRV_f=(1/sqrt(2))*((random('Normal',Mean,sigma))+1j*(random('Normal',Mean,sigma)));
CRV_f=(1/sqrt(2))*((normrnd(Mean,sigma))+1j*(normrnd(Mean,sigma)));

%% Complex Gaussian Random Variable  CRV-time domain

CRV_t=CRP(CRV_f,ts,Ts,M);                   % Normalized to 1sec
CRV_t_db_AFD=20.*log10(abs(CRV_t));
CRV_t=CRV_t(1:round(length(CRV_t)/10));     % Random variables in 100ms
CRV_t_Amp=abs(CRV_t);                       % Amplitude of CRV t-domain
CRV_t_Amp_db=20.*log10(CRV_t_Amp);          % Amplitude of CRV t-domain in dB
CRV_t_Phase=angle(CRV_t);                   % Phase of CRV t-domain
r_meanS_CRV_t=rms(CRV_t_Amp);               % root mean square value of CRV
r_meanS_CRV_t_db=20.*log10(r_meanS_CRV_t);  % mean in dB of Complex Random Variable t domain
ten_db_below=r_meanS_CRV_t_db-10;           % mean in dB of Complex Random Variable t domain
%% Plot single realization of the Amplitude and Phase

tsn=.1/length(CRV_t);
t=[0:tsn:.1-(tsn)];
figure
subplot(2,1,1)
plot(t,CRV_t_Phase)
title('single realization of the Phase');
grid on
xlabel('Time[sec]');
ylabel('Phase Radian');
subplot(2,1,2)
[x,tt]=ksdensity(CRV_t_Phase);
plot(tt,x)
title('PDF of Angles');
grid on
xlabel('Angel "Radian"');
hold on
plot([tt(1) tt(end)],[1/(2*pi) 1/(2*pi)],'.-.r','linewidth',2)
legend('Distribution','1/(2*pi) level')
xlim([tt(1) tt(end)])
figure
plot(t,CRV_t_Amp_db)
hold on 
plot([t(1) t(end)],[r_meanS_CRV_t_db r_meanS_CRV_t_db],'color','G','linewidth',3)
plot([t(1) t(end)],[ten_db_below ten_db_below],'.-.r','linewidth',2)
legend('AMPLITUDE','RMS LEVEL','10 dB below RMS LEVEL')
title('single realization of the Amplitude');
xlabel('Time[sec]');
ylabel('Magnitude [dB]');

%% Expectation of Level Crossing Rate in Ts time and Average Fade Duration
RowdB=ten_db_below-r_meanS_CRV_t_db;
Row=10.^(RowdB/20);
disp('Theoretical LCR "Level Crossing Rate" ')
LCR=(sqrt(2*pi).*fd.*Row.*exp(-(Row.^2)))   % Expected level Crossing rate per second
disp('Theoretical AFD "Average Fade Duration" ')
AFD=(exp(Row.^2)-1)/((sqrt(2*pi)).*fd.*Row)
%% exact crossing and exact average fade duration in this run
[LCN_S CPV AFD_S FT]= Cross_N_PD(CRV_t_Amp_db,ten_db_below,tsn);
disp('Simulation Result: Number of Crossing per 0.1 sec "PD: Positive Direction"')
LCN_S                       % simulation crossing number during 0.1 sec
loc=find(CPV);
[LCN_t CPV AFD_S]= Cross_N_PD(CRV_t_db_AFD,ten_db_below,tsn);
disp('Simulation Result: Number of Crossing per 1 sec "PD: Positive Direction"')
LCN_t 
disp('Simulation Result: Average Fade Duration')
AFD_S
disp({'Fraction of time when signal goes below specific level';'total duration of fade per second'})
FT
%% plot filled circles at crossing points in the positive direction
hold on
scatter(t(loc),ten_db_below.*ones(1,length(loc)),'filled','blue')
%% 
figure
[x,tt]=ksdensity(CRV_t_Amp);
plot(tt,x)
title('PDF of Amplitude');
grid on