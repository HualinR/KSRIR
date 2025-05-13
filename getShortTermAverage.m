function y = getShortTermAverage(x, fs, tau)
% x = data1_c(:,1).^2;fs = 16000; tau = 0.3e-4; tau = 2e-4; 

% Determine averaging filer and apply:
N = ceil(tau*fs/2)*2;
H = hanning(N+1);
H = H / sum(H);
y = x;
% size(H);
y = [y ; zeros(N/2,1)];
% size(y);
y = fftfilt(H,y);
y = y(N/2+1:end);

