%% Tractor Contact with Ground
% 
% <<sm_tractor_row_crop_tire_Overview.png>>
% 
% This example explores methods for modeling the contact between the 
% tires and the ground for a row crop tractor.
% 
% For contact with uneven surfaces, point clouds and Magic Formula tire can
% be used. Point clouds enable multi-point contact and capturing the rugged
% profile of an offroad tire.  The Magic Formula Tire model can detect
% contact between the tire center plane and any surface it touches.  A
% weighted normal is calculated as the tire transitions between different
% segments of the surface.  This is much less computation than a point
% cloud.
%
% (<matlab:web('Tractor_Row_Crop_Overview.html') return to Row Crop Tractor Overview>)
%
% Copyright 2025 The MathWorks, Inc.

%% Model

open_system('sm_tractor_row_crop')

set_param(find_system('sm_tractor_row_crop','MatchFilter',@Simulink.match.allVariants,'FindAll', 'on','type','annotation','Tag','ModelFeatures'),'Interpreter','off')

%% Tractor Model
%
% The chassis, front and rear suspensions, and tires are modeled in this
% subsystem.  The driveshafts connecting to each wheel are combined into a
% Simscape Bus which connects to a separate powertrain model.  This allows
% us to combine this chassis model with any form of powertrain (two wheel
% drive, four wheel drive, and more).  
% 
% The Scene is also contained in this subsystem.  Flat and uneven terrain
% can be selected using variant subsystems.  The scene connects to the
% wheel center for lookup table-defined terrain, and the tire connects to
% the surface.

set_param('sm_tractor_row_crop/Tractor','LinkStatus','none')
open_system('sm_tractor_row_crop/Tractor','force')

%% Tire Model: Magic Formula
%
% This subsystem models the tire. The tire is connected to the terrain
% which can be flat or uneven.

set_param('sm_tractor_row_crop/Tractor/Wheel FL/Magic Formula','LinkStatus','none')
open_system('sm_tractor_row_crop/Tractor/Wheel FL/Magic Formula','force')

%% Tire Model: Point Cloud
%
% This subsystem models the tire. The tire is connected to the terrain
% which can be flat or uneven.  A point cloud models the geometry of the
% tire.

set_param('sm_tractor_row_crop/Tractor','popup_tire_type','Point Cloud')
set_param('sm_tractor_row_crop/Tractor/Wheel FL/Point Cloud','LinkStatus','none')
open_system('sm_tractor_row_crop/Tractor/Wheel FL/Point Cloud','force')


%% Simulation Results from Simscape Logging, Step Steer: Magic Formula
%
% The plot below shows the wheel speeds during the maneuver.  The
% rotational wheel speeds are scaled by the unloaded radius so they can be
% compared with the translational speed of the tractor. Additional plots
% below show tractor position, body roll angle, body pitch angle, and tire
% normal forces.
% 
% <<sm_tractor_row_crop_mechExp_StepSteer_MF.png>>

VehicleData = sm_tractor_row_crop_config_tire(bdroot,VehicleData,'Magic Formula');
set_param('sm_tractor_row_crop/Powertrain','popup_powertrain_config','Torque at Wheels');
sm_tractor_row_crop_config_maneuver('sm_tractor_row_crop',VehicleData,'stepsteer')
sim('sm_tractor_row_crop')

[~, resWspdMF] = sm_tractor_row_crop_plot1whlspd(...
    simlog_sm_tractor_row_crop,...
    logsout_sm_tractor_row_crop,...
    VehicleData.TireDataF.param.DIMENSION.UNLOADED_RADIUS,...
    VehicleData.TireDataR.param.DIMENSION.UNLOADED_RADIUS);

[~, resPvehMF] = sm_tractor_row_crop_plot2bodypos(simlog_sm_tractor_row_crop);
sm_tractor_row_crop_plot3bodytiremeas(logsout_sm_tractor_row_crop);

%% Simulation Results from Simscape Logging, Step Steer: Point Cloud, Cylinder
%
% The plot below shows the wheel speeds during the maneuver.  The
% rotational wheel speeds are scaled by the unloaded radius so they can be
% compared with the translational speed of the tractor. Additional plots
% below show tractor position, body roll angle, body pitch angle, and tire
% normal forces.
%
% <<sm_tractor_row_crop_mechExp_StepSteer_PCcyl.png>>

VehicleData = sm_tractor_row_crop_config_tire(bdroot,VehicleData,'Point Cloud Cylinder');
set_param('sm_tractor_row_crop/Powertrain','popup_powertrain_config','Torque at Wheels');
sm_tractor_row_crop_config_maneuver('sm_tractor_row_crop',VehicleData,'stepsteer')
sim('sm_tractor_row_crop')

[~, resWspdPC] = sm_tractor_row_crop_plot1whlspd(...
    simlog_sm_tractor_row_crop,...
    logsout_sm_tractor_row_crop,...
    VehicleData.TireDataF.param.DIMENSION.UNLOADED_RADIUS,...
    VehicleData.TireDataR.param.DIMENSION.UNLOADED_RADIUS);

[~, resPvehPC] = sm_tractor_row_crop_plot2bodypos(simlog_sm_tractor_row_crop);
sm_tractor_row_crop_plot3bodytiremeas(logsout_sm_tractor_row_crop);

%% Simulation Results from Simscape Logging, Step Steer: Point Cloud, Tread
%
% The plot below shows the wheel speeds during the maneuver.  The
% rotational wheel speeds are scaled by the unloaded radius so they can be
% compared with the translational speed of the tractor. Additional plots
% below show tractor position, body roll angle, body pitch angle, and tire
% normal forces.
%
% <<sm_tractor_row_crop_mechExp_StepSteer_PCtrd.png>>

VehicleData = sm_tractor_row_crop_config_tire(bdroot,VehicleData,'Point Cloud Tread');
set_param('sm_tractor_row_crop/Powertrain','popup_powertrain_config','Torque at Wheels');
sm_tractor_row_crop_config_maneuver('sm_tractor_row_crop',VehicleData,'stepsteer')
sim('sm_tractor_row_crop')

[~, resWspdPT] = sm_tractor_row_crop_plot1whlspd(...
    simlog_sm_tractor_row_crop,...
    logsout_sm_tractor_row_crop,...
    VehicleData.TireDataF.param.DIMENSION.UNLOADED_RADIUS,...
    VehicleData.TireDataR.param.DIMENSION.UNLOADED_RADIUS);

[~, resPvehPT] = sm_tractor_row_crop_plot2bodypos(simlog_sm_tractor_row_crop);
sm_tractor_row_crop_plot3bodytiremeas(logsout_sm_tractor_row_crop);

%% Simulation Results from Simscape Logging, Step Steer: Comparison
%
% Comparing the results of the three simulations, we see that the tractor
% follows nearly the same path. The radius of the circle is quite similar,
% with only a slight difference in where the center of the circle is.  The
% tractor starts turning slightly earlier with the Magic Formula Tire.
figure
plot(resWspdMF.t,resWspdMF.vFL,'LineWidth',2,'DisplayName','Magic Formula');
hold on
plot(resWspdPC.t,resWspdPC.vFL,'LineWidth',2,'DisplayName','Point Cloud Cylinder');
plot(resWspdPT.t,resWspdPT.vFL,'LineWidth',2,'DisplayName','Point Cloud Tread');
hold off
title('Wheel Speeds')
legend('Location','Best')
grid on
ylabel('Speed (m/s)')
xlabel('Time (s)')

figure
plot(resPvehMF.px,resPvehMF.py,'LineWidth',2,'DisplayName','Magic Formula');
hold on
plot(resPvehPC.px,resPvehPC.py,'LineWidth',2,'DisplayName','Point Cloud Cylinder');
plot(resPvehPT.px,resPvehPT.py,'--','LineWidth',2,'DisplayName','Point Cloud Tread');
hold off
title('Vehicle Position, World Coordinates')
legend('Location','Best')
axis equal
grid on
xlabel('X Position (m)')
ylabel('Y Position (m)')

%%

%clear all
close all
bdclose all
