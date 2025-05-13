function [LQ,LA] = ICASSP25_KSRIR(BF_RIR_CR, BF_RIR_OP, Fs, winMeth, N_Inter)
% ICASSP25_KSRIR evaluates the quality of synthesized Room Impulse Responses (RIRs)
% against reference B-format RIRs using Kolmogorov–Smirnov (KS) statistics.
% Hualin Ren created in Sun Aug 25, 2024 
% 
% Inputs:
%   BF_RIR_CR : Reference B-format RIR [channels x RIR samples]
%   BF_RIR_OP : Synthesized B-format RIR with the same dimensions
%   Fs        : Sampling rate (Hz)
%   winMeth   : Windowing method for segmenting reflections ('nonauto' or 'auto')
%   N_Inter   : Number of impulse response segments to analyze (1 = direct sound only)
%
% Outputs:
%   LQ        : Listening Quality score based on KSRIR test
%   LA        : Localization Accuracy score based on weighted KSRIR test

% Get the length of the input RIRs (used for padding to consistent size)
Trun_Len = size(BF_RIR_CR,1);

% Clean the reference and synthesized RIRs (remove silence, etc.)
[BF_RIRR,~] = xRIRCleaner(BF_RIR_CR, Fs);
[BF_RIRSYN,~] = xRIRCleaner(BF_RIR_OP, Fs);

% Pad the cleaned RIRs to ensure they are the same length
if Trun_Len > size(BF_RIRR,1)
    num = Trun_Len - size(BF_RIRR,1);
    BF_RIRR = padarray(BF_RIRR, num, 0, 'post');
end

if Trun_Len > size(BF_RIRSYN,1)
    num = Trun_Len - size(BF_RIRSYN,1);
    BF_RIRSYN = padarray(BF_RIRSYN, num, 0, 'post');
end

% Normalize each RIR so that the maximum absolute amplitude in all channels is 1
BF_RIRR = BF_RIRR ./ max(max(abs(BF_RIRR)));
BF_RIRSYN = BF_RIRSYN ./ max(max(abs(BF_RIRSYN)));

% Initialize result arrays for each channel
KS = zeros(1,4);        % Basic KS scores
advKS = zeros(1,4);     % Advanced (weighted) KS scores

% Loop through each channel (e.g., W, X, Y, Z in B-format)
for Channel = 1:size(BF_RIRR,2)

    % Analyze reflections using external function
    BF_RIR_RR = xRIRAnalyzer_HR(BF_RIRR(:,Channel), Fs, winMeth);

    % Limit the number of reflection segments to analyze
    N_Inter = min(N_Inter, length(BF_RIR_RR.M));

    % Initialize per-reflection analysis
    KS_block = zeros(N_Inter,1);         % KS score per reflection
    max_div_ref = zeros(N_Inter,1);      % Max amplitude per block (reference)
    max_div_syn = zeros(N_Inter,1);      % Max amplitude per block (synthesized)

    for i = 1:N_Inter
        % Get the reflection block timing and data
        refR = BF_RIR_RR.ods{1, i}.reflection;
        refR_t = BF_RIR_RR.M(i); % center time of the reflection block
        num = size(refR,1);      % block size

        % Extract equal-length segments from both reference and synthesized signals
        if round(refR_t - num/2) == 0
            refR = BF_RIRR(round(refR_t - num/2 + 1) : round(refR_t + num/2), Channel);
            refSYN = BF_RIRSYN(round(refR_t - num/2 + 1) : round(refR_t + num/2), Channel);
        else
            refR = BF_RIRR(round(refR_t - num/2) : round(refR_t + num/2), Channel);
            refSYN = BF_RIRSYN(round(refR_t - num/2) : round(refR_t + num/2), Channel);
        end

        % Record peak amplitude for weighting
        max_div_ref(i) = max(abs(refR));
        max_div_syn(i) = max(abs(refSYN));

        % Compute KS test and convert to similarity score
        [~, ~, ks2stat_block] = kstest2(refR, refSYN);
        KS_block(i) = 1 - abs(ks2stat_block);
    end

    % Average KS score over all segments
    KS(1, Channel) = sum(KS_block) / length(KS_block);
end

% Extract Listening Quality (W-channel)
LQ = KS(1,1);

% Calculate Localization Accuracy as geometric mean of directional channels
LA = KS(1,2)^0.999 * KS(1,3)^0.999 * KS(1,4)^0.095;

end
