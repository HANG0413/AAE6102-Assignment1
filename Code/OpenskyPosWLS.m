addpath C:\PloyU\DH\Course\Satellite\AAE6102-Assignment-1-main\Open-Sky;
load('navSolCT_1ms_Opensky.mat')
openSky = navSolutionsCT;
load('navSolCT_WLS_1ms_OpenSky.mat')
openSkyWLS = navSolutionsCT_WLS;
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

openSkyWLSLat = openSkyWLS.usrPosLLH(:,1);
openSkyWLSLon = openSkyWLS.usrPosLLH(:,2);
openSkyWLSLocalTime = openSkyWLS.localTime(:);

for i = 1:length(openSkyWLS.localTime)
    openSkyWLS.usrVelRMSE(i) = norm(openSkyWLS.usrVel(i,:));
    openSkyWLS.usrPosRMSE(i) = norm(openSkyWLS.usrPos(i,1:2) - openSkyGTECEF(1:2));
end
openSkyWLS.usrVelRMSEMean = mean(openSkyWLS.usrVelRMSE);
openSkyWLS.usrVelRMSESTD = std(openSkyWLS.usrVelRMSE);
openSkyWLS.usrPosRMSEMean = mean(openSkyWLS.usrPosRMSE);
openSkyWLS.usrPosRMSESTD = std(openSkyWLS.usrPosRMSE);

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
geoscatter(openSkyWLSLat,openSkyWLSLon,2,'r')
geoscatter(openSkyGT(1),openSkyGT(2),30,'g','filled')
geobasemap('streets');
title('Open Sky Positioning Results')
legend('Open Sky OLS','Open Sky WLS','Open Sky GT')

%% Open Sky
% Pos ECEF RMSE
figure
% plot(openSkyLocalTime,openSky.usrPosRMSE)
% hold on
plot(openSkyWLSLocalTime,openSkyWLS.usrPosENU)
% hold on
% plot(openSkyKFLocalTime,openSkyKF.usrPosRMSE)
% hold off
title('Open Sky Position variation-WLS')
legend('E','N','U')
xlabel('Epoch (ms)')
ylabel('Position variation(m)')
xlim([openSkyWLSLocalTime(1) openSkyWLSLocalTime(end)])
grid on

figure
plot(openSkyWLSLocalTime,openSkyWLS.usrVel)
title('Open Sky Velocity-WLS')
xlabel('Epoch (s)')
ylabel('Velocity (m/s)')
grid on
legend('Vx','Vy','Vz')
xlim([openSkyWLSLocalTime(1) openSkyWLSLocalTime(end)])

figure
plot(openSkyWLSLocalTime,openSkyWLS.usrVelENU)
title('Open Sky Velocity-WLS')
xlabel('Epoch (s)')
ylabel('Velocity (m/s)')
grid on
legend('E','N','U')
xlim([openSkyWLSLocalTime(1) openSkyWLSLocalTime(end)])

