function IDatabase = sm_tractor_steering_define_init(MDatabase)

Init = struct;
Init.Instance = 'Tractor';
Init.Type = 'Field1_Path1';
Init.Chassis = struct;
Init.Chassis.aChassis = struct;
Init.Chassis.aChassis.Units = 'rad';
Init.Chassis.aChassis.Value = [0 0 0];
Init.Chassis.aChassis.Comments = 'Roll-Pitch-Yaw';
Init.Chassis.vChassis = struct;
Init.Chassis.vChassis.Units = 'm/s';
Init.Chassis.vChassis.Value = [1 0 0];
Init.Chassis.vChassis.Comments = '';
Init.Chassis.sChassis = struct;
Init.Chassis.sChassis.Units = 'm';
Init.Chassis.sChassis.Value = [0 0 0];
Init.Chassis.sChassis.Comments = '';
Init.Axle1 = struct;
Init.Axle1.nWheel = struct;
Init.Axle1.nWheel.Units = 'rad/s';
Init.Axle1.nWheel.Comments = 'Values are [left right radius]';
Init.Axle1.nWheel.Value = [1/0.88 1/0.88 0.88];
Init.Axle2 = struct;
Init.Axle2.nWheel = struct;
Init.Axle2.nWheel.Units = 'rad/s';
Init.Axle2.nWheel.Comments = 'Values are [left right radius]';
Init.Axle2.nWheel.Value = [1/0.88 1/0.88 0.88];

% Original paths all start at [0 0 0] along +x
IDatabase.Passes4_Loop      = Init;
IDatabase.Passes4Curve_Loop = Init;
IDatabase.Triangle_12Passes = Init;

IDatabase.Orchard_2Passes   = Init;
IDatabase.Orchard_2Passes.Chassis.sChassis.Value = [...
    MDatabase.Orchard_2Passes.Trajectory.x.Value(1) ...
    MDatabase.Orchard_2Passes.Trajectory.y.Value(1) ...
    MDatabase.Orchard_2Passes.Trajectory.z.Value(1)];

IDatabase.Uneven_Road   = Init;
IDatabase.Uneven_Road.Chassis.sChassis.Value = [...
    MDatabase.Uneven_Road.Trajectory.x.Value(1) ...
    MDatabase.Uneven_Road.Trajectory.y.Value(1) ...
    MDatabase.Uneven_Road.Trajectory.z.Value(1)+0.50];


IDatabase.Testrig           = Init;
IDatabase.Testrig.Chassis.vChassis.Value = 0;
IDatabase.Testrig.Axle1.nWheel.Value     = [0 0 0.88];
IDatabase.Testrig.Axle1.nWheel.Value     = [0 0 0.88];


%sm_tractor_steering_define_init_test_centre
%IDatabase.Test_Centre       = Init;

%Init = IDatabase.Passes4_Loop;