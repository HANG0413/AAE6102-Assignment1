%% Add Paths and Load Data
addpath C:\PloyU\DH\Course\Satellite\AAE6102-Assignment-1-main\Urban;
load('navSolCT_1ms_Urban.mat');
urban = navSolutionsCT;
load('navSolCT_KF_1ms_Urban.mat');
urbanKF = navSolutionsCT_KF;

%% Data Preprocessing
urbanGT_LLH = [22.3198722, 114.209101777778, 7]; % Ground truth position
urbanGT_ECEF = llh2xyz([urbanGT_LLH(1)/180 * pi, urbanGT_LLH(2)/180 * pi, urbanGT_LLH(3)]);

% Truncate dataset to first 6389 samples
dataLen = 6389;
fields = {'usrPosLLH', 'localTime', 'usrVel', 'usrVelENU'};
for f = fields
    urban.(f{1}) = urban.(f{1})(1:dataLen, :);
end

urbanLat = urban.usrPosLLH(:,1);
urbanLon = urban.usrPosLLH(:,2);
urbanLocalTime = urban.localTime(:);

% Compute RMSE for Position and Velocity using Vectorized Approach
urban.usrVelRMSE = vecnorm(urban.usrVel, 2, 2);

% Ensure usrPosECEF exists, otherwise use usrPosLLH
if isfield(urban, 'usrPos')
    usrPosData = urban.usrPos;
elseif isfield(urban, 'usrPosLLH')
    usrPosData = llh2xyz(urban.usrPosLLH);
else
    error('No valid position data found in urban dataset.');
end

urban.usrPosRMSE = vecnorm(usrPosData(:,1:2) - urbanGT_ECEF(1:2), 2, 2);

% Compute Mean & Standard Deviation for RMSE
urban.usrVelRMSEMean = mean(urban.usrVelRMSE);
urban.usrVelRMSESTD = std(urban.usrVelRMSE);
urban.usrPosRMSEMean = mean(urban.usrPosRMSE);
urban.usrPosRMSESTD = std(urban.usrPosRMSE);

% Process WLS and KF Data
datasets = {urbanWLS};  % 仅处理 WLS 数据
for i = 1:length(datasets)
    currData = datasets{i};
    
    currData.usrVelRMSE = vecnorm(currData.usrVel, 2, 2);
    
    if isfield(currData, 'usrPos')
        usrPosData = currData.usrPos;
    elseif isfield(currData, 'usrPosLLH')
        usrPosData = llh2xyz(currData.usrPosLLH);
    else
        error('No valid position data found in dataset.');
    end
    
    currData.usrPosRMSE = vecnorm(usrPosData(:,1:2) - urbanGT_ECEF(1:2), 2, 2);
    
    currData.usrVelRMSEMean = mean(currData.usrVelRMSE);
    currData.usrVelRMSESTD = std(currData.usrVelRMSE);
    currData.usrPosRMSEMean = mean(currData.usrPosRMSE);
    currData.usrPosRMSESTD = std(currData.usrPosRMSE);
    
    datasets{i} = currData; % 更新结构体
end
urbanWLS = datasets{1};  % 更新回变量

%% Geographical Scatter Plot - Comparison (OLS, WLS)
figure;
geoscatter(urbanLat, urbanLon, 8, 'b', 'filled');
hold on;
geoscatter(urbanKF.usrPosLLH(:,1), urbanKF.usrPosLLH(:,2), 8, 'r', 'filled');
geoscatter(urbanGT_LLH(1), urbanGT_LLH(2), 50, 'c', 'filled');
geobasemap('streets');
title('Urban Positioning Comparison', 'FontSize', 14, 'FontName', 'Times New Roman');
legend('Urban OLS', 'Urban EKF', 'Ground Truth');

%% WLS Position Variation
figure;
plot(urbanKF.localTime, urbanKF.usrPosENU);
title('Urban Position Variation - EKF');
legend('E', 'N', 'U');
xlabel('Epoch (ms)'); ylabel('Position variation (m)');
xlim([urbanKF.localTime(1) urbanKF.localTime(end)]);
grid on;

%% WLS Velocity Variation
figure;
plot(urbanKF.localTime, urbanKF.usrVel);
title('Urban Velocity - EKF');
legend('Vx', 'Vy', 'Vz');
xlabel('Epoch (ms)'); ylabel('Velocity (m/s)');
xlim([urbanKF.localTime(1) urbanKF.localTime(end)]);
grid on;

figure;
plot(urbanKF.localTime, urbanKF.usrVelENU);
title('Urban Velocity - WLS (ENU)');
legend('E', 'N', 'U');
xlabel('Epoch (ms)'); ylabel('Velocity (m/s)');
xlim([urbanKF.localTime(1) urbanKF.localTime(end)]);
grid on;
