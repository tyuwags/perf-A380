function temperature_K = f_temperature(altitude_m, isa_dev)
    % F_TEMPERATURE Calcule la température à une altitude donnée selon ISA + déviation
    % Entrées :
    %   altitude_m : Altitude en mètres
    %   isa_dev    : Déviation ISA (en Kelvin)
    % Sortie :
    %   temperature_K : Température en Kelvin
    
    T0 = 288.15;       % Température standard au niveau de la mer (K)
    L = -0.0065;       % Gradient thermique dans la troposphère (K/m)

    temperature_K = T0 + L * min(altitude_m, 11000) + isa_dev;
    
    %%% End of function
end