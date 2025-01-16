% main fig4 pub

%-----------------------------------------------------------------------------
% Copyright (c) 2025 Alireza Alemi 
% Licensed under the Non-Commercial License (for non-commercial use only).
% For commercial use, a separate commercial license must be obtained.
% For more information, contact alireza.alemi@gmail.com
%-----------------------------------------------------------------------------


close all
clear

flipflg = 1; %set to zero for stable NI


seed = 2;
rng(seed);
linewidth = 1.25;
fontsize = 8;
fontname = 'Arial';

nNI = 30;
purpleColor = [0.5 0 0.5];
inactivateColor = [0.35    0.35    0.35];
Nsecs = 13600/2;
if flipflg
    eta_aut  = 0.014;
    eta_W = 1.5217e-04;
    sffxfn = 'flipped';
else
    eta_aut = 1.5217e-04;
    eta_W = 0.014;
    sffxfn = '';
end

tau = 1;
absW_aut_dev = 0.5;
dt = 0.05;
mCorrI = 1.275;
saccPerSec = 1;
wNzSD = .001;
Iamp = 48;
saccGain = 1;
maxPos = 2.625;
MU_ = .5;
w_nNz =  0.0029;

saccTime = [1  5/2;
            3 -20/2;
            5 25/2;
            7 -25/2];
Nsecs_TEST = (saccTime(end,1)+1);

alph=eta_aut/eta_W

kVec = rand(nNI,1)/sqrt(nNI);

dVec = rand(nNI,1)/sqrt(nNI);
dVec = dVec/sqrt(dVec'*dVec); %normalize D

kVec = kVec/abs(kVec'*dVec); %normalize kVec
kVecSacc = rand(nNI,1)/sqrt(nNI);
kVecSacc = kVecSacc/abs(kVecSacc'*dVec); %normalize kVecSacc

inactivateCrbFlg = 1;

%for the flipped case
idxpeak = 96370;%97117;
idxtrough = 50645;%52225;


[Ws, W_auts,errors,Ts, W_aut_init, W, W_aut, idxextrWs, r, pc, W_autIdxs, W_Idxs] = tuningNI(absW_aut_dev,tau, Nsecs,saccPerSec,maxPos, Iamp, eta_W, eta_aut, dVec, kVec, MU_, kVecSacc, wNzSD, Nsecs_TEST, mCorrI, dt, inactivateCrbFlg, inactivateColor, [idxpeak, idxtrough],w_nNz);



% %% %%%%    TEST IN DARKs
lenTs_TEST = round(Nsecs_TEST/dt);
Ts_TEST = Ts(1:lenTs_TEST);
I_TEST = zeros(1,lenTs_TEST);
Nsc_TEST = size(saccTime,1);
for i = 1 : Nsc_TEST
    thisIdx = round(saccTime(i,1) / dt);
    I_TEST(thisIdx) = saccTime(i,2);
end
I_TEST = I_TEST * saccGain;

if flipflg
    
    [r_TESTpeak, pc_TESTpeak, errors_TESTpeak, cf_TESTpeak, I_TESTpeak, Ts_TESTpeak] = testInDark(W_Idxs{1}, W_autIdxs{1}, tau, dt, maxPos, Iamp, Ts_TEST, I_TEST, dVec, kVec, nNI,kVecSacc, MU_, mCorrI, 0);
    [r_TESTtrough, pc_TESTtrough, errors_TESTtrough, cf_TESTtrough, I_TESTtrough, Ts_TESTtrough] = testInDark(W_Idxs{2}, W_autIdxs{2}, tau, dt, maxPos, Iamp, Ts_TEST, I_TEST, dVec, kVec, nNI,kVecSacc, MU_, mCorrI, 0);
    
    
else
    [r_TEST, pc_TEST, errors_TEST, cf_TEST, I_TEST, Ts_TEST] = testInDark(W, W_aut, tau, dt, maxPos, Iamp, Ts_TEST, I_TEST, dVec, kVec, nNI,kVecSacc, MU_, mCorrI, 0);
    [r_TEST_NoCrb, pc_TEST_NoCrb, errors_TEST_NoCrb, cf_TEST_NoCrb, I_TEST_NoCrb, Ts_TEST_NoCrb] = testInDark(W.*0, W_aut, tau, dt, maxPos, Iamp, Ts_TEST, I_TEST, dVec, kVec, nNI,kVecSacc, MU_, mCorrI, 0);
    [r_TEST_CrbTun, pc_TEST_CrbTun, errors_TEST_CrbTun, cf_TEST_CrbTun, I_TEST_CrbTun, Ts_TEST_CrbTun] = testInDark(Ws(idxextrWs)*dVec, W_auts(idxextrWs), tau, dt, maxPos, Iamp, Ts_TEST, I_TEST, dVec, kVec, nNI,kVecSacc, MU_, mCorrI, 0);
    [r_TEST_CrbTun_NoCrb, pc_TEST_CrbTun_NoCrb, errors_TEST_CrbTun_NoCrb, cf_TEST_CrbTun_NoCrb, I_TEST_CrbTun_NoCrb, Ts_TEST_CrbTun_NoCrb] = testInDark(Ws(idxextrWs)*dVec.*0, W_auts(idxextrWs), tau, dt, maxPos, Iamp, Ts_TEST, I_TEST, dVec, kVec, nNI,kVecSacc, MU_, mCorrI, 0);
end


ONES = ones(size(Ts_TEST));
markersize = 4;

if flipflg
    figure('DefaultAxesFontSize',fontsize);
    plot(Ts, Ws, Ts, W_auts,'LineWidth',linewidth);
    figsz([.65*3,.65],'LineWidth',linewidth,'FontName',fontname,'TickLength',[0.02 0.02]);
    
    figure('DefaultAxesFontSize',fontsize);
    axpeak = plot(Ts_TEST, dVec'*r_TESTpeak, 'color', purpleColor, 'linewidth', linewidth);hold on;
    plot(Ts(Ts<1),ONES(Ts<1)* min(dVec'*r_TESTpeak) * 1.1, 'color','k','linewidth', linewidth*2);
    figsz([.65,.65],'LineWidth',linewidth,'FontName',fontname,'AxisOff',true);
    
    figure('DefaultAxesFontSize',fontsize);
    axtrough = plot(Ts_TEST, dVec'*r_TESTtrough, 'color', purpleColor, 'linewidth', linewidth);hold on;
    plot(Ts(Ts<1),ONES(Ts<1)* min(dVec'*r_TESTpeak) * 1.1, 'color','k','linewidth', linewidth*2);
    figsz([.65,.65],'LineWidth',linewidth,'FontName',fontname,'AxisOff',true);
    
    figure('DefaultAxesFontSize',fontsize);
    plot(Ws, W_auts,'linewidth',linewidth);hold on;
    
    % weight space plot   
    figsz([.75,.75],'LineWidth',linewidth,'FontName',fontname);%'zbuffer'
    %plot(Ws(1),W_auts(1),'s','MarkerFaceColor','k','markersize',markersize,'MarkerEdgeColor','none');set(gca,'colororderindex',1);hold on;
    plot(Ws(idxpeak),W_auts(idxpeak),'O','MarkerFaceColor','k','markersize',markersize/2,'MarkerEdgeColor','none');set(gca,'colororderindex',1);hold on;
    plot(Ws(idxtrough),W_auts(idxtrough),'O','MarkerFaceColor','k','markersize',markersize/2,'MarkerEdgeColor','none');set(gca,'colororderindex',1);hold on;
    
    drawnow;pause(.1);
    
    
else
    
    if inactivateCrbFlg
        
        %test mid
        figure('DefaultAxesFontSize',fontsize);
        ax1 = plot(Ts_TEST,dVec'*r_TEST_CrbTun, 'color', purpleColor, 'linewidth', linewidth);hold on;
        ax2 = plot(Ts_TEST,dVec'*r_TEST_CrbTun_NoCrb,'-.','linewidth',linewidth*1.5, 'color', inactivateColor);hold on
        plot(Ts(Ts<1),ONES(Ts<1)* min(dVec'*r_TEST) * 1.05, 'color','k','linewidth', linewidth*2);
        figsz([.65,.65],'LineWidth',linewidth,'FontName',fontname,'AxisOff',true);%'zbuffer'
        
        %test final
        figure('DefaultAxesFontSize',fontsize);
        ax1 = plot(Ts_TEST,dVec'*r_TEST, 'color', purpleColor, 'linewidth', linewidth);hold on;
        ax2 = plot(Ts_TEST,dVec'*r_TEST_NoCrb,'-.','linewidth',linewidth*1.5, 'color', inactivateColor);hold on
        plot(Ts(Ts<1),ONES(Ts<1)* min(dVec'*r_TEST) * 1.05, 'color','k','linewidth', linewidth*2);
        figsz([.65,.65],'LineWidth',linewidth,'FontName',fontname,'AxisOff',true);
    end
    

    figure('DefaultAxesFontSize',fontsize);


    plot(Ws, W_auts,'linewidth',linewidth);hold on;
    xlim([-.01-absW_aut_dev*1.02,.01+absW_aut_dev*1.05]);
    ylim([1-absW_aut_dev*1.01,1.02+absW_aut_dev*1.05]);
    
    figsz([.75,.75],'LineWidth',linewidth,'FontName',fontname);
    hold on;
    set(gca,'colororderindex',1);
    LINES = lines;

    drawnow;pause(.1);
end


%% before learning
% [Ws, W_auts,errors,Ts, W_aut_init, W, W_aut, idxextrWs, r, pc, W_autIdxs, W_Idxs] = tuningNI(absW_aut_dev,tau, Nsecs,saccPerSec,maxPos, Iamp, eta_W*0, eta_aut*0, dVec, kVec, MU_, kVecSacc, wNzSD, Nsecs_TEST, mCorrI, dt, inactivateCrbFlg*0, inactivateColor, [idxpeak, idxtrough]);
% 
% [r_TEST, pc_TEST, errors_TEST, cf_TEST, I_TEST, Ts_TEST] = testInDark(W, W_aut, tau, dt, maxPos, Iamp, Ts_TEST, I_TEST, dVec, kVec, nNI,kVecSacc, MU_, mCorrI, 0);
% 
% figure('DefaultAxesFontSize',fontsize);
% ax1 = plot(Ts_TEST,dVec'*r_TEST, 'color', purpleColor, 'linewidth', linewidth);hold on;
% %ax3 = plot(Ts_TEST,dVec'*r_TEST,'-','linewidth',linewidth, 'color', purpleColor);
% plot(Ts(Ts<1),ONES(Ts<1)* min(dVec'*r_TEST) * 1.05, 'color','k','linewidth', linewidth*2);
% figsz([.65,.65],'LineWidth',linewidth,'FontName',fontname,'FontSize',fontsize,'AxisOff',true);




