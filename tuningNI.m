function [Ws, W_auts,errors,Ts, W_aut_init, W, W_aut,idxextrWs, r, pc, W_autIdxs, W_Idxs] = tuningNI(absW_aut_dev,tau, Nsecs,saccPerSec,maxPos, Iamp, eta_W, eta_aut, dVec, kVec, MU_, kVecSacc, wNzSD, Nsecs_TEST, mCorrI, dt, inactivateCrbFlg, inactivateColor, idxs,w_nNz)
    %-----------------------------------------------------------------------------
    % Copyright (c) 2025 Alireza Alemi 
    % Licensed under the Non-Commercial License (for non-commercial use only).
    % For commercial use, a separate commercial license must be obtained.
    % For more information, contact alireza.alemi@gmail.com
    %-----------------------------------------------------------------------------


    
    W_aut_dev = absW_aut_dev;
    
    nNI = length(dVec);
    W_init = zeros(nNI,1);
    W_aut_init = (1 + W_aut_dev)*kVecSacc*dVec' + wNzSD * randn(nNI,nNI) .* (1-eye(nNI,nNI)) ;
    
    Ts = [0*Nsecs:dt:Nsecs-dt];
    Ts_len = length(Ts);
    
    vars2init = {'Ws','errors','W_auts','pc','cf','I','r_perf'};
    vars2initNETW = {'r','rInt','rABD','r_targ','drdt'};

    ZEROS_TS_len = zeros(1, Ts_len);
    ZEROS_TS_lenNETW = zeros(nNI, Ts_len);

    
    initVars(vars2init, ZEROS_TS_len, '');
    initVars(vars2initNETW, ZEROS_TS_lenNETW, '');
    
    learningflg = true;
    [W, W_aut, Ws, W_auts, r, pc, errors, cf, I, r_perf, r_perf2, W_autIdxs, W_Idxs] = dynamics(r, r_perf, pc, W_init, W_aut_init, W_aut_dev, I, drdt, errors, cf, eta_W, eta_aut,  Ts, tau, dt, maxPos, Iamp, learningflg, dVec, kVec, nNI, kVecSacc, MU_, mCorrI, saccPerSec,idxs,w_nNz);
    
    [extrWs, idxextrWs] = max(Ws);
     
     
   

    disp(['W_aut_final=',num2str(dVec'*W_aut*kVecSacc), ', W_final=',num2str(kVec'*W)]);
    disp(' ');
    
end



