%Purpose:
%   Main function of the software-defined radio (SDR) receiver platform
%
%--------------------------------------------------------------------------
%                           SoftXXXGPS v1.0
% 
% Copyright (C) X X  
% Written by X X

clear; 
format long g;
addpath geo             %  
addpath acqtckpos       % Acquisition, tracking, and postiong calculation functions
% addpath C:\PloyU\DH\Course\Satellite\AAE6102-Assignment-1-main\Urban

%% Parameter initialization 
[file, signal, acq, track, solu, dyna, cmn] = initParametersUrban();

%% Acquisition 
if ~exist(['Acquired_',file.fileName,'_',num2str(file.skip),'.mat'])
    [Acquired,NotAcquired] = acquisition(file,signal,acq); 
    save(['Acquired_',file.fileName,'_',num2str(file.skip)],'Acquired'); 
    save(['NotAcquired_',file.fileName,'_',num2str(file.skip)],'NotAcquired'); 
else
    load(['Acquired_',file.fileName,'_',num2str(file.skip),'.mat']);
    load(['NotAcquired_',file.fileName,'_',num2str(file.skip),'.mat']);
end 
fprintf('Acquisition Completed. \n\n');

%% Do conventional signal tracking and obtain satellites ephemeris
fprintf('Tracking ... \n\n');
if ~exist(['eph_',file.fileName,'_',num2str(track.msToProcessCT/1000),'.mat'])
    % tracking using conventional DLL and PLL
    if ~exist(['TckResult_Eph',file.fileName,'_',num2str(track.msToProcessCT/1000),'.mat']) %
        [TckResultCT, CN0_Eph] =  trackingCT(file,signal,track,Acquired); 
        TckResult_Eph = TckResultCT;
        save(['TckResult_Eph',file.fileName,'_',num2str(track.msToProcessCT/1000)], 'TckResult_Eph','CN0_Eph');        
    else   
        load(['TckResult_Eph',file.fileName,'_',num2str(track.msToProcessCT/1000),'.mat']);
    end 
    
    % navigaion data decode
    fprintf('Navigation data decoding ... \n\n');
    [eph, ~, sbf] = naviDecode_updated(Acquired, TckResult_Eph);
    save(['eph_',file.fileName,'_',num2str(track.msToProcessCT/1000)], 'eph');
    save(['sbf_',file.fileName,'_',num2str(track.msToProcessCT/1000)], 'sbf');
%     save(['TckRstct_',file.fileName,'_',num2str(track.msToProcessCT/1000)], 'TckResultCT'); % Track results are revised in function naviDecode for 20 ms T_coh
else
    load(['eph_',file.fileName,'_',num2str(track.msToProcessCT/1000),'.mat']);
    load(['sbf_',file.fileName,'_',num2str(track.msToProcessCT/1000),'.mat']);
    load(['TckResult_Eph',file.fileName,'_',num2str(track.msToProcessCT/1000),'.mat']);
end 
 
%% Find satellites that can be used to calculate user position
posSV  = findPosSV(file,Acquired,eph);
plotAcquisition(Acquired, NotAcquired, file.fileName)

%% Do positiong in conventional or vector tracking mode
cnslxyz = llh2xyz([solu.iniPos(1)/180 *pi,solu.iniPos(2)/180 *pi,solu.iniPos(3)]);

if cmn.vtEnable == 1    
    fprintf('Positioning (VTL) ... \n\n');
  
    % load data to initilize VT
    load(['nAcquired_',file.fileName,'_',num2str(file.skip),'.mat']); % load acquired satellites that can be used to calculate position  
    Acquired = nAcquired;
    
    load(['eph_',file.fileName,'_',num2str(track.msToProcessCT/1000),'.mat']); % load eph
    load(['sbf_',file.fileName,'_',num2str(track.msToProcessCT/1000),'.mat']); % 
    
    load(['tckRstCT_5ms_',file.fileName,'.mat']);%,'_Grid'
    load(['navSolCT_5ms_',file.fileName,'.mat']); 
     
    [TckResultVT, navSolutionsVT] = ...
                  trackingVT_POS_updated_accel(file,signal,track,cmn,solu,Acquired,cnslxyz,eph,sbf,TckResult_Eph, TckResultCT_pos,navSolutionsCT);
else 
    load(['nAcquired_',file.fileName,'_',num2str(file.skip),'.mat']); % load acquired satellites that can be used to calculate position  
    Acquired = nAcquired;
    
    [TckResultCT_pos, navSolutionsCT] = ...
           trackingCT_POS_updated(file,signal,track,cmn,Acquired,TckResult_Eph, cnslxyz,eph,sbf,solu); %trackingCT_POS_multiCorr_1ms
                 
end 

fprintf('Tracking and Positioing Completed.\n\n');

