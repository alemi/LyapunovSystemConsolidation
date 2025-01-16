function [r_TEST, pc_TEST, errors_TEST, cf_TEST, I_TEST, Ts_TEST,r_perf_TEST] = testInDark(W, W_aut, tau, dt, maxPos, Iamp, Ts_TEST, I_TEST, dVec, kVec, nNI,kVecSacc, MU_, mCorrI, saccPerSec)
    %-----------------------------------------------------------------------------
    % Copyright (c) 2025 Alireza Alemi 
    % Licensed under the Non-Commercial License (for non-commercial use only).
    % For commercial use, a separate commercial license must be obtained.
    % For more information, contact alireza.alemi@gmail.com
    %-----------------------------------------------------------------------------


    Ts_len_TEST = length(Ts_TEST);

    ZEROS_TS_len2 = zeros(1, Ts_len_TEST);
    ZEROS_TS_lenNETW = zeros(nNI, Ts_len_TEST);
    vars2init = {'errors','W_auts','pc','cf'};
    vars2initNETW = {'r','rInt','rABD','r_targ','r_perf','drdt'};

    initVars(vars2init, ZEROS_TS_len2, '_TEST') %vars2init = {'errors','W_auts','r','rInt','rABD','r_targ','r_perf','drdt','pc','cf','I'};
    
    vars2init = {'Ws','errors','W_auts','pc','cf','I'};
    vars2initNETW = {'r','rInt','rABD','r_targ','r_perf','drdt'};

    initVars(vars2initNETW, ZEROS_TS_lenNETW, '_TEST')
    


    
    learningflg = false;
    [~, ~, ~, ~, r_TEST, pc_TEST, errors_TEST, cf_TEST, I_TEST,r_perf_TEST] = dynamics(r_TEST, r_perf_TEST, pc_TEST, W, W_aut, nan, I_TEST, drdt_TEST, errors_TEST, cf_TEST, nan, nan,  Ts_TEST, tau, dt, maxPos, Iamp, learningflg, dVec, kVec, nNI, kVecSacc, MU_, mCorrI, saccPerSec, [0,0],0);
end
