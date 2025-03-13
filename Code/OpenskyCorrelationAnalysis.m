% load('C:\PloyU\DH\Course\Satellite\AAE6102-Assignment-1-main\Urban\tckRstCT_5ms_Urban.mat')
% load('Acquired_Urban_0.mat')
% urbanTck = TckResultCT_pos;
% urbanCN0 = CN0_CT;
% urbanSV = Acquired.sv;
% Spacing = 0.6:-0.05:-0.6;
% plotSamplingInterv = 1000;
% 
% %% Urban ACF Construction
% h = waitbar(0,['Constructing Urban ACF ...']);
% for i = 1:length(urbanTck(urbanSV(1)).E)
%     waitbar(i/length(urbanTck(urbanSV(1)).E),h)
%     for svInd = 1:length(urbanSV)
%         prn = urbanSV(svInd);
%         urbanTck(prn).ACF(i,:) = [urbanTck(prn).E(i) urbanTck(prn).E2(i) urbanTck(prn).E3(i) ...
%             urbanTck(prn).E4(i) urbanTck(prn).E5(i) urbanTck(prn).P(i) ...
%             urbanTck(prn).L2(i) urbanTck(prn).L3(i) urbanTck(prn).L4(i) ...
%             urbanTck(prn).L5(i) urbanTck(prn).L(i)];
%     end
% end
% close(h)
% 
% %% Urban ACF Plot
% h = waitbar(0,['Plotting Urban ACF ...']);
% for svInd = 1:length(urbanSV)
% figure(svInd);
% for i = 1:plotSamplingInterv:length(urbanTck(urbanSV(1)).E)
%     waitbar(i/length(urbanTck(urbanSV(svInd)).E),h)
%     prn = urbanSV(svInd);
%     plot(Spacing(3:2:23),urbanTck(prn).ACF(i,:),'-*')
%     hold on  
% end
% hold off
% grid on
% title(sprintf('ACF of PRN %d', prn));
% xlabel('Time Delay (Chip)')
% ylabel('Correlation Value')
% end
% close(h)





%% Load Data
load('tckRstCT_5ms_Opensky.mat');
load('Acquired_Opensky_0.mat');

openSkyTck = TckResultCT_pos;
openSkyCN0 = CN0_CT;
openSkySV = Acquired.sv;

Spacing = 0.6:-0.05:-0.6; % Time delay (Chip)
plotSamplingInterv = 1000; % Sampling interval

%% Construct ACF (Autocorrelation Function)
h = waitbar(0, 'Constructing OpenSky ACF ...');
numEpochs = length(openSkyTck(openSkySV(1)).E);

for svInd = 1:length(openSkySV)
    prn = openSkySV(svInd);
    for i = 1:numEpochs
        openSkyTck(prn).ACF(i, :) = [openSkyTck(prn).E(i), openSkyTck(prn).E2(i), openSkyTck(prn).E3(i), ...
                                     openSkyTck(prn).E4(i), openSkyTck(prn).E5(i), openSkyTck(prn).P(i), ...
                                     openSkyTck(prn).L2(i), openSkyTck(prn).L3(i), openSkyTck(prn).L4(i), ...
                                     openSkyTck(prn).L5(i), openSkyTck(prn).L(i)];
    end
    if mod(svInd, 5) == 0  % Reduce the frequency of waitbar updates for efficiency
        waitbar(svInd / length(openSkySV), h);
    end
end
close(h);

%% Plot ACF with Different Colors for Each Line
figure;
tiledlayout('flow'); % Auto-arrange subplots to save space
h = waitbar(0, 'Plotting OpenSky ACF ...');

numLines = floor(numEpochs / plotSamplingInterv); % Number of lines to plot
colorMap = turbo(numLines); % Generate a distinct colormap (alternative: parula, jet, hsv)

for svInd = 1:length(openSkySV)
    prn = openSkySV(svInd);
    nexttile; % Create a new subplot
    
    hold on;
    for i = 1:plotSamplingInterv:numEpochs
        colorIdx = round((i / numEpochs) * (numLines - 1)) + 1; % Ensure colors are mapped correctly
        plot(Spacing(3:2:23), openSkyTck(prn).ACF(i, :), '-*', 'Color', colorMap(colorIdx, :), 'LineWidth', 1.2);
    end
    hold off;
    
    grid on;
    title(sprintf('ACF of PRN %d', prn), 'FontSize', 14, 'FontName', 'Times New Roman');
    xlabel('Time Delay', 'FontSize', 12, 'FontName', 'Times New Roman');
    ylabel('ACF', 'FontSize', 12, 'FontName', 'Times New Roman');
    set(gca, 'FontSize', 12, 'FontName', 'Times New Roman');
    
    if svInd == 1  % Only add colorbar for the first subplot
        colormap turbo;
        % colorbar; % Add color legend for clarity
    end
    
    if mod(svInd, 5) == 0
        waitbar(svInd / length(openSkySV), h);
    end
end

close(h);
