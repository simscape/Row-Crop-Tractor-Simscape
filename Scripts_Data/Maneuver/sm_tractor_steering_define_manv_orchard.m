function Maneuver = sm_tractor_steering_define_manv_orchard(orch_surf)

% Create waypoints for first pass in right-handed coordinate system
pass1.x = fliplr([592 576 561 539 524]+1);
pass1.y = -(fliplr([167 130 106 75 49]-1));

% Optional extension to first path
extraLen = 15;

% Calculate average angle for extension to pass
anglePass1 = atan2d(pass1.y(end)-pass1.y(1),pass1.x(end)-pass1.x(1));

% Extend first pass
dx = extraLen*cosd(anglePass1);
dy = extraLen*sind(anglePass1);
pass1.x = [pass1.x(1)-2*dx pass1.x(1)-1*dx pass1.x pass1.x(end)+1*dx];
pass1.y = [pass1.y(1)-2*dy pass1.y(1)-1*dy pass1.y pass1.y(end)+1*dy];

% Add additional passes
rowOffset    = 10;
returnOffset = 10;
pass2.x = fliplr(pass1.x-rowOffset*(cosd(anglePass1+90)));
pass2.y = fliplr(pass1.y-rowOffset*(sind(anglePass1+90)));

pass3.x = fliplr(pass2.x-rowOffset*(cosd(anglePass1+90)));
pass3.y = fliplr(pass2.y-rowOffset*(sind(anglePass1+90)));

pass4.x = fliplr(pass3.x-rowOffset*(cosd(anglePass1+90)));
pass4.y = fliplr(pass3.y-rowOffset*(sind(anglePass1+90)));

% Add waypoints to return to start
returnPth.x = [pass3.x(1) pass2.x(end) ]-returnOffset*(sind(anglePass1+90));
returnPth.y = [pass3.y(1) pass2.y(end) ]+returnOffset*(cosd(anglePass1+90));

returnPth.x = [returnPth.x (returnPth.x(end)*0.1+pass1.x(1)*0.9)];
returnPth.y = [returnPth.y (returnPth.y(end)*0.1+pass1.y(1)*0.9)];

% String waypoints together
pxset = [pass1.x pass2.x pass3.x pass4.x returnPth.x];
pyset = [pass1.y pass2.y pass3.y pass4.y returnPth.y];

% Use interpolation to add points to path
[xNew, yNew] = generatePathPoints(pxset, pyset, 400);

Maneuver.Trajectory.x.Value = xNew;
Maneuver.Trajectory.y.Value = yNew;

% Use 2D interpolation to get height
Maneuver.Trajectory.z.Value = ...
    interp2(orch_surf.y,orch_surf.x,orch_surf.h,...
    Maneuver.Trajectory.y.Value,Maneuver.Trajectory.x.Value);

% Add yaw angle to trajectory
yaw_interval = 1; % 10
x_ctr = Maneuver.Trajectory.x.Value;
y_ctr = Maneuver.Trajectory.y.Value;

aYaw = unwrap(atan2(...
    circshift(y_ctr,-yaw_interval)-circshift(y_ctr,+yaw_interval),...
    circshift(x_ctr,-yaw_interval)-circshift(x_ctr,+yaw_interval)));

Maneuver.Trajectory.aYaw.Value = aYaw;
Maneuver.Trajectory.xTrajectory.Value = cumsum([0 ...
    sqrt(abs(diff(Maneuver.Trajectory.x.Value)).^2+abs(diff(Maneuver.Trajectory.y.Value)).^2)]);

Maneuver.xPreview.x.Value = [0 5 10];
Maneuver.xPreview.v.Value = [0 5 10];
Maneuver.Type = 'Orchard_2Passes';

%% Create driver trajectory
traj_coeff.blend_distance = 80*0+15;     % m
traj_coeff.diff_exp       = 1.2;    % Curvature exponent
traj_coeff.diff_smooth    = 50/10*2;     % Diff smoothing number of points
traj_coeff.curv_smooth    = 100/50*16;    % Curvature smoothing number of points
traj_coeff.lim_smooth     = 300/25*2;    % Limit smoothing number of points
traj_coeff.target_shape_smooth = 100/10;  % Number of points for smoothing
traj_coeff.vmax           = 6;   % Max speed, m/s
traj_coeff.vmin           = 2;    % Min speed, m/s
traj_coeff.decimation     = 8/8;      % Decimation for interpolation

road_data.rx = x_ctr;
road_data.ry = y_ctr;
road_data.rz = Maneuver.Trajectory.z.Value;

Maneuver.Trajectory = sm_car_trajectory_calc(road_data,traj_coeff,false);

Maneuver.xMaxLat.Value    = 3;
Maneuver.vMinTarget.Value = 5;
Maneuver.vGain.Value      = 1;

Maneuver.nPreviewPoints.Value = 5;
Maneuver.nPreviewPoints.Units = '';
Maneuver.nPreviewPoints.Comments = 'For Pure Pursuit Driver';

end

function [xNew, yNew] = generatePathPoints(x, y, numPoints)
    % generatePathPoints generates an arbitrary set of points along a path
    % defined by a set of x-y locations.
    %
    % Inputs:
    %   x - vector of x coordinates of the original path
    %   y - vector of y coordinates of the original path
    %   numPoints - the number of points to generate along the path
    %
    % Outputs:
    %   xNew - vector of x coordinates of the generated points
    %   yNew - vector of y coordinates of the generated points

    % Check if the input vectors are of the same length
    if length(x) ~= length(y)
        error('Input vectors x and y must have the same length.');
    end
    
    % Calculate the cumulative distance along the path
    distances = [0, cumsum(sqrt(diff(x).^2 + diff(y).^2))];
    
    % Generate the new evenly spaced distances
    newDistances = linspace(0, distances(end), numPoints);
    
    % Interpolate to find the new x and y coordinates
    xNew = interp1(distances, x, newDistances, 'pchip');
    yNew = interp1(distances, y, newDistances, 'pchip');
end