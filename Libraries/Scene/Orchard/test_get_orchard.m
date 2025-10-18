% Import raw surface data
fname = "swissalti3d_2019_2609-1192_0.5_2056_5728.tif";
full_surface     = double(imread(fname));

% Reorient to match Unreal
full_surface_ori.h = rot90(full_surface,-1);

full_surface_ori.x = (1:size(full_surface_ori.h,2))*0.5;
full_surface_ori.y = (1:size(full_surface_ori.h,2))*0.5;

% Select portion of surface for orchard by indices
x_inds      =  800:1400;%1038-200:1186+200;
y_inds      =  1600:2000;%8:336+120; 

% Extract portion of surface
full_surface_ori2.h = full_surface_ori.h(x_inds,y_inds);
full_surface_ori2.x = full_surface_ori.x(x_inds);
full_surface_ori2.y = full_surface_ori.y(y_inds);

% Offset y so that "top" of surface is at 0, bottom at max -y
% This is suitable for right-handed coordinate system
% Swap sign of location for left-handed coordinate system
full_surface_ori3.h = full_surface_ori.h(x_inds,y_inds);
full_surface_ori3.x = full_surface_ori.x(x_inds);
full_surface_ori3.y = full_surface_ori.y(y_inds)-max(full_surface_ori.y);