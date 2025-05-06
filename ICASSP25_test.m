%% Constants
clear all; clc;  % Clear workspace and command window

% Set folder paths for original (reference) and synthesized audio files
folderPath1 = './Test_wav_files/Reference/';   % Path to reference .wav files
folderPath2 = './Test_wav_files/Synthesis/';   % Path to synthesized .wav files

% Get lists of .wav files in both folders
fileList1 = dir(fullfile(folderPath1, '*.wav'));  % Reference files
fileList2 = dir(fullfile(folderPath2, '*.wav'));  % Synthesized files

% Ensure both folders have the same number of audio files
numFiles = length(fileList1);
assert(numFiles == length(fileList2), 'Folders must have the same number of .wav files.');

% Read the first reference file to determine number of samples and channels
[a1, fs] = audioread(fullfile(folderPath1, fileList1(1).name));
[numSamples, numChannels] = size(a1);

% Preallocate 3D arrays for storing audio data from each file
data1_ref = zeros(numSamples, numChannels, numFiles);  % Reference audio data
data2_syn = zeros(numSamples, numChannels, numFiles);  % Synthesized audio data

% Loop through all files in both folders
for k = 1:numFiles
    % Read reference audio file
    file1 = fullfile(folderPath1, fileList1(k).name);
    [x1, Fs1] = audioread(file1);

    % Read corresponding synthesized audio file
    file2 = fullfile(folderPath2, fileList2(k).name);
    [x2, Fs2] = audioread(file2);

    % Check if sampling rates are consistent across files
    if Fs1 ~= Fs2
        error('Sampling rate mismatch in file %d: Fs1 = %d Hz, Fs2 = %d Hz', k, Fs1, Fs2);
    end

    % Ensure each audio file has the expected number of samples and channels
    if size(x1,1) ~= numSamples || size(x2,1) ~= numSamples || ...
       size(x1,2) ~= numChannels || size(x2,2) ~= numChannels
        error('Shape mismatch in file %d: Expected [%d x %d]', ...
              k, numSamples, numChannels);
    end

    % Store audio data in the preallocated arrays
    data1_ref(:,:,k) = x1;
    data2_syn(:,:,k) = x2;
end

%% Compute KSRIR for all Room Impulse Responses (RIRs) in the dataset
% Set method for windowing used in the KSRIR calculation
winMeth = 'nonauto';  % Options: 'auto' or 'nonauto'

% Set the range of intermediate reflections to analyze
N_Inter_start = 1;  % Start index for reflection
N_Inter_end = 1;    % End index for reflection (can be changed to analyze more reflections)

% Preallocate arrays to store KSRIR metrics: Loudness Quality (LQ) and Loudness Accuracy (LA)
numReflections = N_Inter_end - N_Inter_start + 1;
KSRIR_LQ = zeros(numFiles, numReflections); 
KSRIR_LA = zeros(numFiles, numReflections); 

% Compute KSRIR metrics
for N_Inter = N_Inter_start : N_Inter_end
    idx = N_Inter - N_Inter_start + 1;  % Index for column
    for i = 1:numFiles
        [KSRIR_LQ(i, idx), KSRIR_LA(i, idx)] = ...
            ICASSP25_KSRIR(data1_ref(:,:,i), data2_syn(:,:,i), Fs1, winMeth, N_Inter);
    end
end

%% Reduce and save the KSRIR metrics
% Compute the mean values across all files
Mean_LQ = mean(KSRIR_LQ);  % Mean Loudness Quality
Mean_LA = mean(KSRIR_LA);  % Mean Loudness Accuracy
Mean = [Mean_LQ, Mean_LA]; % Combine into one result vector

% Save the mean values to an Excel file (append mode)
writematrix(Mean, 'Results.xls', 'WriteMode', 'append');
