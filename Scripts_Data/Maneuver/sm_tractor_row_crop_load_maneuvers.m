function MDatabase = sm_tractor_row_crop_load_maneuvers(SceneData)

%% Load manueuvers
%load MDatabase  % Contains cartesian - East-North-Up (ENU)
%orch_surf = sm_tractor_row_crop_sceneorchard;
ManvOrch = sm_tractor_steering_define_manv_orchard(SceneData.Orchard.gridsurf);
MDatabase.(ManvOrch.Type) = ManvOrch;

Path_Passes4_Loop
Manv4Loop = sm_tractor_steering_path2maneuver(Passes4_Loop);
MDatabase.(Manv4Loop.Type) = Manv4Loop;

Path_Passes4Curve_Loop
Manv4LoopCurve = sm_tractor_steering_path2maneuver(Passes4Curve_Loop);
MDatabase.(Manv4LoopCurve.Type) = Manv4LoopCurve;

Path_Triangle_12Passes
ManvTri12Passes = sm_tractor_steering_path2maneuver(Triangle_12Passes);
MDatabase.(ManvTri12Passes.Type) = ManvTri12Passes;

load GS_Uneven_Road_GSD
load GS_Uneven_Road_Manv
Maneuver.nPreviewPoints.Value = 5;
Maneuver.nPreviewPoints.Units = '';
Maneuver.nPreviewPoints.Comments = 'For Pure Pursuit Driver';

fNames = fieldnames(Maneuver);
for i = 1:length(fNames)
    MDatabase.Uneven_Road.(fNames{i}) = Maneuver.(fNames{i});
end


%% For reference - this code can convert East-North-Up to WGS84

% Load reference points in WGS84
%Coords = Coords_WGSTest;

% Convert ENU to WGS84 coordinates for all manuevers
% Add trajectories to MDatabase for all scenarios
%MDatabase = convertMDatabase_ENU2WGS84(MDatabase,Coords);

% Convert WGS84 to ENU coordinates for all manuevers
% Add trajectories to MDatabase for all scenarios
% (shown for documentation purpose only
%  not necessary since original data had ENU)
% Note this puts trajectory start to [0 0 0]
%convertMDatabase_WGS842ENU