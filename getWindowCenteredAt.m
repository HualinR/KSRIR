function [w, idx0, idx1] = getWindowCenteredAt( idx, N, fs, tau, noStartRamp)
% idx=212; tau=0.012; N=1024; fs=8000; noStartRamp=0;
if (nargin < 5)
    noStartRamp = 0;
end

n       = round(tau*fs/2);
w       = hanning(n*2);
if (noStartRamp)
    w(1:n) = 1;
end

d0      = max(0, n-idx);
d1      = N-max(N, n+idx);
w       = w(d0+1:2*n+d1);
idx0    = idx+d0-n+1;
idx1    = idx+d1+n;





