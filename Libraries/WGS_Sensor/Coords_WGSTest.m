function Coords = Coords_WGSTest

Coords(1).City   = 'Uttoxeter';
Coords(1).Lat    = 52.8981;
Coords(1).Lon    =  1.8658;
Coords(1).elev   = 95; % m
Coords(1).hGeoid = egm96geoid(Coords(1).Lat,Coords(1).Lon); % m
Coords(1).hEll   = Coords(1).hGeoid + Coords(1).elev;
[xE, yN, zU]     = geodetic2enu(...
    Coords(1).Lat, Coords(1).Lon, Coords(1).hEll,....
    Coords(1).Lat, Coords(1).Lon, Coords(1).hEll,....
    wgs84Ellipsoid);
Coords(1).xE     = xE;
Coords(1).yN     = yN;
Coords(1).zU     = zU;

Coords(2).City = 'Telford';
Coords(2).Lat  = 52.6776;
Coords(2).Lon  =  2.4673;
Coords(2).elev = 163; % m
Coords(2).hGeoid = egm96geoid(Coords(2).Lat,Coords(2).Lon); % m
Coords(2).hEll = Coords(2).hGeoid + Coords(2).elev;
[xE, yN, zU]     = geodetic2enu(...
    Coords(2).Lat, Coords(2).Lon, Coords(2).hEll,....
    Coords(1).Lat, Coords(1).Lon, Coords(1).hEll,....
    wgs84Ellipsoid);
Coords(2).xE     = xE;
Coords(2).yN     = yN;
Coords(2).zU     = zU;

Coords(3).City = 'Birmimgham';
Coords(3).Lat  = 52.4862;
Coords(3).Lon  =  1.8904;
Coords(3).elev = 140; % m
Coords(3).hGeoid = egm96geoid(Coords(3).Lat,Coords(3).Lon); % m
Coords(3).hEll = Coords(3).hGeoid + Coords(3).elev;
[xE, yN, zU]     = geodetic2enu(...
    Coords(3).Lat, Coords(3).Lon, Coords(3).hEll,....
    Coords(1).Lat, Coords(1).Lon, Coords(1).hEll,....
    wgs84Ellipsoid);
Coords(3).xE     = xE;
Coords(3).yN     = yN;
Coords(3).zU     = zU;

% web(fullfile(docroot, 'map/ellipsoid-geoid-and-orthometric-height.html'))






