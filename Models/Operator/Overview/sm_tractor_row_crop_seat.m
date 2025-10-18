%% Tractor Seat Suspension
% 
% <<sm_tractor_row_crop_seat_Overview.png>>
% 
% This example shows a model of a seat suspension in a tractor.  We can use
% this model to assess the comfort of the operator.
% 
% A vertical spring-damper connecting the seat to the cabin can be enabled
% or disabled.  A passive model of a human with joints is connected to the
% seat and the steering wheel.  The cabin is moved up and down using white
% noise and we measure the acceleration of the operators head.
%
% (<matlab:web('Tractor_Row_Crop_Overview.html') return to Row Crop Tractor Overview>)
%
% Copyright 2025 The MathWorks, Inc.

%% Model

open_system('sm_tractor_row_crop_seat')

set_param(find_system('sm_tractor_row_crop_seat','MatchFilter',@Simulink.match.allVariants,'FindAll', 'on','type','annotation','Tag','ModelFeatures'),'Interpreter','off')

%% Operator Model
%
% The operator is modeled with rigid bodies and joints.  Some joints have
% spring-dampers in them to hold the normal seated position.

set_param('sm_tractor_row_crop_seat/Operator/Driver Human Seated','LinkStatus','none')
open_system('sm_tractor_row_crop_seat/Operator/Driver Human Seated','force')

%% Seat Model
%
% This subsystem models the seat suspension as a vertically oriented spring
% damper.

set_param('sm_tractor_row_crop_seat/Suspension/Heave Linear','LinkStatus','none')
open_system('sm_tractor_row_crop_seat/Suspension/Heave Linear','force')


%% Simulation Results from Simscape Logging
%
% The plot below shows the vertical acceleration of the operators head and the
% vertical acceleraton of the cabin.  The seat suspension attenuates some
% of the motion of the cabin, making it more comfortable for the operator.

sim('sm_tractor_row_crop_seat')

open_system('sm_tractor_row_crop_seat/Scope')

%%

%clear all
close all
bdclose all
