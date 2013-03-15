% haversine.m - computes the distance (in Km) between 2 locations expressed in lat,long.
% Input: XY = [ lat1 long1; lat2 long2 ]
% Output: distance between the 2 locations in Km
function d = haversine( XY )
    p1 = XY(1, :) .* ( pi / 180 );
    p2 = XY(2, :) .* ( pi / 180 );
    d_lat = p1(1) - p2(1);
    d_lon = p1(2) - p2(2);
    h = (sin(d_lat/2))^2 + cos(p1(1)) * cos(p2(1)) * (sin(d_lon/2))^2;
    d = 6372.8 * 2 * atan2( sqrt(h), sqrt(1-h) );
end