function Maneuver = sm_tractor_steering_path2maneuver(Maneuver)

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
%Maneuver.Type = 'Passes4_Loop';

%% Create driver trajectory
traj_coeff.blend_distance = 80*0+10;     % m
traj_coeff.diff_exp       = 1.9;    % Curvature exponent
traj_coeff.diff_smooth    = 50/10*2;     % Diff smoothing number of points
traj_coeff.curv_smooth    = 100/50*16;    % Curvature smoothing number of points
traj_coeff.lim_smooth     = 300/25*2;    % Limit smoothing number of points
traj_coeff.target_shape_smooth = 100/10;  % Number of points for smoothing
traj_coeff.vmax           = 6;   % Max speed, m/s
traj_coeff.vmin           = 3;    % Min speed, m/s
traj_coeff.decimation     = 8/8;      % Decimation for interpolation

road_data.rx = x_ctr;
road_data.ry = y_ctr;
road_data.rz = x_ctr*0;

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