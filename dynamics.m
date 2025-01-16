function [W, W_aut, Ws, W_auts, r, pc, errors, cf, I, r_perf, r_perf2, W_autIdxs, W_Idxs] = dynamics(r, r_perf, pc, W_init, W_aut_init, W_aut_dev, I, drdt, errors, cf, eta_W, eta_aut,  Ts, tau, dt, maxPos, Iamp, learningflg, dVec, kVec, nNI, kVecSacc, MU_, mCorrI, saccPerSec,idxs,w_nNz)    

    %-----------------------------------------------------------------------------
    % Copyright (c) 2025 Alireza Alemi 
    % Licensed under the Non-Commercial License (for non-commercial use only).
    % For commercial use, a separate commercial license must be obtained.
    % For more information, contact alireza.alemi@gmail.com
    %-----------------------------------------------------------------------------

    Ts_len = length(Ts);
    Ws = zeros(1, Ts_len);
    W_auts = zeros(1, Ts_len);
    %W_aut = W_aut_init;
    W = W_init ;
    W_autIdxs = {};
    W_Idxs = {};
    
    Ws(1,1) = kVec' * W;
    
    W_aut = W_aut_init;% kVec * dVec';
    W_auts(1,1) = dVec' * W_aut * kVecSacc; %<----------

        
    
    r_perf2 = zeros(size(r_perf));
    
    
    M=1/dt;

    
    if saccPerSec~=0
        next_sacc_time = -log(rand) / saccPerSec;  % First ISI
    end
    %disp(['next_sacc_time = ',num2str(next_sacc_time)]);
    
    for ti = 1 : Ts_len - 1
        tInSec = ti * dt;
        
        if ti==idxs(1)
            W_autIdxs{1} = W_aut;
            W_Idxs{1} = W;
        elseif ti==idxs(2)
            W_autIdxs{2} = W_aut;
            W_Idxs{2} = W;
        end
            
        
        if saccPerSec~=0
            if tInSec >= next_sacc_time %regular sacc
                I(ti) = (randn * Iamp);
                next_sacc_time = tInSec + (-log(rand) / saccPerSec);
            end
        end
        
        
        
        pc(1,ti) = W' * r(:,ti);
        drdt(:,ti) = (-r(:,ti) +  W_aut * r(:,ti) + I(1,ti) * kVecSacc -  kVec * pc(1,ti)*1)/tau; %Network
        r(:, ti+1) = r(:, ti) + drdt(:,ti)*dt;
        if I(1,ti)~=0
            r_perf2(:,ti+1) =  dVec' *  r(:, ti+1);
        else
            r_perf2(:,ti+1) =  r_perf2(:,ti);
        end

        
        if I(1,ti)==0
            r_perf(1,ti+1) = r_perf(1,ti);
        else
            r_perf(1,ti+1) = dVec' * r(:, ti+1);
        end
        %r_perf(1,ti+1) = r_perf(1,ti) + I(1,ti)/tau * dt;  %OLD I_perf
        
        
        if any(dVec' * r(:,ti) > maxPos)
            %thisidx = r(:,ti) > maxPos;
            I(1,ti+1) = -Iamp* mCorrI;
            if saccPerSec~=0, next_sacc_time = tInSec + (-log(rand) / saccPerSec); end %reset %regular sacce
        elseif any(dVec' * r(:,ti) < -maxPos)
            %thisidx = r(:,ti) < -maxPos;
            I(1,ti+1) = Iamp * mCorrI;
            if saccPerSec~=0, next_sacc_time = tInSec + (-log(rand) / saccPerSec); end %reset %regular sacc
        end
        
        
        
        if learningflg
            cf(:,ti) = dVec' * (-r(:,ti) +  W_aut * r(:,ti)  -  kVec * pc(1,ti));
            
            
            cf(1,ti) = (cf(1,ti)+sin(w_nNz*ti)*MU_*cf(1,ti));
           
            
            errors(1,ti+1) = cf(1,ti);
            
            W = W + eta_W * r(1,ti) * cf(1,ti) * dt;
            W_aut =  W_aut - eta_aut * r(1,ti) * pc(1,ti) * dt;
            
        end
        Ws(1,ti+1) = kVec' * W;
%         if W_autFlg
            W_auts(1,ti+1)= dVec' * W_aut * kVecSacc;%<-------
%         end
        
    end
end