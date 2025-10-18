%% Tractor Driving on Uneven Ground
% 
% <<sm_tractor_row_crop_uneven_terrain_Overview.png>>
% 
% This example shows how to measure the impact of seat suspension on the
% operator while driving on very rough terrain.
% 
% Uneven terrain can be defined using a grid surface, which consists of a
% vector of x points, y points, and a 2D matrix of z-points.  The grid
% surface block can be connected directly to the Magic Formula Tire block
% which models the contact between the tire and the road.  In this example,
% we drive the tractor on uneven terrain and measure the vertical
% acceleration of the operator's head.
%
% (<matlab:web('Tractor_Row_Crop_Overview.html') return to Row Crop Tractor Overview>)
%
% Copyright 2025 The MathWorks, Inc.

%% Model

open_system('sm_tractor_row_crop')

set_param(find_system('sm_tractor_row_crop','MatchFilter',@Simulink.match.allVariants,'FindAll', 'on','type','annotation','Tag','ModelFeatures'),'Interpreter','off')
sm_tractor_row_crop_config_maneuver('sm_tractor_row_crop',VehicleData,'Uneven Road')
set_param('sm_tractor_row_crop/Tractor','popup_operator','Human, Suspension');

%% Tractor Model
%
% The chassis, front and rear suspensions, and tires are modeled in this
% subsystem.  The driveshafts connecting to each wheel are combined into a
% Simscape Bus which connects to a separate powertrain model.  This allows
% us to combine this chassis model with any form of powertrain (two wheel
% drive, four wheel drive, and more).  
% 

set_param('sm_tractor_row_crop/Tractor','LinkStatus','none')
open_system('sm_tractor_row_crop/Tractor','force')

%% Tire Model: Magic Formula
%
% This subsystem models the tire. The tire is connected to the terrain
% which can be flat or uneven.

set_param('sm_tractor_row_crop/Tractor/Wheel FL/Magic Formula','LinkStatus','none')
open_system('sm_tractor_row_crop/Tractor/Wheel FL/Magic Formula','force')

%% Terrain Model: Grid Surface
%
% A Grid Surface block is used to model the uneven terrain.

set_param('sm_tractor_row_crop/Tractor/Scene/Uneven Road','LinkStatus','none')
open_system('sm_tractor_row_crop/Tractor/Scene/Uneven Road','force')

%% Operator Model
%
% The operator can be modeled as a human with joints at the hips,
% shoulders, elbows, and wrists. The suspension for the seat can be
% configured as rigid or as a linear spring damper.

set_param('sm_tractor_row_crop/Tractor/Body/Operator','LinkStatus','none')
open_system('sm_tractor_row_crop/Tractor/Body/Operator','force')


%% Simulation Results from Simscape Logging, Uneven Road: No Seat Suspension
%
% In this test, the tractor is driven on the uneven road and the operator
% is on a seat with no suspension. The vertical acceleration of the rear
% axle and the operator are plotted.  While there is some attentuation of
% the acceleration via the vehicle suspension and the operators body, much
% of the vertical acceleration is felt by the driver.

VehicleData = sm_tractor_row_crop_config_tire(bdroot,VehicleData,'Magic Formula');
set_param('sm_tractor_row_crop/Powertrain','popup_powertrain_config','Torque at Wheels');
sm_tractor_row_crop_config_maneuver('sm_tractor_row_crop',VehicleData,'Uneven Road')
set_param('sm_tractor_row_crop/Tractor','popup_operator','Human, Rigid Seat');
sim('sm_tractor_row_crop')

[~, resRigid] = sm_tractor_row_crop_plot5operator(logsout_sm_tractor_row_crop);

%% Simulation Results from Simscape Logging, Uneven Road: With Seat Suspension
%
% In this test, the tractor is driven on the uneven road and the operator
% is on a seat with a suspension. The vertical acceleration of the rear
% axle and the operator are plotted.  The seat suspension attentuates a
% good portion of acceleration transmitted to the chassis through the suspension.

VehicleData = sm_tractor_row_crop_config_tire(bdroot,VehicleData,'Magic Formula');
set_param('sm_tractor_row_crop/Powertrain','popup_powertrain_config','Torque at Wheels');
sm_tractor_row_crop_config_maneuver('sm_tractor_row_crop',VehicleData,'Uneven Road')
set_param('sm_tractor_row_crop/Tractor','popup_operator','Human, Suspension');
sim('sm_tractor_row_crop')

[~, resSusp] = sm_tractor_row_crop_plot5operator(logsout_sm_tractor_row_crop);

%% Simulation Results from Simscape Logging, Step Steer: Comparison
%
% Comparing the results of the two tests, we can see the impact of the seat
% suspension on the comfort of the operator.

figure
plot(resRigid.t,resRigid.gzRA,'DisplayName','Rear Axle');
hold on
plot(resRigid.t,resRigid.gzOp,'DisplayName','Operator, Rigid Seat');
plot(resSusp.t,resSusp.gzOp,'DisplayName','Operator, Suspended Seat');
hold off
title('Vertical Accleration')
legend('Location','Best')
grid on
ylabel('Acceleration (m/s^2)')
xlabel('Time (s)')

%%

%clear all
close all
bdclose all
