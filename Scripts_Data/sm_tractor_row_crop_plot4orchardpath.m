function [fig_h,res] = sm_tractor_row_crop_plot4orchardpath(orchSurf,varargin)
% Code to plot simulation results from sm_tractor_row_crop
%% Plot Description:
%
% The plot below shows the position of the tractor during the maneuver.

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

gh1 = surf(orchSurf.x',orchSurf.y,orchSurf.h','LineWidth',0.1,'EdgeAlpha',0.1,'DisplayName','');axis equal
box on
title('Terrain for Tractor')
xlabel('x (m)')
ylabel('y (m)')
zlabel('z (m)')
axis equal
view(-2,17)

% If path data provided
if(nargin>=2)
    ManRes = varargin{1};
    Traj_xVeh = ManRes.Trajectory.x.Value;
    Traj_yVeh = ManRes.Trajectory.y.Value;
    Traj_zVeh = ManRes.Trajectory.z.Value;
    hold on
    gh2 = plot3(Traj_xVeh,Traj_yVeh,Traj_zVeh,'k-.','LineWidth',2,'DisplayName','Target');
    hold off
    legendset = gh2;
end
if(nargin>=3)
    simlogRes = varargin{2};
    simlog_xVeh = simlogRes.Tractor.Body_to_World.Body_World_Joint.Px.p.series.values;
    simlog_yVeh = simlogRes.Tractor.Body_to_World.Body_World_Joint.Py.p.series.values;
    simlog_zVeh = simlogRes.Tractor.Body_to_World.Body_World_Joint.Pz.p.series.values;
    hold on
    gh3 = plot3(simlog_xVeh,simlog_yVeh,simlog_zVeh,'r.','MarkerSize',2,'DisplayName','Driven');
    hold off
    text(0.05,0.05,['Final Position: ' sprintf('%3.2fm, %3.2fm, %3.2fm',simlog_xVeh(end),simlog_yVeh(end),simlog_zVeh(end))],'Color',[0.6 0.6 0.6],'Units','Normalized','VerticalAlignment','bottom')
    legendset = [gh2, gh3];
end
box on
title('Path Through Field')

res.px = simlog_xVeh;
res.py = simlog_yVeh;
res.pz = simlog_zVeh;

legend(legendset,'Location','Best')
view(-2,17)




