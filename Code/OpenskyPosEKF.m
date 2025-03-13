addpath C:\PloyU\DH\Course\Satellite\AAE6102-Assignment-1-main\Open-Sky;
load('navSolCT_1ms_Opensky.mat')
openSky = navSolutionsCT;
load('navSolCT_KF_1ms_Opensky.mat')
openSkyKF = navSolutionsCT_KF;

openSkyGT = [22.328444770087565, 114.1713630049711];
openSkyGTECEF = llh2xyz([openSkyGT(1)/180 * pi,openSkyGT(2)/180 * pi, 3]);
openSkyLat = openSky.usrPosLLH(:,1);
openSkyLon = openSky.usrPosLLH(:,2);
openSkyLocalTime = openSky.localTime(:);

for i = 1:length(openSky.localTime)
    openSky.usrVelRMSE(i) = norm(openSky.usrVel(i,:));
    openSky.usrPosRMSE(i) = norm(openSky.usrPos(i,1:2) - openSkyGTECEF(1:2));
end

openSky.usrVelRMSEMean = mean(openSky.usrVelRMSE);
openSky.usrVelRMSESTD = std(openSky.usrVelRMSE);
openSky.usrPosRMSEMean = mean(openSky.usrPosRMSE);
openSky.usrPosRMSESTD = std(openSky.usrPosRMSE);

openSkyKFLat = openSkyKF.usrPosLLH(:,1);
openSkyKFLon = openSkyKF.usrPosLLH(:,2);
openSkyKFLocalTime = openSkyKF.localTime(:);

for i = 1:length(openSky.localTime)
    openSkyKF.usrVelRMSE(i) = norm(openSkyKF.usrVel(i,:));
    openSkyKF.usrPosRMSE(i) = norm(openSkyKF.usrPos(i,1:2) - openSkyGTECEF(1:2));
end
openSkyKF.usrVelRMSEMean = mean(openSkyKF.usrVelRMSE);
openSkyKF.usrVelRMSESTD = std(openSkyKF.usrVelRMSE);
openSkyKF.usrPosRMSEMean = mean(openSkyKF.usrPosRMSE);
openSkyKF.usrPosRMSESTD = std(openSkyKF.usrPosRMSE);

%% Open Sky WLS & KF
figure
geoscatter(openSkyLat,openSkyLon,2,'b')
hold on
geoscatter(openSkyKFLat,openSkyKFLon,2,'r')
geoscatter(openSkyGT(1),openSkyGT(2),30,'g','filled')
geobasemap('streets');
title('Open Sky Positioning Results')
legend('Open Sky OLS','Open Sky EKF','Open Sky GT')

%% Open Sky
% Pos ECEF RMSE
figure
% plot(openSkyLocalTime,openSky.usrPosRMSE)
% hold on
plot(openSkyKFLocalTime,openSkyKF.usrPosENU)
% hold on
% plot(openSkyKFLocalTime,openSkyKF.usrPosRMSE)
% hold off
title('Open Sky Position variation-EKF')
legend('E','N','U')
xlabel('Epoch (ms)')
ylabel('Position variation(m)')
xlim([openSkyKFLocalTime(1) openSkyKFLocalTime(end)])
grid on

figure
plot(openSkyKFLocalTime,openSkyKF.usrVel)
title('Open Sky Velocity-EKF')
xlabel('Epoch (s)')
ylabel('Velocity (m/s)')
grid on
legend('Vx','Vy','Vz')
xlim([openSkyKFLocalTime(1) openSkyKFLocalTime(end)])

figure
plot(openSkyKFLocalTime,openSkyKF.usrVelENU)
title('Open Sky Velocity-EKF')
xlabel('Epoch (s)')
ylabel('Velocity (m/s)')
grid on
legend('E','N','U')
xlim([openSkyKFLocalTime(1) openSkyKFLocalTime(end)]);


%% Add Path
addpath(genpath('C:\PloyU\DH\Course\Satellite\AAE6102-Assignment-1-main\Open-Sky'));

%% Load Data
files = {'navSolCT_1ms_Opensky.mat', 'navSolCT_KF_1ms_Opensky.mat'};
vars = {'openSky', 'openSkyKF'};

for i = 1:length(files)
    if exist(files{i}, 'file')
        load(files{i});
    else
        warning('File %s does not exist, skipping load', files{i});
    end
end

%% Convert Ground Truth Coordinates
openSkyGT = [22.328444770087565, 114.1713630049711];
openSkyGTECEF = llh2xyz([deg2rad(openSkyGT(1)), deg2rad(openSkyGT(2)), 3]);

%% Compute Errors
for varName = vars
    dataset = eval(varName{1});
    dataset.usrVelRMSE = vecnorm(dataset.usrVel, 2, 2);
    dataset.usrPosRMSE = vecnorm(dataset.usrPos(:,1:2) - openSkyGTECEF(1:2), 2, 2);
    
    dataset.usrVelRMSEMean = mean(dataset.usrVelRMSE);
    dataset.usrVelRMSESTD = std(dataset.usrVelRMSE);
    dataset.usrPosRMSEMean = mean(dataset.usrPosRMSE);
    dataset.usrPosRMSESTD = std(dataset.usrPosRMSE);
    
    assignin('base', varName{1}, dataset);
end

%% Visualization of Positioning Results
figure;
geoscatter(openSky.usrPosLLH(:,1), openSky.usrPosLLH(:,2), 2, 'b'); hold on;
geoscatter(openSkyKF.usrPosLLH(:,1), openSkyKF.usrPosLLH(:,2), 2, 'r');
geoscatter(openSkyGT(1), openSkyGT(2), 50, 'g', 'filled');
geobasemap('streets');
title('Open Sky Positioning Results');
legend('Open Sky OLS', 'Open Sky EKF', 'Ground Truth');
grid on;

%% EKF Position Variation
figure;
plot(openSkyKF.localTime, openSkyKF.usrPosENU);
title('Open Sky Position Variation - EKF');
legend('E', 'N', 'U');
xlabel('Epoch (ms)'); ylabel('Position variation (m)');
xlim([openSkyKF.localTime(1) openSkyKF.localTime(end)]);
grid on;

%% EKF Velocity Variation
figure;
plot(openSkyKF.localTime, openSkyKF.usrVel);
title('Open Sky Velocity - EKF');
legend('Vx', 'Vy', 'Vz');
xlabel('Epoch (ms)'); ylabel('Velocity (m/s)');
xlim([openSkyKF.localTime(1) openSkyKF.localTime(end)]);
grid on;

figure;
plot(openSkyKF.localTime, openSkyKF.usrVelENU);
title('Open Sky Velocity - EKF (ENU)');
legend('E', 'N', 'U');
xlabel('Epoch (ms)'); ylabel('Velocity (m/s)');
xlim([openSkyKF.localTime(1) openSkyKF.localTime(end)]);
grid on;
