function channelload(fname)
fname = [fname '.dat'];
S = load(fname);
Frequency = S(:,1);
Power = complex(S(:,2), S(:,3));
subplot(2,1,1)
%plot(Frequency, 10*log10(Power));
plot(Frequency-max(Frequency)/2, 10*log10(abs(Power).^2));
N = length(Power);
Power = Power.*hann(N);
%Power = sum(Power);
subplot(2,1,2)
plot(1./Frequency, 10*log10((abs(ifft(Power))).^2))
end