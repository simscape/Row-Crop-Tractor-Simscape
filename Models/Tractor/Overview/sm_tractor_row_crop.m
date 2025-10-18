%% Tractor on Uneven Terrain
% 
% <<sm_tractor_row_crop_mechExp_orchard.png>>
% 
% This example models a row crop tractor on uneven terrain.  The scene,
% driver inputs and rear wheel steering option can be selected.
% 
% The tractor model includes a six degree-of-freedom body model, two
% axles each with heave and roll degrees of freedom, and four wheels that
% rotate.  The front and rear wheels are steered using the Ackermann steering
% equation.  Many of the tractor parameters can be modified using MATLAB.
%
% The tire model is the Magic Formula Tire Force and Torque block from
% Simscape Multibody.  You can plot the forces and torques at the contact
% patch from the simulation results.
%
% (<matlab:web('Tractor_Row_Crop_Overview.html') return to Row Crop Tractor Overview>)
%
% *Acknowledgements:* MathWorks would like to thank M V Krishna Teja, PhD,
% <https://prof-rkkumar.wixsite.com/iitm-vpg-lab Virtual Proving Ground and
% Simulation Lab>, Raghupati Singhania Centre of Excellence at the Indian
% Institute of Technology, Madras for providing the tire parameters for
% this example.
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

%% Tire Model
%
% This subsystem models the tire. The tire is connected to the terrain
% which can be flat or uneven.

set_param('sm_tractor_row_crop/Tractor/Wheel FL/Magic Formula','LinkStatus','none')
open_system('sm_tractor_row_crop/Tractor/Wheel FL/Magic Formula','force')

%% Powertrain: Torque at Wheels
%
% In this variant, torque is applied at all four wheels directly.  This
% abstract model of the powertrain runs very quickly for all the
% complexities of the engine, transmission, and drivetrain have been
% omitted.  This option assumes the engine, transmission and drivetrain are
% all performing as designed and is very simple to parameterize.

set_param('sm_tractor_row_crop/Powertrain','popup_powertrain_config','Torque at Wheels');
set_param('sm_tractor_row_crop/Powertrain/Torque4','LinkStatus','none')
open_system('sm_tractor_row_crop/Powertrain/Torque4','force')
set_param('sm_tractor_row_crop','SimulationCommand','update')

%% Powertrain: Torque at Transmission Output
%
% The engine is modeled as an ideal torque source that can meet any request
% for torque. The torque is applied to the shaft representing the output of
% the transmission.  Torque is transmitted to all four wheels via the
% drivetrain.

set_param('sm_tractor_row_crop/Powertrain','popup_powertrain_config','Torque at Transmission Output');
set_param('sm_tractor_row_crop/Powertrain/Torque1','LinkStatus','none')
open_system('sm_tractor_row_crop/Powertrain/Torque1','force')
set_param('sm_tractor_row_crop','SimulationCommand','update')

%%
% This subsystem models the driveshafts that connect the output of the
% transmission to all wheels in a four-wheel drive configuration.
set_param('sm_tractor_row_crop/Powertrain/Torque1/Driveline','LinkStatus','none')
open_system('sm_tractor_row_crop/Powertrain/Torque1/Driveline','force')

%% Powertrain
%
% The tractor is powered by an engine.  The continuously variable
% transmission varies its ratio to drive the vehicle at the desired speed.

set_param('sm_tractor_row_crop/Powertrain','popup_powertrain_config','CVT Abstract');
set_param('sm_tractor_row_crop/Powertrain/CVT','LinkStatus','none')
open_system('sm_tractor_row_crop/Powertrain/CVT','force')
set_param('sm_tractor_row_crop','SimulationCommand','update')

%% Powertrain Variants
%
% Four options for modeling the CVT are included in the model.  Using
% variant subsystems, one of them can be activated for a test.  The
% subsystems all have the same interface, which includes a mechanical
% connection to the engine and a mechanical connection to the driveline.
% Intefaces based on physical connections are particularly well-suited to
% swapping between models of different technologies or fidelity.

set_param('sm_tractor_row_crop/Powertrain','popup_powertrain_config','CVT Abstract');
set_param('sm_tractor_row_crop/Powertrain/CVT/Transmission','LinkStatus','none')
open_system('sm_tractor_row_crop/Powertrain/CVT/Transmission','force')

%% Powertrain: CVT Abstract
%
% Models a CVT as a variable ratio gear. This model can be used in early
% stages of development to refine requirements for the transmission.  It
% can also be tuned to match a more detailed model of the CVT so as to
% provide accurate behavior with less computation.
%
set_param('sm_tractor_row_crop/Powertrain/CVT/Transmission/Abstract','LinkStatus','none')
open_system('sm_tractor_row_crop/Powertrain/CVT/Transmission/Abstract','force')
set_param('sm_tractor_row_crop','SimulationCommand','update')


%% Powertrain: CVT Hydrostatic
%
% Hydrostatic transmission with variable-displacement pump and
% fixed-displacement motor.  This system alone can also serve as a CVT, but
% it is not as efficient as the power-split design, as the mechanical path
% has a higher efficiency.
%

set_param('sm_tractor_row_crop/Powertrain','popup_powertrain_config','CVT Hydrostatic');
set_param('sm_tractor_row_crop/Powertrain/CVT/Transmission/Hydrostatic','LinkStatus','none')
open_system('sm_tractor_row_crop/Powertrain/CVT/Transmission/Hydrostatic','force')
set_param('sm_tractor_row_crop','SimulationCommand','update')

%% Powertrain: CVT Electrical
%
% Electrical transmission with generator, motor, and battery.  A control
% system adjusts the power flow between the motor and the generator.  The
% control system enables these components to act as a variable ratio
% transmission.
%

set_param('sm_tractor_row_crop/Powertrain','popup_powertrain_config','CVT Electrical');
set_param('sm_tractor_row_crop/Powertrain/CVT/Transmission/Electrical','LinkStatus','none')
open_system('sm_tractor_row_crop/Powertrain/CVT/Transmission/Electrical','force')
set_param('sm_tractor_row_crop','SimulationCommand','update')

%% Powertrain: CVT Power Split Hydromechanical
%
% Transmission with four planetary gears, clutches, and a parallel power
% path through a hydrostatic transmission. A hydraulic regenerative braking
% system is also included to improve fuel economy by storing kinetic energy
% as pressure in an accumulator.
%

set_param('sm_tractor_row_crop/Powertrain','popup_powertrain_config','CVT Power Split HM');
set_param('sm_tractor_row_crop/Powertrain/CVT/Transmission/Power Split Hydromech','LinkStatus','none')
open_system('sm_tractor_row_crop/Powertrain/CVT/Transmission/Power Split Hydromech','force')
set_param('sm_tractor_row_crop','SimulationCommand','update')


%% Simulation Results from Simscape Logging, Step Steer
%%
%
% The plot below shows the wheel speeds during the maneuver.  The
% rotational wheel speeds are scaled by the unloaded radius so they can be
% compared with the translational speed of the tractor. Additional plots
% below show tractor position, body roll angle, body pitch angle, and tire
% normal forces.

set_param('sm_tractor_row_crop/Powertrain','popup_powertrain_config','Torque at Wheels');
sm_tractor_row_crop_config_maneuver('sm_tractor_row_crop',VehicleData,'stepsteer')
sim('sm_tractor_row_crop')

sm_tractor_row_crop_plot1whlspd(...
    simlog_sm_tractor_row_crop,...
    logsout_sm_tractor_row_crop,...
    VehicleData.TireDataF.param.DIMENSION.UNLOADED_RADIUS,...
    VehicleData.TireDataR.param.DIMENSION.UNLOADED_RADIUS);

sm_tractor_row_crop_plot2bodypos(simlog_sm_tractor_row_crop);
sm_tractor_row_crop_plot3bodytiremeas(logsout_sm_tractor_row_crop);


%% Simulation Results from Simscape Logging, Plateau
%%
% In this maneuver, the tractor drives up a hill and down the other side.
% Additional plots below show body roll angle, body pitch angle, and tire
% normal forces.
%

sm_tractor_row_crop_config_maneuver('sm_tractor_row_crop',VehicleData,'plateau')
sim('sm_tractor_row_crop')

sm_tractor_row_crop_plot_grid_surface('Plateau');

sm_tractor_row_crop_plot1whlspd(...
    simlog_sm_tractor_row_crop,...
    logsout_sm_tractor_row_crop,...
    VehicleData.TireDataF.param.DIMENSION.UNLOADED_RADIUS,...
    VehicleData.TireDataR.param.DIMENSION.UNLOADED_RADIUS);
sm_tractor_row_crop_plot3bodytiremeas(logsout_sm_tractor_row_crop);

%% Simulation Results from Simscape Logging, Rough Road
%%
% In this maneuver, the tractor is in motion at the start of the
% simulation.  It drives along an uneven road which exercises the
% suspension and causes the car to pitch and roll. Additional plots below
% show body roll angle, body pitch angle, and tire normal forces.
%

sm_tractor_row_crop_config_maneuver('sm_tractor_row_crop',VehicleData,'rough road')
sim('sm_tractor_row_crop')

sm_tractor_row_crop_plot_grid_surface('Rough Road');

sm_tractor_row_crop_plot1whlspd(...
    simlog_sm_tractor_row_crop,...
    logsout_sm_tractor_row_crop,...
    VehicleData.TireDataF.param.DIMENSION.UNLOADED_RADIUS,...
    VehicleData.TireDataR.param.DIMENSION.UNLOADED_RADIUS);
sm_tractor_row_crop_plot3bodytiremeas(logsout_sm_tractor_row_crop);


%% Simulation Results from Simscape Logging, Four Passes
%%
% In this maneuver, the tractor follows a trajectory in a field.  The
% driver attempts to follow the path.  Depending on the options for
% steering, it may be able to follow the trajectory exactly.  For some
% steering options, the curvature of the path is too sharp and some of the
% passes in the field will be missed.
%

sm_tractor_row_crop_config_maneuver('sm_tractor_row_crop',VehicleData,'fourpasses')
sim('sm_tractor_row_crop')

sm_tractor_row_crop_plot1whlspd(...
    simlog_sm_tractor_row_crop,...
    logsout_sm_tractor_row_crop,...
    VehicleData.TireDataF.param.DIMENSION.UNLOADED_RADIUS,...
    VehicleData.TireDataR.param.DIMENSION.UNLOADED_RADIUS);
sm_tractor_row_crop_plot2bodypos(simlog_sm_tractor_row_crop);
sm_tractor_row_crop_plot3bodytiremeas(logsout_sm_tractor_row_crop);

%% Simulation Results from Simscape Logging, Orchard
%%
% In this maneuver, the tractor follows a path on uneven terrain.  The
% terrain is specified using the Grid Surface block. Using "Weighted
% Penetration" option on the tire model enables the variable-step
% simulation to run much faster than option "Closest Point".
%

sm_tractor_row_crop_config_maneuver('sm_tractor_row_crop',VehicleData,'orchard')
sim('sm_tractor_row_crop')

sm_tractor_row_crop_plot1whlspd(...
    simlog_sm_tractor_row_crop,...
    logsout_sm_tractor_row_crop,...
    VehicleData.TireDataF.param.DIMENSION.UNLOADED_RADIUS,...
    VehicleData.TireDataR.param.DIMENSION.UNLOADED_RADIUS);
sm_tractor_row_crop_plot4orchardpath(SceneData.Orchard.gridsurf,MDatabase.Orchard_2Passes,simlog_sm_tractor_row_crop);
sm_tractor_row_crop_plot3bodytiremeas(logsout_sm_tractor_row_crop);


%%

%clear all
close all
bdclose all
