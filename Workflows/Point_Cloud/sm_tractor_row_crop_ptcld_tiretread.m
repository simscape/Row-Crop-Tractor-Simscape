function [ptcld_Loc,ptcld_hull] = sm_tractor_row_crop_ptcld_tiretread(stlFile,radialDims,exclRad,colswap,varargin)
% sm_tractor_row_crop_ptcld_tiretread  Extracting Point Cloud from STL Geometry
%    ptcld = sm_tractor_row_crop_ptcld_tiretread(stlFile,radialDims,exclRad,colswap)
%    This function shows MATLAB commands to obtain coordinates for the point
%    cloud that is used to detect collision between the wheels and the ground
%    terrain. The STL file for the wheel tread is read into MATLAB, and then a
%    few commands are used to extract just the points that are useful for the
%    contact and friction force calculation.
%
%    stlFile     Name of STL file with extension
%    radialDims  Dimensions of points along radial axes (x=1, y=2, z=3)
%    exclRad     Exclude all points within this radius, same units as STL file
%    colSwap     Indices to swap point columns and flip sign until 
%                  axial points are along z and x and y points match STL
%    showPlot    (Optional) Set to 'plot' to show plots 
%
% Copyright 2025 The MathWorks, Inc

plotStr = 'no';

if(nargin>4)
    plotStr = varargin{1};
end

showPlot = strcmp(lower(plotStr),'plot');


%% Read in the STL file, plot mesh
%
% The <matlab:doc('stlread') stlread> and <matlab:doc('trimesh') trimesh> commands are very useful for working with STL
% files.

wheel_stl_points = stlread(stlFile);

if(showPlot)
    figure(1)
    trimesh(wheel_stl_points,'EdgeColor',[0.6 0.6 0.6])
    axis equal
    box on
    title('STL Mesh')
    xlabel('x')
    ylabel('y')
    zlabel('z')
end

%% Find offset to center
% Point cloud points must be centered about rotational axis
xOffset = (max(wheel_stl_points.Points(:,1))+min(wheel_stl_points.Points(:,1)))/2;
yOffset = (max(wheel_stl_points.Points(:,2))+min(wheel_stl_points.Points(:,2)))/2;
zOffset = (max(wheel_stl_points.Points(:,3))+min(wheel_stl_points.Points(:,3)))/2;

% Create new triangulation based on centered points
% Must use original points, not unique points
wheel_stl_points_new  = wheel_stl_points.Points-[xOffset yOffset zOffset];
wheel_stl_new         = triangulation(wheel_stl_points.ConnectivityList,wheel_stl_points_new(:,1),wheel_stl_points_new(:,2),wheel_stl_points_new(:,3));

%% Filter Points Based on Location
%
% As the data is all in x-y-z coordinates, we could look for points on the
% edge of the wheel on the tips of the fins.  With STL files, you sometimes
% need to eliminate duplicate points using the MATLAB command
% <matlab:doc('unique') unique>.  The code below finds points on the wheel 
% edge that are outside a specified radius.

wheel_stl_points_unique = unique(wheel_stl_points.Points,'Rows');
wheel_stl_points_unique = wheel_stl_points_unique-[xOffset yOffset zOffset];

% Calculate radius of all points
point_radius = sqrt(wheel_stl_points_unique(:,radialDims(1)).^2 + wheel_stl_points_unique(:,radialDims(2)).^2);

% Eliminate points within the exclusion radius
edge_points = wheel_stl_points_unique(point_radius>=exclRad,:,:);

if(showPlot)
    figure(2)
    trimesh(wheel_stl_new,'EdgeColor',[0.6 0.6 0.6])
    hold on
    plot3(edge_points(:,1),edge_points(:,2),edge_points(:,3),'bo')
    axis equal
    box on
    hold off
    title('Points for Inner Edge')
end


% Eliminate duplicates
pcLoc = unique(edge_points,'rows');

% Swap columns and signs of points so points align with STL geometry
edge_points_swap  = pcLoc(:,abs(colswap));
edge_hull_points  = edge_points_swap;
edge_hull_points  = edge_hull_points.*sign(colswap);

% Return result
ptcld_Loc = edge_hull_points;

%% Filter Points Using Convex Hull
%
% A method which is useful is extracting the points that form a
% convex hull. This is the smallest set of points that completely contains
% the shape, which for our wheel is useful. The resulting set would work
% for modeling contact between the wheel and the ground, but has many more
% points than we need for relatively smooth terrain.  
%
% Obtaining this set of points uses <matlab:doc('delaunayTriangulation')
% delaunayTriangulation> and <matlab:doc('convexHull') convexHull>.

wheel_stl_points_tri = delaunayTriangulation(wheel_stl_points_new);
cvh_inds  = convexHull(wheel_stl_points_tri);

if(showPlot)
    figure(3)
    trimesh(wheel_stl_new,'EdgeColor',[0.6 0.6 0.6])
    hold on
    plot3(wheel_stl_points_tri.Points(cvh_inds,1),...
        wheel_stl_points_tri.Points(cvh_inds,2),...
        wheel_stl_points_tri.Points(cvh_inds,3),'b.')
    axis equal
    box on
    hold off
    title('Points Using Convex Hull')
    view(-45,30)
end

% Eliminate duplicates
pc = unique([wheel_stl_points_tri.Points(cvh_inds,1),...
    wheel_stl_points_tri.Points(cvh_inds,2),...
    wheel_stl_points_tri.Points(cvh_inds,3)],'rows');

% Eliminate inner points
pc_rads = sqrt(pc(:,radialDims(1)).^2 + pc(:,radialDims(2)).^2);
edge_hull_points = pc(pc_rads>=exclRad,:,:);

% Swap columns and signs of points so points align with STL geometry
edge_points_swap  = edge_hull_points(:,abs(colswap));
edge_hull_points  = edge_points_swap;
edge_hull_points  = edge_hull_points.*sign(colswap);

% Return result
ptcld_hull = edge_hull_points;

