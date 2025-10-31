function [fig_h, res] = sm_tractor_row_crop_plot2bodypos(simlogRes)
% Code to plot simulation results from sm_tractor_row_crop
%% Plot Description:
%
% The plot below shows the position of the vehicle during the maneuver.

% Copyright 2021-2025 The MathWorks, Inc.

% Reuse figure if it exists, else create new figure
figString = ['h1_' mfilename];
% Only create a figure if no figure exists
figExist = 0;
fig_hExist = evalin('base',['exist(''' figString ''')']);
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
simlog_xVeh = simlogRes.Tractor.Body_to_World.Body_World_Joint.Px.p.series.values;
simlog_yVeh = simlogRes.Tractor.Body_to_World.Body_World_Joint.Py.p.series.values;

% Plot results
plot(simlog_xVeh, simlog_yVeh, 'LineWidth', 1)
xlabel('X Position (m)')
ylabel('Y Position (m)')
title('Vehicle Position, World Coordinates')
grid on
axis equal
text(0.05,0.05,['Final Position: ' sprintf('%3.2fm, %3.2fm',simlog_xVeh(end),simlog_yVeh(end))],'Color',[0.6 0.6 0.6],'Units','Normalized')
res.px = simlog_xVeh;
res.py = simlog_yVeh;



