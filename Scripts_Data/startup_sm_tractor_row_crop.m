%% Copyright 2025 The MathWorks, Inc.

% Parameters
sm_tractor_row_crop_param   % Vehicle
sm_tractor_row_crop_scene   % Scene
sm_tractor_row_crop_visual  % Visual

HMPST = sm_tractor_row_crop_params_cvt(VehicleData); % CVT
stopTime = 70;

% Load database
MDatabase = sm_tractor_row_crop_load_maneuvers(SceneData);

% Load simple chassis geometry extrusion data 
load chassis_extr_data

% Load driver model parameters
%sm_tractor_steering_define_driver
sm_car_gen_driver_database(VehicleData)

% Select maneuver
IDatabase = sm_tractor_steering_define_init(MDatabase);
Maneuver = MDatabase.Passes4_Loop;
%Init     = IDatabase.Passes4_Loop;

% Open model
open_start_content = 1;

% If running in a parallel pool
% do not open model or demo script
if(~isempty(ver('parallel')))
    if(~isempty(getCurrentTask()))
        open_start_content = 0;
    end
end

if(open_start_content)
    % Open model and demo script
    sm_tractor_row_crop
    web('Tractor_Row_Crop_Overview.html');
end
clear open_start_content