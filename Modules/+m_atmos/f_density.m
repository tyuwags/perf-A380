function density_kgpm3 = f_density(altitude_m, isa_dev)
    
    %%% Compute static air density
    % Constantes
    R = 287.05;       % Constante des gaz parfaits (J/kg/K)
    rho_0 = 1.225;
    T0 = 288.15;         % K
    L  = -0.0065;        % K/m (gradient dans la troposphère)
    g  = 9.80665;        % m/s²
    
    if nargin < 2
        isa_dev = 0;
    end

    if altitude_m <= 11000
        density_kgpm3 = rho_0 * (1 + L*altitude_m/T0)^(-g / (L * R) - 1);
    else
        % Étape 1 : pression à 11 000 m
        T_11 = m_atmos.f_temperature(11000, isa_dev);
        rho_11 = rho_0 * (1 + L*11000/T0)^(-g / (L * R) - 1);
        
        % Étape 2 : isotherme au-dessus de 11 000 m
        T = T_11; % reste constant
        delta_h = altitude_m - 11000;
        density_kgpm3 = rho_11 * exp(-g * delta_h / (R * T));
    end

end