Maneuver.Trajectory.x.Value = linspace(0,200,12);
%Maneuver.Trajectory.y.Value = Maneuver.Trajectory.x.Value*tand(10);
Maneuver.Trajectory.y.Value = [linspace(0,10,6) linspace(10,0,6)];
Maneuver.Trajectory.z.Value = Maneuver.Trajectory.y.Value*0;
Maneuver.Trajectory.aYaw.Value = atan2(Maneuver.Trajectory.y.Value,Maneuver.Trajectory.x.Value);
Maneuver.Trajectory.xTrajectory.Value = sqrt(Maneuver.Trajectory.x.Value.^2+Maneuver.Trajectory.y.Value.^2);

Maneuver.xPreview.x.Value = [0 5 10];
Maneuver.xPreview.v.Value = [0 5 10];