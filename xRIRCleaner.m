function [x,idx0] = xRIRCleaner(x, fs)
% x = data2; fs = 16000;
% remove DC:
cHP         = 20;
[b,a]       = butter(1, 0.5 * cHP / fs, 'high');
x           = filter(b,a,x);

% remove silence
tStart       = -30;  
tEnd         = -70;  
tRmp         = 1e-3; 
E            = sum(x.^2,2);
Esum         = cumsum(E);

thr0         = Esum(end)*10^(tStart/10);
idx0         = find( E >=thr0, 1, 'first');
thr1         = Esum(end) * (1 - 10^(tEnd/10));
idx1         = find(Esum <= thr1, 1, 'last');
rmp          = min(round(tRmp*fs), idx0);
x            = x(idx0-rmp+1:idx1,:);
x(1:rmp,:)   = x(1:rmp,:).* repmat([1:rmp].'/rmp,1, size(x,2));

end
