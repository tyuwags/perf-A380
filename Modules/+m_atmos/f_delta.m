function delta = f_delta(altitude)
    % Calcul du facteur delta (pression relative P/P0) selon altitude (m)
    % Entrée :
    %   altitude (en mètres)
    % Sortie :
    %   delta : pression relative (P / P0)

    % Constantes ISA
    T0 = 288.15;       % Température au niveau de la mer (K)
    L = -0.0065;        % Gradient de température (K/m)
    g0 = 9.80665;      % Gravité (m/s²)
    Ra = 287.05;       % Constante des gaz parfaits pour l'air (J/kg/K)
    h11 = 11000;       % Altitude de transition (m)

    % Température à 11 km (base stratosphère)
    T11 = T0 + L * h11;

    % Facteur delta à 11 km
    delta11 = (1 + (L * h11) / T0)^(-g0 / (Ra * L));

    if altitude < 0
        error('Altitude doit être >= 0');
    elseif altitude <= h11
        % Troposphère
        delta = (1 + (L * altitude) / T0)^(-g0 / (Ra * L));
    else
        % Stratosphère
        delta = delta11 * exp(-g0 * (altitude - h11) / (Ra * T11));
    end
end
