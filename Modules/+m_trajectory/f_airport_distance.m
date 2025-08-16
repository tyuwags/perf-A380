function [lat, lon] = findAirportCoords(code, airports)
    idxIata = strcmpi(airports.iata_code, code);
    idxIcao = strcmpi(airports.icao_code, code);
    idx = find(idxIata | idxIcao, 1);
    if isempty(idx)
        error('Code d''aéroport non trouvé : %s', code);
    end
    lat = airports.Latitude(idx);
    lon = airports.Longitude(idx);
end

function dist_km = f_airport_distance(code1, code2, airports)
    [lat1, lon1] = findAirportCoords(code1, airports);
    [lat2, lon2] = findAirportCoords(code2, airports);
    % Convertir en radians
    lat1 = deg2rad(lat1); lon1 = deg2rad(lon1);
    lat2 = deg2rad(lat2); lon2 = deg2rad(lon2);
    R = 6371; % km
    dlat = lat2 - lat1;
    dlon = lon2 - lon1;
    a = sin(dlat/2).^2 + cos(lat1).*cos(lat2).*sin(dlon/2).^2;
    c = 2 * atan2(sqrt(a), sqrt(1-a));
    dist_km = R * c;
end
