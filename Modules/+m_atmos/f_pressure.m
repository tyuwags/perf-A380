function pressure_Pa = f_pressure(altitude_m, isa_dev)
    % Calcule la pression selon le modèle ISA (jusqu'à ~20 km)
    
    % Constantes
    P0 = 101325;         % Pa
    T0 = 288.15;         % K
    L  = -0.0065;        % K/m (gradient dans la troposphère)
    R  = 287.05;         % J/kg/K
    g  = 9.80665;        % m/s²
    
    if nargin < 2
        isa_dev = 0;
    end

    if altitude_m <= 11000
        T = m_atmos.f_temperature(altitude_m, isa_dev);
        pressure_Pa = P0 * (1 + L * altitude_m / T0)^(-g / (L * R));
    else
        % Étape 1 : pression à 11 000 m
        T_11 = m_atmos.f_temperature(11000, isa_dev);
        P_11 = P0 * (1 + L * 11000 / T0)^(-g / (L * R));
        
        % Étape 2 : isotherme au-dessus de 11 000 m
        T = T_11; % reste constant
        delta_h = altitude_m - 11000;
        pressure_Pa = P_11 * exp(-g * delta_h / (R * T));
    end
end
