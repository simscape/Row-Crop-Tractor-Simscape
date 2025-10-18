%% Select Waypoints for 3D Simulation
%
% Execute this script section by section to create new maneuver
% using a UI to select waypoints

% Copyright 2020-2024 The MathWorks, Inc.

% Interactively Select Waypoints

clear wayPoints refPoses
sceneImage = flipud(imread('JCB_Test_Centre_Prestwood.png'));
sceneRef = imref2d([698 698],[-350 350],[-350 350]);
hFig = helperSelectSceneWaypoints(sceneImage, sceneRef);

% Run sm_car_define_maneuver_waypointsToTrajectory.m
% to complete the workflow