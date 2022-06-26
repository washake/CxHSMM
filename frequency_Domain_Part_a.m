clear all
close all
clc

fd=100;               % doppler frequency = 100Hz
Ts=100e-3;            % simulation time
M=floor((fd*Ts))       
f0=fd/M;
f=[-fd:f0:fd];        % frequensies

var1=(sqrt(((fd.^2)-(f.^2)))).^(-1);   % un-normalize var1 with 
%                                      % var1(0)=var1(end)= inf.

%% get values by slope   var=sl*f+C where C is constanct
sl=(var1(2)-var1(3))/f0;               % slope
C=var1(2)+sl.*f(2);                    % Constant of the straight line
%
var1(end)=sl*fd+C;                     % variance at +fd
var1(1)=var1(end);                     % variance at -fd
% 
Beta=1/sum(var1);                      % Constant of proportionality
Var=Beta*var1;                         % Variannce
%% Plot PSD 
stem(f/fd,Var,'linewidth',2)
title('PSD  "bathtub shape" ')
xlabel('f/fd')
xlim([(-fd-f0)/fd (fd+f0)/fd])
grid on
hold on 
plot(f/fd,Var,'--','Color','r')
plot([((-fd-f0)/fd) ((fd+f0)/fd)],[Var(end) Var(end)],'--','Color','r','linewidth',1.5)
plot([((-fd-f0)/fd) ((fd+f0)/fd)],[Var(M+1) Var(M+1)],'--','Color','r','linewidth',1.5)
