function [fig_h, res] = sm_tractor_row_crop_plot5operator(logsoutRes)
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
simlog_Veh  = logsoutRes.get('Vehicle');
simlog_t = simlog_Veh.Values.Chassis.Body.Driver.gz.Time;
simlog_gzOp = simlog_Veh.Values.Chassis.Body.Driver.gz.Data;
simlog_gzRA = simlog_Veh.Values.Chassis.Body.RA.gz.Data;


% Plot results
plot(simlog_t, simlog_gzRA, 'LineWidth', 1, 'DisplayName','Rear Axle')
hold on
plot(simlog_t, simlog_gzOp, 'LineWidth', 1, 'DisplayName','Operator')
hold off

ylabel('Acceleration (m/s^2)')
xlabel('Time (s)')
title('Vertical Acceleration')
grid on
legend('Location','Best');
%text(0.05,0.05,'Wheel Speeds estimated with unloaded radius','Units','normalized','Color',[0.6 0.6 0.6])

res.t   = simlog_t;
res.gzOp = simlog_gzOp;
res.gzRA = simlog_gzRA;



