function pressure_Pa = f_pressure(altitude_m, isa_dev)
    % F_PRESSURE Calcule la pression atmosphérique en fonction de l'altitude
    % Entrée :
    %   altitude_m : Altitude en mètres
    %   isa_dev : Déviation de température
    % Sortie :
    %   pressure_Pa : Pression en Pascal
    
    % Constantes
    P0 = 101325;      % Pression au niveau de la mer (Pa)
    T0 = 288.15;      % Température au niveau de la mer (K)
    L = -0.0065;      % Gradient thermique (K/m)
    R = 287.05;       % Constante des gaz parfaits (J/kg/K)
    g = 9.80665;      % Gravité (m/s²)

    if nargin < 2
        isa_dev = 0;
    end

    T = m_atmos.f_temperature(altitude_m, isa_dev);

    pressure_Pa = P0 * (T / T0)^(-g / (L * R));

    pressure_Pa = pressure_Pa * exp(-g * max(0, altitude_m - 11000) / (R * T));
end