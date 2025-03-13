function plotAcquisition(Acquired, NotAcquired, prefix)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% GPS Satellite Acquisition Visualization Function
%
% This function plots a bar chart representing the acquisition results:
% - Green bars: Successfully acquired satellites
% - Gray bars: Satellites not acquired
%
% Inputs:
%   Acquired     - Data of successfully acquired satellites (contains PRN and SNR)
%   NotAcquired  - Data of satellites not acquired (contains PRN and SNR)
%   prefix       - Prefix for the plot title
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Extract PRN numbers and SNR values
allPRNs = [Acquired.sv NotAcquired.sv];  % PRN numbers of all satellites
allSNRs = [Acquired.SNR NotAcquired.SNR]; % SNR values of all satellites

acquiredPRNs = Acquired.sv;  % PRN numbers of successfully acquired satellites
acquiredSNRs = Acquired.SNR; % SNR values of successfully acquired satellites

% Create the figure
figure();
axesHandler = newplot();
hold(axesHandler, 'on');

% Plot bars for non-acquired satellites (gray)
bar(axesHandler, allPRNs, allSNRs, 'FaceColor', [0.7 0.7 0.7], 'BarWidth', 0.6);

% Plot bars for acquired satellites (green)
bar(axesHandler, acquiredPRNs, acquiredSNRs, 'FaceColor', [0 0.7 0], 'BarWidth', 0.6);

% Set title and labels
title (axesHandler, strcat(prefix, ' Acquisition Result'));
xlabel(axesHandler, 'PRN Number');
ylabel(axesHandler, 'Acquisition Metric (SNR)');

% Auto-adjust the y-axis range to prevent compression of bars
ylim([0 max(allSNRs) * 1.2]);

% Set x-axis tick marks for better readability
xticks(0:2:36); % Adjust PRN number spacing to avoid overcrowding

% Add grid and legend
set(axesHandler, 'XMinorTick', 'on');
set(axesHandler, 'YGrid', 'on');
legend(axesHandler, {'Not Acquired', 'Acquired'}, 'Location', 'NorthWest');

hold(axesHandler, 'off');
drawnow;

end
