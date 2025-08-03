function density_kgpm3 = f_density(altitude_m, isa_dev)
    
    %%% Compute static air density
    % Constantes
    R = 287.05;       % Constante des gaz parfaits (J/kg/K)

    P = m_atmos.f_pressure(altitude_m, isa_dev);
    T = m_atmos.f_temperature(altitude_m, isa_dev);
    
    density_kgpm3 = P/(R*T);

end