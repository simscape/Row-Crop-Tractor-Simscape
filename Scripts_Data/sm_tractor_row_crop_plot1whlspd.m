function [fig_h, res] = sm_tractor_row_crop_plot1whlspd(simlogRes,logsoutRes,whlRadF,whlRadR)
% Code to plot simulation results from sm_tractor_row_crop
%% Plot Description:
%
% The plot below shows the wheel speeds during the maneuver.  The
% rotational wheel speeds are scaled by the unloaded radius so they can be
% compared with the translational speed of the vehicle.

% Copyright 2021-2024 The MathWorks, Inc.

% Reuse figure if it exists, else create new figure
figString = ['h1_' mfilename];
% Only create a figure if no figure exists
figExist = 0;
fig_hExist = evalin('base',['exist(''' figString ''',''var'')']);
if (fig_hExist)
    figExist = evalin('base',['ishandle(' figString ') && strcmp(get(' figString ', ''type''), ''figure'')']);
end
if ~figExist
    fig_h = figure('Name',figString);
    assignin('base',figString,fig_h);
else
    fig_h = evalin('base',figString);
end
figure(fig_h)
clf(fig_h)

% Get simulation results
simlog_t    = simlogRes.Tractor.Revolute_Whl_FL.Revolute_Joint.Rz.w.series.time;
simlog_vFL  = simlogRes.Tractor.Revolute_Whl_FL.Revolute_Joint.Rz.w.series.values('rad/s')*whlRadF;
simlog_vFR  = simlogRes.Tractor.Revolute_Whl_FR.Revolute_Joint.Rz.w.series.values('rad/s')*whlRadF;
simlog_vRL  = simlogRes.Tractor.Revolute_Whl_RL.Revolute_Joint.Rz.w.series.values('rad/s')*whlRadR;
simlog_vRR  = simlogRes.Tractor.Revolute_Whl_RR.Revolute_Joint.Rz.w.series.values('rad/s')*whlRadR;
simlog_Veh  = logsoutRes.get('Vehicle');
simlog_vVeh = simlog_Veh.Values.Chassis.Body.CG.vx.Data;

% Plot results
plot(simlog_t, simlog_vVeh, 'k--', 'LineWidth', 1)
hold on
plot(simlog_t, simlog_vFL, 'LineWidth', 1)
plot(simlog_t, simlog_vFR, 'LineWidth', 1)
plot(simlog_t, simlog_vRL, 'LineWidth', 1)
plot(simlog_t, simlog_vRR, 'LineWidth', 1)

hold off
ylabel('Speed (m/s)')
xlabel('Time (s)')
title('Wheel Speeds and Vehicle Speed')
grid on
legend({'Vehicle','FL','FR','RL','RR'},'Location','Best');
text(0.05,0.05,'Wheel Speeds estimated with unloaded radius','Units','normalized','Color',[0.6 0.6 0.6])

res.t   = simlog_t;
res.vFL = simlog_vFL;
res.vFR = simlog_vFR;
res.vRL = simlog_vRL;
res.vRR = simlog_vRR;


