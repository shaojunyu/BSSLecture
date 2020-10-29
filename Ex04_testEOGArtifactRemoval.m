% Removing EOG artifacts from EEG signals
%
% BMI500 Course
% Lecture:  An Introduction to Blind Source Separation and Independent Component Analysis
%           By: R. Sameni
%           Department of Biomedical Informatics, Emory University, Atlanta, GA, USA
%           Fall 2020
%
% Dependency: The open-source electrophysiological toolbox (OSET):
%       https://github.com/alphanumericslab/OSET.git
%   OR
%       https://gitlab.com/rsameni/OSET.git
%

clc
clear
close all

example = 1;
switch example
    case 1 % A sample EEG from the OSET package
        load EEGdata textdata data % Load a sample EEG signal
        fs = 250;
        x = data'; % make the data in (channels x samples) format
        % Check the channel names
        disp(textdata)
    otherwise
        error('unknown example');
end

N = size(x, 1); % The number of channels
T = size(x, 2); % The number of samples per channel

% Plot the channels
PlotECG(x, 4, 'b', fs, 'Raw data channels');

% Run JADE
lastEigJADE = N; % PCA stage
W_JADE = jadeR(x, lastEigJADE);
s_jade = W_JADE * x;
A_jade = pinv(W_JADE); % The mixing matrix

% Plot the sources
PlotECG(s_jade, 4, 'k', fs, 'Sources extracted by JADE');

eog_channel = [2 3]; % check from the plots to visually detect the EOG
s_jade_denoised = s_jade;
s_jade_denoised(eog_channel, :) = 0;
x_denoised_jade = A_jade * s_jade_denoised;

% Plot the denoised signals
t = (0 : T - 1)/fs;
for ch = 1 : N
    figure
    hold on
    plot(t, x(ch, :));
    plot(t, x_denoised_jade(ch, :));
    legend(['channel ' num2str(ch)], 'denoised');
    grid
end

