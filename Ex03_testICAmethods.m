% Independent component analysis using different methods
%
% Student Name:
% Student Email:
% Date:
%
% BMI500 Course
% Lecture:  An Introduction to Blind Source Separation and Independent Component Analysis
%           By: R. Sameni
% Date: Fall 2020
% Department of Biomedical Informatics, Emory University, Atlanta, GA, USA
%
% Dependency: The open-source electrophysiological toolbox (OSET):
%       https://github.com/alphanumericslab/OSET.git
%   OR
%       https://gitlab.com/rsameni/OSET.git
%

clc
clear
close all

% Load a sample EEG signal
load EEGdata textdata data % A sample EEG from the OSET package
fs = 250;
x = data'; % make the data in (channels x samples) format
% Check the channel names
% disp(textdata)

% Load a sample ECG signal
% load SampleECG2 data % A sample ECG from the OSET package
% fs = 1000;
% x = data(:, 2:end)'; % make the data in (channels x samples) format
% x = x - LPFilter(x, 1.0/fs); % remove the lowpass baseline

N = size(x, 1); % The number of channels
T = size(x, 2); % The number of samples per channel

% Plot the channels
PlotECG(x, 4, 'b', fs, 'Raw data channels');

% Run fastica
approach = 'symm'; % 'symm' or 'defl'
g = 'tanh'; % 'pow3', 'tanh', 'gauss', 'skew'
lastEigfastica = N-3; % PCA stage
numOfIC = N-4; % ICA stage
interactivePCA = 'off';
[s_fastica, A_fatsica, W_fatsica] = fastica (x, 'approach', approach, 'g', g, 'lastEig', lastEigfastica, 'numOfIC', numOfIC, 'interactivePCA', interactivePCA, 'verbose', 'off', 'displayMode', 'off');

% Check the covariance matrix
Cs = cov(s_fastica');

% Run JADE
lastEigJADE = N-3; % PCA stage
W_JADE = jadeR(x, lastEigJADE);
s_jade = W_JADE * x;

% Run SOBI
lastEigSOBI = N-3; % PCA stage
num_cov_matrices = 10;
[W_SOBI, s_sobi] = sobi(x, lastEigSOBI, num_cov_matrices);

% Plot the sources
PlotECG(s_fastica, 4, 'r', fs, 'Sources extracted by fatsica');

% Plot the sources
PlotECG(s_jade, 4, 'k', fs, 'Sources extracted by JADE');

% Plot the sources
PlotECG(s_sobi, 4, 'm', fs, 'Sources extracted by SOBI');
