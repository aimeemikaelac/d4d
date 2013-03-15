% idw.m - IDW 2-D interpolation. It uses haversine distances (check if haversine function is in your path). 
% Input: X, Y, Z, XI, YI, k (optional)
% Output: ZI
function ZI = idw( X, Y, Z, XI, YI, k )
    % input validation
    if ( nargin < 6 ) 
        k = 1;
    end
    if ( k < 1 ) 
        error( 'k must be >= 1' );
    end
    % doit 
    ZI = [];
    for i=1:size(XI,2)
        found = 0;
        for j=1:size(X,2)
            if ( XI(i) == X(j) && YI(i) == Y(j) )
                found = j;
                break;
            end
        end
        if ( found ~= 0 ) 
            ZI = [ ZI Z(j) ];
            continue;
        end
        num = 0;
        den = 0;
        for j=1:size(X,2)
            num = num + Z(j)*haversine( [ XI(i) YI(i); X(j) Y(j) ] )^(-k);
            den = den + haversine( [ XI(i) YI(i); X(j) Y(j) ] )^(-k); 
        end
        ZI = [ ZI num/den ];
    end
end