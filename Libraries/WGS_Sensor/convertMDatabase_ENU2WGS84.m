function MDatabase = convertMDatabase_ENU2WGS84(MDatabase,Coords)

mnv_list = fieldnames(MDatabase);

for m_i = 1:length(mnv_list)
    [lat, lon, h] = convertManeuver_ENU2WGS84(...
        MDatabase.(mnv_list{m_i}).Trajectory,...
        [Coords(1).Lat Coords(1).Lon Coords(1).hEll]);
    MDatabase.(mnv_list{m_i}).Trajectory.lat.Value = lat;
    MDatabase.(mnv_list{m_i}).Trajectory.lon.Value = lon;
    MDatabase.(mnv_list{m_i}).Trajectory.h.Value   = h;
end
