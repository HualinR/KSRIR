function [result] = xRIRAnalyzer_HR(x, fs,winMeth)
%x = BF_RIR_C1; fs = 16000;
% x = data1_c;
% [xc, fs] = audioread('.../RIR_Testing/BF_Cu_7.wav');
% [x,~] = xRIRCleaner(xc, fs);

w = x(:,1);

% Settings:
tau_short = 0.3e-4;   % specular reflection detection integration time constant
tau_long  = 2e-3;    % local reference level integration time constant, small->better, ne-3 ->48
tau3    = 2e-3;     % specular reflection windowing time constant, small->BETTER
% 2 ms for DROQM and KSRIR
% when fs = 48000, window size = 48000*2*10^-2, 2e-3 ->96, 1e-3 ->48, 0.5e-3 ->24
% when fs = 16000, window size = 16000*2*10^-2, 2e-3 ->32, 1e-3 ->16, 3e-3->48, 5e-3 -> 80
relThr  = -40;      % relative energy threshold
absThr  = 6.0;      % Minimum peak salience level
% winMeth = 'auo';  % Auto (content dependent) or fixed windowing
kbd = load('kbdwin_1024.mat');

% Compute power with two time constants:
Etotal    = sum(w.^2);
Eshort    = getShortTermAverage(w.^2, fs, tau_short);
Elong     = getShortTermAverage(w.^2, fs, tau_long);

% Compute a reference level:
Eref      = (Elong - Eshort * (tau_short/tau_long)) / (1-tau_short/tau_long);
Eref      = max(Eref, Etotal * 10^(relThr/10));

% Compute local peak salience metric:
P       = 10*log10(Eshort ./ Eref);

% Find indices of maxima in local peak salience metric:
M = find( (P > [P(2:end);0]) & (P > [0;P(1:end-1)]) & (P > absThr) ).';
if (isempty(M))
    [~,M] = max(Eshort);
end

% Separate and analyze each peak out of the mixture:
xd = x;
od = zeros(size(xd));
ods = {};
for idx = 1 : length(M)
    % Segment the region around the local peak:
    if (strcmp(winMeth, 'auto'))
        idx0 = find(P(1:M(idx))   < absThr, 1, 'last');
        if (isempty(idx0)), idx0 = 1; end
        idx1 = find(P(M(idx):end) < absThr, 1, 'first') + M(idx)-1;
        if (isempty(idx1)), idx1 = length(x); end
        w    = max(0,P(idx0:idx1) - absThr);
        w    =  w / max(w);
    else
        [w, idx0, idx1] = getWindowCenteredAt( M(idx), size(x,1), fs, tau3);
    end
    xw = xd(idx0:idx1,:);
    od(idx0:idx1,:) = xd(idx0:idx1,:);
    ods{idx}.reflection = xw;
%     ods{idx}.location   = xRIRLocator(xw,fs,kbd.win);
end

of = xd-od;
result.of = of;
result.od = od;
result.ods = ods;
result.M = M;
