function sm_car_gen_driver_database (Vehicle)
% Define vehicle-level initial conditions for maneuvers
% Vehicle position, orientation, initial speed, initial wheel speed
%
% Copyright 2019-2024 The MathWorks, Inc.

%% Vehicle-level data
%   Vehicle Name         #Axles  Wheel Radius (m)    Init Z-Offset (m)

disp(['Generating DDatabase from ' mfilename]);

%% Default Driver - Sedan Hamba
veh_name = 'Tractor_Row_Crop';
drv.Lateral.NForward.Value          = 1;          % (no units) 
drv.Lateral.NReverse.Value          = 2.5;        % (no units)
drv.Lateral.xWheelbase.Value        = Vehicle.Body.FA - Vehicle.Body.RA;      % m
drv.Lateral.aMaxSteer.Value         = 80;         % deg
drv.Lateral.fSteerCutoff.Value      = 314.159265; % rad/s

drv.Long.mVehicle.Value             = Vehicle.Body.Mass;       % kg
drv.Long.FTractive.Value            = 17297;      % N
drv.Long.tDriver.Value              = 0.1;        % s
drv.Long.xPreview.Value             = 20;         % s
drv.Long.NDragRoll.Value            = 200;        % N       
drv.Long.NDragRollDriveline.Value   = 2.5;        % N/(m/s)
drv.Long.NDragAero.Value            = 0;          % N/(m^2/s^2)
drv.Long.gGravity.Value             = 9.80665;       % m/s^2
drv.Long.fAccelCutoff.Value         = 31.4159265; % 1/s
drv.Long.fBrakeCutoff.Value         = 31.4159265; % 1/s

drv.drvCycle.Long.Ki.Value          = 0;          % 1/s
drv.drvCycle.Long.Kp.Value          = 1;          % 1/s
drv.drvCycle.Filter.Reference.Value = 10.0;       % Hz
drv.drvCycle.Filter.Measured.Value  = 125.6637;      % Hz
drv.Vis.clr = [1 0.4 0.4];
drv.Vis.opc = 0.2*0;

Driver.(veh_name) = drv;
clear drv

%% List of Closed-Loop Maneuvers
% Maneuvers with longitudinal and lateral driver
cl_manv_longLat = {...
    'Orchard',...
    'Uneven_Road',...
    'Step_Steer'};

% Maneuvers with longitudinal driver only
cl_manv_longOnly = {...
    'Plateau';
    'RoughRoad'};

%% Assemble database of drivers - closed loop Long + Lat

% Get list of maneuver names (long + lat)
Mnames = cl_manv_longLat;
num_M  = length(Mnames);

% Get list of vehicle names
Vnames = fieldnames(Driver);
num_V  = size(Vnames,1);

% Loop over list of maneuvers
for Mi = 1:num_M
    % Loop over list of vehicles
	ManvName = Mnames{Mi};
    for Vi = 1:num_V
    	VehName = Vnames{Vi};
        % Add placeholder Units and Comments
        LoNames = fieldnames(Driver.(VehName).Long);
        for LOi = 1:length(LoNames)
            LoName = LoNames{LOi};
            % disp([ManvName ' ' VehName ' ' LoName]); % Debug
            Driver.(VehName).Long.(LoName).Units    = '';
            Driver.(VehName).Long.(LoName).Comments = '';
        end

        LaNames = fieldnames(Driver.(VehName).Lateral);
        for LOi = 1:length(LaNames)
            LaName = LaNames{LOi};
            Driver.(VehName).Lateral.(LaName).Units    = '';
            Driver.(VehName).Lateral.(LaName).Comments = '';
        end

        % Add Specific Units and Comments
        Driver.(VehName).Lateral.xWheelbase.Units    = 'm';
        Driver.(VehName).Lateral.xWheelbase.Comments = 'Vehicle.Chassis.Body.sAxle1.Value - Vehicle.Chassis.Body.sAxle(rear).Value';
        Driver.(VehName).Lateral.aMaxSteer.Units     = 'deg';
        Driver.(VehName).Lateral.fSteerCutoff.Units  = 'rad/s';

        Driver.(VehName).Long.mVehicle.Units         = 'kg';
        Driver.(VehName).Long.mVehicle.Comments      = 'Vehicle.Chassis.Body.m.Value';
        Driver.(VehName).Long.FTractive.Units        = 'N';
        Driver.(VehName).Long.tDriver.Units          = 's';
        Driver.(VehName).Long.xPreview.Units         = 'm';
        Driver.(VehName).Long.NDragRoll.Units        = 'N';
        Driver.(VehName).Long.NDragRollDriveline.Units = 'N*s/m';
        Driver.(VehName).Long.NDragAero.Units        = 'N*s^2/m^2';
        Driver.(VehName).Long.gGravity.Units         = 'm/s^2';
        Driver.(VehName).Long.fAccelCutoff.Units     = '1/s';
        Driver.(VehName).Long.fBrakeCutoff.Units     = '1/s';
        Driver.(VehName).Vis.clr = [1 0.4 0.4];
        Driver.(VehName).Vis.opc = 0.2*0;

        % Add to DDatabase
        DDatabase.(ManvName).(VehName).Long     = Driver.(VehName).Long;
        DDatabase.(ManvName).(VehName).Lateral  = Driver.(VehName).Lateral;
        DDatabase.(ManvName).(VehName).Type     = ManvName;
        DDatabase.(ManvName).(VehName).Instance = VehName;
        DDatabase.(ManvName).(VehName).Vis      = Driver.(VehName).Vis;    
    end
end


%% Assemble database of drivers - closed loop, longitudinal only

% Get list of maneuver names (long only)
Mnames = cl_manv_longOnly;
num_M  = length(Mnames);

% Get list of vehicle names
Vnames = fieldnames(Driver);
num_V  = size(Vnames,1);

% Loop over list of maneuvers
for Mi = 1:num_M
    % Loop over list of vehicles
	ManvName = Mnames{Mi};
    for Vi = 1:num_V
    	VehName = Vnames{Vi};

        % Add placeholder Units and Comments
        LoNames = fieldnames(Driver.(VehName).drvCycle.Long);
        for LOi = 1:length(LoNames)
            LoName = LoNames{LOi};
            Driver.(VehName).drvCycle.Long.(LoName).Units    = '';
            Driver.(VehName).drvCycle.Long.(LoName).Comments = '';
        end
        
        % Add placeholder Units and Comments
        FNames = fieldnames(Driver.(VehName).drvCycle.Filter);
        for Fi = 1:length(FNames)
            FName = FNames{Fi};
            Driver.(VehName).drvCycle.Filter.(FName).Units    = '';
            Driver.(VehName).drvCycle.Filter.(FName).Comments = '';
        end

        % Add Specific Units and Comments
        Driver.(VehName).drvCycle.Long.Ki.Comments   = 'Integral gain longitudinal driver';
        Driver.(VehName).drvCycle.Long.Kp.Comments   = 'Proportional gain longitudinal driver';

        Driver.(VehName).drvCycle.Filter.Reference.Units = 'Hz';
        Driver.(VehName).drvCycle.Filter.Measured.Units  = 'Hz';

        Driver.(VehName).Vis.clr = [1 0.4 0.4];
        Driver.(VehName).Vis.opc = 0.2*0;

        % Add to DDatabase
        DDatabase.(ManvName).(VehName).Long     = Driver.(VehName).drvCycle.Long;
        DDatabase.(ManvName).(VehName).Filter   = Driver.(VehName).drvCycle.Filter;
        DDatabase.(ManvName).(VehName).Type     = ManvName;
        DDatabase.(ManvName).(VehName).Instance = VehName;
        DDatabase.(ManvName).(VehName).Vis      = Driver.(VehName).Vis;                
    end
end
assignin('base','DDatabase',DDatabase);