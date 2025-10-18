function sm_tractor_row_crop_config_maneuver(mdl,VehicleData,tire_test)
% sm_tractor_row_crop_config_maneuver(mdl,VehicleData,tire_test)
%   Configure model and data structures to set up vehicle dynamics test
%
%   mdl           Name of Simulink model
%   VehicleData   Data structure with parameters for vehicle
%   tire_test     'stepsteer','plateau','rough road','orchard',
%                 'fourpasses','fourpassescurve','triangletwelvepasses'
%
% Copyright 2021-2024 The MathWorks, Inc.

DDatabase = evalin('base','DDatabase');

activePtrain = get_param([mdl '/Powertrain'],'LabelModeActiveChoice');

% Defaults for vehicle initial position in World coordinate frame
InitVehicle.Vehicle.px = 0;  % m
InitVehicle.Vehicle.py = 0;  % m
InitVehicle.Vehicle.pz = 0;  % m

% Defaults for vehicle initial translational velocity
% Represented in vehicle coordinates: 
%    +vx is forward, +vy is left, +vz is up in initial vehicle frame
InitVehicle.Vehicle.vx  = 20; %m/s
InitVehicle.Vehicle.vy  =  0;  %m/s
InitVehicle.Vehicle.vz  =  0;  %m/s

% Defaults for vehicle initial orientation
% Represented in vehicle coordinates, yaw-pitch-roll applied intrinsically
InitVehicle.Vehicle.yaw   = 0;  % rad
InitVehicle.Vehicle.pitch = 0;  % rad
InitVehicle.Vehicle.roll  = 0;  % rad

% Default is flat road surface in x-y plane
SceneData = evalin('base','SceneData');
SceneData.Reference.yaw   = 0 * pi/180;
SceneData.Reference.pitch = 0 * pi/180;
SceneData.Reference.roll  = 0 * pi/180;

road_surface_type = 'Flat';
stop_time  = '14';
steer_mode = 'Two-Wheel';
path_opacity = 0;
powetrain_enable = true;
targetSpeed = 0;

% Based on selected maneuver, modify driver inputs and scene
% For some maneuvers, initial state of vehicle is modified
switch lower(tire_test)
    case 'stepsteer'
        road_surface_type = 'Flat';
        driver_input = 'Step Steer';
        InitVehicle.Vehicle.vx  = 0;
        Driver = DDatabase.Step_Steer.Tractor_Row_Crop;
        powetrain_enable = true;
        targetSpeed = 5;
        stop_time = '20';                
    case 'plateau'
        driver_input = 'No Steer';
        road_surface_type = 'Plateau';
        InitVehicle.Vehicle.vx  = 0;
        powetrain_enable = true;
        Driver = DDatabase.Plateau.Tractor_Row_Crop;
        targetSpeed = 10;
        stop_time = '30';        
    case 'uneven road'
        driver_input = 'Closed Loop';
        road_surface_type = 'Uneven Road';
        InitVehicle.Vehicle.vx  = 0;
%        InitVehicle.Vehicle.px = 242;
%        InitVehicle.Vehicle.py = -4;
%        InitVehicle.Vehicle.pz = 0.5;
        InitVehicle.Vehicle.pitch = 0;  % rad
        InitVehicle.Vehicle.roll  = 0;  % rad
        InitVehicle.Vehicle.yaw   = -1.65*pi/180;  % rad
        powetrain_enable = true;
        Driver = DDatabase.Uneven_Road.Tractor_Row_Crop;
        MDO = evalin('base','MDatabase.Uneven_Road');
        InitVehicle.Vehicle.px  = MDO.Trajectory.x.Value(1);
        InitVehicle.Vehicle.py  = MDO.Trajectory.y.Value(1);
        InitVehicle.Vehicle.pz  = MDO.Trajectory.z.Value(1)+0.50;
%        InitVehicle.Vehicle.yaw =  MDO.Trajectory.aYaw.Value(1);
        evalin('base','Maneuver = MDatabase.Uneven_Road;');
        evalin('base','Init = IDatabase.Uneven_Road;');
        stop_time = '40';
        steer_mode = 'True Track';        
    case 'rough road'
        driver_input = 'No Steer';
        road_surface_type = 'Rough Road';
        InitVehicle.Vehicle.vx  = 0; %m/s
        Driver = DDatabase.RoughRoad.Tractor_Row_Crop;
        targetSpeed = 14;
        stop_time = '17';                
    case 'orchard'
        driver_input = 'Closed Loop';
        road_surface_type = 'Orchard';
        InitVehicle.Vehicle.vx  = 0; %m/s
        %orch_surf = sm_tractor_row_crop_sceneorchard;
        MDO = evalin('base','MDatabase.Orchard_2Passes');
        InitVehicle.Vehicle.px  = MDO.Trajectory.x.Value(1);
        InitVehicle.Vehicle.py  = MDO.Trajectory.y.Value(1);
        InitVehicle.Vehicle.pz  = MDO.Trajectory.z.Value(1);
        InitVehicle.Vehicle.yaw =  MDO.Trajectory.aYaw.Value(1);

        evalin('base','Maneuver = MDatabase.Orchard_2Passes;');
        evalin('base','Init = IDatabase.Orchard_2Passes;');
        stop_time = '200';
        steer_mode = 'True Track';
        path_opacity = 1;
        Driver = DDatabase.Orchard.Tractor_Row_Crop;
    case 'fourpasses'
        driver_input = 'Closed Loop';
        road_surface_type = 'Flat';
        InitVehicle.Vehicle.vx  = 0; %m/s
        evalin('base','Maneuver = MDatabase.Passes4_Loop;');
        evalin('base','Init = IDatabase.Passes4_Loop;');
        stop_time = '95';
        steer_mode = 'True Track';
        path_opacity = 1;
        Driver = DDatabase.Orchard.Tractor_Row_Crop;        
    case 'fourpassescurve'
        driver_input = 'Closed Loop';
        road_surface_type = 'Flat';
        InitVehicle.Vehicle.vx  = 0; %m/s
        evalin('base','Maneuver = MDatabase.Passes4Curve_Loop;');
        evalin('base','Init = IDatabase.Passes4Curve_Loop;');
        stop_time = '95';
        steer_mode = 'True Track';
        path_opacity = 1;
        Driver = DDatabase.Orchard.Tractor_Row_Crop;        
    case 'triangletwelvepasses'
        driver_input = 'Closed Loop';
        road_surface_type = 'Flat';
        InitVehicle.Vehicle.vx  = 0; %m/s
        evalin('base','Maneuver = MDatabase.Triangle_12Passes;');
        evalin('base','Init = IDatabase.Triangle_12Passes;');
        stop_time = '95';
        steer_mode = 'True Track';
        path_opacity = 1;
        Driver = DDatabase.Orchard.Tractor_Row_Crop;        
    otherwise
        error('Maneuver type not found')
end

% Configure scene and driver input
vehBlkParam = get_param([mdl '/Tractor'], 'DialogParameters');
if(isfield(vehBlkParam, 'popup_road_surface'))
    set_param([mdl '/Tractor'],'popup_road_surface',road_surface_type);
end

% Set driver control and rear steering mode
set_param([mdl '/Control'],'popup_steer_control',driver_input);
set_param([mdl '/Control'],'popup_steer_mode',steer_mode);
if(~strcmp(activePtrain,'CVT'))
    set_param([mdl '/Powertrain/' activePtrain],'checkbox_torque_source',powetrain_enable);
end
% Set event stop time
set_param(mdl,'StopTime',stop_time);

% Set initial position and speed of vehicle and wheels
InitVehicle.Wheel.wFL = InitVehicle.Vehicle.vx/VehicleData.TireDataF.param.DIMENSION.UNLOADED_RADIUS; %rad/s
InitVehicle.Wheel.wFR = InitVehicle.Vehicle.vx/VehicleData.TireDataF.param.DIMENSION.UNLOADED_RADIUS; %rad/s
InitVehicle.Wheel.wRL = InitVehicle.Vehicle.vx/VehicleData.TireDataR.param.DIMENSION.UNLOADED_RADIUS; %rad/s
InitVehicle.Wheel.wRR = InitVehicle.Vehicle.vx/VehicleData.TireDataR.param.DIMENSION.UNLOADED_RADIUS; %rad/s

% Update structures in MATLAB workspace
assignin('base',"InitVehicle",InitVehicle)
SceneData.path_opacity = path_opacity;
assignin('base',"SceneData",SceneData)
%assignin('base','path_opacity',path_opacity);
assignin('base',"Driver",Driver)
assignin('base',"targetSpeed",targetSpeed)

