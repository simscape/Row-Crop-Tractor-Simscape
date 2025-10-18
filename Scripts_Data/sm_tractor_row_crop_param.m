% Parameters for example sm_tractor_row_crop.slx
% Copyright 2025 The MathWorks, Inc.

% Vehicle body parameters
% Vehicle reference point is point directly between 
%         tire contact patches on front wheels
VehicleData.Body.FA = 0;               % m
VehicleData.Body.RA = -2.551;% %-1.3155-1.2575;              % m
VehicleData.Body.CG = [-1.5 0 0.6147]; % m
VehicleData.Body.Geo2FARef.x =  1.3155; % tractorsk.chassis.fa.x
VehicleData.Body.Geo2FARef.z =  0.6215; % tractorsk.chassis.fa.wctr.z
VehicleData.Body.Geo2Ref.y   =  0.0145; % tractorsk.ref.offset.y
VehicleData.Body.Geo2RARef.x = -1.2575; % tractorsk.chassis.ra.x
VehicleData.Body.Geo2RARef.z =  0.8230; % tractorsk.chassis.ra.wctr.z
VehicleData.Body.Mass          = 1600;            % kg
VehicleData.Body.Inertias      = [600 3000 3200]/2; % kg*m^2
VehicleData.Body.Color     = [0.4 0.6 1.0]; % RGB
VehicleData.Body.Color_2   = [0.87 0.57 0.14]; % RGB
VehicleData.Body.Opacity = 1.0;
VehicleData.Body.Ref2Steer.p = [-1.230    0.0145*0    2.0670];%[-1.5575 0.0145 2]; % m
VehicleData.Body.Ref2Steer.q = -50; % deg
VehicleData.Steer.handPos.r = 0.185; % m
VehicleData.Steer.handPos.q = 10; % deg
% Front suspension parameters
% Two degrees of freedom for axle (heave, roll), spin DOF for wheels
% Ackermann steering
VehicleData.SuspF.Heave.Stiffness = 40000;  % N/m
VehicleData.SuspF.Heave.Damping   = 3500;   % N/m
VehicleData.SuspF.Heave.EqPos     = -0.2;   % m
VehicleData.SuspF.Heave.Height    = 0.1647*0; % m
VehicleData.SuspF.Roll.Stiffness  = 66000;  % N*m/rad
VehicleData.SuspF.Roll.Damping    = 2050*5;   % N*m/(rad/s)
VehicleData.SuspF.Roll.Height     = 0.0647*0; % m
VehicleData.SuspF.Roll.EqPos      = 0;      % rad

% Separation of wheels on this axle
VehicleData.SuspF.Track           = 1.845;%0.9355*2;    % m tractorsk.chassis.fa.wctr.y

% Unsprung mass - radius and length for visualization only
VehicleData.SuspF.UnsprungMass.Mass = 95;         % kg
VehicleData.SuspF.UnsprungMass.Inertia = [1 1 1]; % kg*m^2
VehicleData.SuspF.UnsprungMass.Height = 0.6215;    % m
VehicleData.SuspF.UnsprungMass.Radius = 0.1;      % m
VehicleData.SuspF.UnsprungMass.Length = 1.6;      % m

% Hub height should be synchronized with tire parameters
VehicleData.TireDataF.filename = 'KT_MF_Tool_460_60_R28.tir';
VehicleData.TireDataF.param    = simscape.multibody.tirread(which(VehicleData.TireDataF.filename));

% Generate cylindrical point cloud for front tire
% Save within data structure
nptsCylFront = 500;
VehicleData.TireDataF.ptcld_cyl   = Point_Cloud_Data_Cylinder(...
    VehicleData.TireDataF.param.DIMENSION.UNLOADED_RADIUS,...
    VehicleData.TireDataF.param.DIMENSION.WIDTH,nptsCylFront,false);
clear nptsCylFront

% Generate tread-aligned point cloud for front tire
% Save within data structure
[ptcld_loc,ptcld_hull] = sm_tractor_row_crop_ptcld_tiretread('Wheel_FL_Tire.stl',[1 3],0.52*100,[3 1 2]);
VehicleData.TireDataF.ptcld_tread    = ptcld_hull*1e-2; % Convert cm to m;
VehicleData.TireDataF.ptcld_treadLoc = ptcld_loc *1e-2; % Convert cm to m;
clear ptcld_hull ptcld_loc

% Select point cloud for use in model
% Can swap by copying in other data set
VehicleData.TireDataF.ptcld = VehicleData.TireDataF.ptcld_tread;

VehicleData.SuspF.Hub.Height   = 0.6235;%VehicleData.TireDataF.param.DIMENSION.UNLOADED_RADIUS; % m
% Rim mass and inertia typically not part of .tir file
VehicleData.RimF.Mass          = 10;    % kg
VehicleData.RimF.Inertia       = [1 2]; % kg*m^2

VehicleData.SuspF.SteerRatio = 16; % m

% Rear suspension parameters
% Two degrees of freedom for axle (heave, roll), spin DOF for wheels
VehicleData.SuspR.Heave.Stiffness  = 50000;  % N/m
VehicleData.SuspR.Heave.Damping    = 3500;   % N/m
VehicleData.SuspR.Heave.EqPos      = -0.16;  % m
VehicleData.SuspR.Heave.Height     = 0.1647*0; % m
VehicleData.SuspR.Roll.Stiffness   = 27500*2;  % N*m/rad
VehicleData.SuspR.Roll.Damping     = 2050*5;   % N*m/(rad/s)
VehicleData.SuspR.Roll.Height      = 0.1147*0; % m
VehicleData.SuspR.Roll.EqPos       = 0;      % rad

% Separation of wheels on this axle
VehicleData.SuspR.Track            = 1.839+0.319;%0.9195*2;    % m  %tractorsk.chassis.ra.wctr.y/2

% Unsprung mass - radius and length for visualization only
VehicleData.SuspR.UnsprungMass.Mass    = 90;      % kg
VehicleData.SuspR.UnsprungMass.Inertia = [1 1 1]; % kg*m^2
VehicleData.SuspR.UnsprungMass.Height  = 0.8230;   % m
VehicleData.SuspR.UnsprungMass.Length  = 1.6;     % m
VehicleData.SuspR.UnsprungMass.Radius  = 0.1;     % m

% Hub height should be synchronized with tire parameters
VehicleData.TireDataR.filename = 'KT_MF_Tool_550_70_R35.tir';
VehicleData.TireDataR.param    = simscape.multibody.tirread(which(VehicleData.TireDataR.filename));

% Generate cylindrical point cloud for rear tire
% Save within data structure
nptsCylRear = 700; % Requested, actual number will differ to achieve even spacing
VehicleData.TireDataR.ptcld_cyl = Point_Cloud_Data_Cylinder(...
    VehicleData.TireDataR.param.DIMENSION.UNLOADED_RADIUS,...
    VehicleData.TireDataR.param.DIMENSION.WIDTH,nptsCylRear,false);
clear nptsCylRear

% Generate tread-aligned point cloud for rear tire
% Save within data structure
[ptcld_loc,ptcld_hull] = sm_tractor_row_crop_ptcld_tiretread('Wheel_RL_Tire.stl',[1 3],0.68*100,[3 1 2]);

VehicleData.TireDataR.ptcld_tread    = ptcld_hull*1e-2; % Convert cm to m
VehicleData.TireDataR.ptcld_treadLoc = ptcld_loc *1e-2; % Convert cm to m
clear ptcld_hull ptcld_loc

% Select point cloud for use in model
% Can swap by copying in other data set
VehicleData.TireDataR.ptcld = VehicleData.TireDataR.ptcld_tread;

VehicleData.SuspR.Hub.Height   = 0.819;%VehicleData.TireDataR.param.DIMENSION.UNLOADED_RADIUS; % m


% Rim mass and inertia typically not part of .tir file
VehicleData.RimR.Mass          = 10;    % kg
VehicleData.RimR.Inertia       = [1 2]; % kg

VehicleData.SuspR.SteerRatio = 16; % m

VehicleData.Body.Antenna1Offset = [ -1.96      -0.68   3.02];   % m

% Point Cloud Contact parameters
% Note: Parameters set for fast simulation with variable step solver and to
% mimic behavior seen with Magic Formula Tire parameters used in this
% example. 
% * Damping (ptcld_b) reduced until required drive torque matches
% * Critical Velocity (ptcld_vth) set very high to
%       avoid very stiff friction law near transition velocity
VehicleData.TireDataR.ptcld_k  = 1e4;
VehicleData.TireDataR.ptcld_b  = 1e3*0.01;
VehicleData.TireDataR.ptcld_tw = 1e-2;
VehicleData.TireDataR.ptcld_mus = 0.5+0.4;
VehicleData.TireDataR.ptcld_mud = 0.3+0.2+0.4;
VehicleData.TireDataR.ptcld_vth = 1e-2*100;
VehicleData.TireDataF.ptcld_k  = 1e4;
VehicleData.TireDataF.ptcld_b  = 1e3*0.01;
VehicleData.TireDataF.ptcld_tw = 1e-2;
VehicleData.TireDataF.ptcld_mus = 0.5+0.4;
VehicleData.TireDataF.ptcld_mud = 0.3+0.2+0.4;
VehicleData.TireDataF.ptcld_vth = 1e-2*100;


% Human
VehicleData.Human.jointElbow.q0 = 50; % deg
VehicleData.Human.jointElbow.k  = 1;
VehicleData.Human.jointElbow.b  = 1;
VehicleData.Human.jointTorso.x.q0 = 0; % deg
VehicleData.Human.jointTorso.x.k  = 50;
VehicleData.Human.jointTorso.x.b  = 5;
VehicleData.Human.jointTorso.y.q0 = 17; % deg
VehicleData.Human.jointTorso.y.qeq = 17; % deg
VehicleData.Human.jointTorso.y.k  = 50;
VehicleData.Human.jointTorso.y.b  = 5;
VehicleData.Human.jointTorso.z.q0 = 0; % deg
VehicleData.Human.jointTorso.z.k  = 50;
VehicleData.Human.jointTorso.z.b  = 5;
VehicleData.Human.rho.Value = 1000;
VehicleData.Human.sCG.Value = [0 0 0];

VehicleData.Seat.Susp.HeaveLinear.heavexeq = 0.25;
VehicleData.Seat.Susp.HeaveLinear.heavek   = 4000;
VehicleData.Seat.Susp.HeaveLinear.heaveb   = 600;
VehicleData.Seat.Ref2Seat.p = [-1.8075    0.0145    1.8300]; % m
VehicleData.Seat.xOffset = 0.1; % m

%% Maneuver data
% Sine with Dwell

swd.tDelay = 3;
swd.tvec   = 0:0.01:10;
swd.Amplitude = 116 *(pi/180);
swd.HalfPeriod = 0.7;
swd.DwellDuration = 0.5;
swd.aStrWheel = ...
    swd.Amplitude*(sin(2*pi*swd.HalfPeriod*(swd.tvec-swd.tDelay)).*...
    (swd.tvec>=swd.tDelay & swd.tvec<=(swd.tDelay+3/4*1/swd.HalfPeriod)) ...
    + -1.*(swd.tvec>(swd.tDelay+3/4*1/swd.HalfPeriod) & swd.tvec<(swd.tDelay+swd.DwellDuration+3/4*1/swd.HalfPeriod)) ...
    + sin(2*pi*swd.HalfPeriod*(swd.tvec-swd.tDelay-swd.DwellDuration)).*(swd.tvec>=(swd.tDelay+swd.DwellDuration+3/4*1/swd.HalfPeriod) & swd.tvec<=(swd.tDelay+swd.DwellDuration+1/swd.HalfPeriod)));

Maneuver.SineWithDwell = swd;
clear swd

% Parking
Maneuver.Parking.Steer.tvec         = [0 1   3   6  7   7.3   8.6  9  10];
Maneuver.Parking.Steer.aSteerWheel  = [0 0 400 400  0 -90   -90    0   0]*pi/180;

Maneuver.Parking.Wheel.tvec  = [0 4 5  6  7  8  9  10];
Maneuver.Parking.Wheel.trqFL = [0 0 5  10 12 15 15 15]*35;
Maneuver.Parking.Wheel.trqFR = Maneuver.Parking.Wheel.trqFL;

%% Camera data
Camera =  sm_vehicle_camera_frames_tractor;
