function [orch_surf] = sm_tractor_row_crop_sceneorchard

% Import raw surface data
fname = "swissalti3d_2019_2609-1192_0.5_2056_5728.tif";
full_surface     = double(imread(fname));

% Reorient so that columns are x (east-west), rows are y (north-south)
full_surface_ori.h = rot90(full_surface,-1);

% Create full x and y grid spacing
grid_spacing = 0.5; % m
full_surface_ori.x = (1:size(full_surface_ori.h,1))*grid_spacing;
full_surface_ori.y = (1:size(full_surface_ori.h,2))*grid_spacing;

% Select portion of surface for orchard by indices
x_inds      =  800:1400;
y_inds      =  1600:2000; 

% To use entire surface
%x_inds = 1:size(full_surface,1);
%y_inds = 1:size(full_surface,2);

% Extract portion of surface
orch_surf.h = full_surface_ori.h(x_inds,y_inds);
orch_surf.x = full_surface_ori.x(x_inds);

% Offset y so that "top" of surface is at 0, bottom at max -y
% This is suitable for right-handed coordinate system
% Swap sign of location for left-handed coordinate system
orch_surf.y = full_surface_ori.y(y_inds)-max(full_surface_ori.y);

end