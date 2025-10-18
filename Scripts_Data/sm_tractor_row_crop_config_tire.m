function VehicleData = sm_tractor_row_crop_config_tire(mdl,VehicleData,tireType)
% sm_tractor_row_crop_config_tire  Set tire type in model
% VehicleData = sm_tractor_row_crop_config_tire(mdl,VehicleData,tireType)
%   This function selects the tire model and adjusts the data structure if
%   the point cloud tire is selected
%
%   mdl           Name of Simulink model
%   VehicleData   VehicleData structure with parameters for model
%   tireType      'Magic Formula', 'Point Cloud Cylinder', or 'Point Cloud Tread'
%
%   The updated VehicleData structure is returned
%
% Copyright 2021-2024 The MathWorks, Inc.

switch (lower(tireType))
    case 'magic formula'
        set_param([mdl '/Tractor'],'popup_tire_type','Magic Formula');
    case 'point cloud cylinder'
        set_param([mdl '/Tractor'],'popup_tire_type','Point Cloud');
        VehicleData.TireDataF.ptcld = VehicleData.TireDataF.ptcld_cyl;
        VehicleData.TireDataR.ptcld = VehicleData.TireDataR.ptcld_cyl;
    case 'point cloud tread'
        set_param([mdl '/Tractor'],'popup_tire_type','Point Cloud');
        VehicleData.TireDataF.ptcld = VehicleData.TireDataF.ptcld_treadLoc;
        VehicleData.TireDataR.ptcld = VehicleData.TireDataR.ptcld_treadLoc;
end