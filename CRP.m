%% Xf: Complex variables in Frequency domain
%  Xi: Complex Variable in time Domain
%  ts: Sampling time
%  Ts: Simulation time 
%  M : Number of frequency Components
function Xi=CRP(Xf,ts,Ts,M)
w0=(2.*pi)./Ts;
xii=zeros(1,length(Xf));
for L=1:length(Xf)
    for k=1:length(Xf)
        xii(L)=xii(L)+(Xf(k).*((exp(1j*w0*ts)).^(L*(k-M))));
    end
end
Xi=xii;