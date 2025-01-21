% Fig1 simulation

%-----------------------------------------------------------------------------
% Copyright (c) 2025 Alireza Alemi 
% Licensed under the Non-Commercial License (for non-commercial use only).
% For commercial use, a separate commercial license must be obtained.
% For more information, contact alireza.alemi@gmail.com
%-----------------------------------------------------------------------------



clear
close all



% Choose which case with what perturbation to simulate
SimulMode = 'u';%'s'-> stable (2stage);      'u'-> unstable (2stage);   '1' -> One stage
perturbCASE = 2; %1-> normal noise; 2 -> signal dep noise




seed=3;
StopTime = 15000;
warning('off')

%dt = 2e-05

eta1 = .01;
eta2U = 1;
eta2S = .0003;
amplitSin = .004;
if strcmp(SimulMode,'u')
    eta2 =eta2U;
    CASE = 1;
    if perturbCASE==2
        StopTime = StopTime/10;
    end

    
elseif strcmp(SimulMode,'s')
    eta2 =eta2S;
    CASE = 2;
    
elseif strcmp(SimulMode,'1')
    eta2 = 0; %single stage
    CASE = 2;
    
else
    error('ParamValueError');
end

alph = eta2U/eta1;

omega_nUnstb = .1;
omega_sd = 0.2;
open('Fig1model');
set_param('Fig1model','StopTime',num2str(StopTime));


sampleTimeRNG = 1;

disp(['Simulation is running...'])
out = sim('Fig1model.slx');
disp(['Simulation is done!'])

% plot
linewidth = 2;
fontsize = 30;%30;
ax3YLIM = [-.05*0 .2]; %w1
ax4YLIM = [-.05*0 .25]; %w2
ax1YLIM = [-0.05*0 0.25];
targetW = 0.1;

figure('DefaultAxesFontSize',fontsize);
if strcmp(SimulMode,'1')
    Ax1s = plotLayout1Stage(out,linewidth,fontsize,targetW);
    Ax1s.ax4.YLim = ax4YLIM;
    Ax1s.ax1.YLim = ax1YLIM;
    Ax1s.ax3.YLim = ax3YLIM;
elseif strcmp(SimulMode,'s')
    Ax2s=plotLayout(out,linewidth,fontsize,targetW);
    Ax2s.ax1.YLim = ax1YLIM;
    Ax2s.ax3.YLim = ax3YLIM; Ax1s.ax3.YLim = ax3YLIM;
    Ax2s.ax4.YLim = ax4YLIM; Ax1s.ax4.YLim = ax4YLIM;
elseif strcmp(SimulMode,'u')
    if perturbCASE==1 %normal
        Ax3U=plotLayout(out,linewidth,fontsize,targetW);
        Ax3U.ax1.YLim = ax1YLIM;
        Ax3U.ax1.YLim = ax1YLIM;
        Ax3U.ax3.YLim = ax3YLIM; %Ax3U.ax3.YLim = ax3YLIM;
        Ax3U.ax4.YLim = ax4YLIM; %Ax3U.ax4.YLim = ax4YLIM;
    else %signal dependent
        mlt = 30;
        Ax3Unew=plotLayout(out,linewidth,fontsize,targetW);
        XLIMsineta = [0,1000];
        YLIMsineta = [-10,10]/6*5/10;
        Ax3Unew.ax1.XLim = XLIMsineta; Ax3Unew.ax3.XLim = XLIMsineta; Ax3Unew.ax4.XLim = XLIMsineta;
        Ax3Unew.ax1.YLim = YLIMsineta; Ax3Unew.ax3.YLim = YLIMsineta; Ax3Unew.ax4.YLim = YLIMsineta;
    end
end
    
disp(['Plotting is done!'])
disp(' ')






%

function Ax = plotLayout(TwoStage,linewidth,fontsize,targetW)
    tl = tiledlayout(3,1,'TileSpacing','Compact');
    Ax = struct();
    Ax.ax1 = nexttile;
    
    plot(TwoStage.Arr.Time,TwoStage.Arr.Data(:,2),'linewidth',linewidth,'color',[0.8500 0.3250 0.0980]);hold on;
    ylabel('Signals','fontsize',fontsize)
    plot(TwoStage.Arr.Time,TwoStage.Arr.Data(:,1),'-','linewidth',linewidth,'color','b');
    box off
    set(Ax.ax1,'xticklabels','');
        
    Ax.ax3 = nexttile;plot(TwoStage.Arr.Time,TwoStage.Arr.Data(:,4),'linewidth',linewidth);box off
    ylabel('w1','fontsize',fontsize)
    set(Ax.ax3,'xticklabels','');
    
    Ax.ax4 = nexttile;
    yline(Ax.ax4,targetW,'linestyle','--','linewidth',linewidth); hold(Ax.ax4,'on');
    plot(Ax.ax4,TwoStage.Arr.Time,TwoStage.Arr.Data(:,5),'linewidth',linewidth);
    ylim([min(TwoStage.Arr.Data(:,5))-.1, 1.13]);
    ylabel('w2','fontsize',fontsize)
   linkaxes([Ax.ax1,Ax.ax3,Ax.ax4],'x')
    xlabel('Time (sec)','fontsize',fontsize)
end


function Ax = plotLayout1Stage(TwoStage,linewidth,fontsize,targetW)
    tl = tiledlayout(3,1,'TileSpacing','Compact');
    Ax = struct();
    Ax.ax1 = nexttile;    
    
    plot(TwoStage.Arr.Time,TwoStage.Arr.Data(:,2),'linewidth',linewidth,'color',[0.8500 0.3250 0.0980]);hold on;
    ylabel('Signals','fontsize',fontsize)
    plot(TwoStage.Arr.Time,TwoStage.Arr.Data(:,1),'-','linewidth',linewidth,'color','b');
    box off
    set(Ax.ax1,'xticklabels','');
    
    Ax.ax3 = nexttile;plot(TwoStage.Arr.Time,TwoStage.Arr.Data(:,4),'linewidth',linewidth);box off;hold on;
    yline(Ax.ax3,targetW,'linestyle','--','linewidth',linewidth*1.5);
    ylabel('w1','fontsize',fontsize);
    set(Ax.ax3,'xticklabels','');
    
    Ax.ax4 = nexttile;
    plot(Ax.ax4,TwoStage.Arr.Time,TwoStage.Arr.Data(:,5),'linewidth',linewidth*2);hold on;
    ylim([min(TwoStage.Arr.Data(:,5))-.1, 1.13]);
    ylabel('w2','fontsize',fontsize)
   linkaxes([Ax.ax1,Ax.ax3,Ax.ax4],'x')
    xlabel('Time (sec)','fontsize',fontsize)
end
