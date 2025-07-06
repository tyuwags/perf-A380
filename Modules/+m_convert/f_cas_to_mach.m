function mach_nb = f_cas_to_mach(cas_mps, altitude_m, isa_dev)
    % f_cas_to_mach - Convertit une vitesse CAS (m/s) en nombre de Mach
    % en fonction de l'altitude et de la déviation ISA (en K ou °C).
    %
    % Entrées :
    %   cas_mps     - Vitesse calibrée en m/s
    %   altitude_m  - Altitude en mètres
    %   isa_dev     - Déviation ISA (°C ou K)
    %
    % Sortie :
    %   mach_nb     - Nombre de Mach
    
    a0 = m_atmos.f_speed_sound(altitude_m, 0);

    delta = m_atmos.f_delta(altitude_m);
    
    mach_nb = sqrt(5*((1/delta*((1+0.2*(cas_mps/a0)^2)^3.5-1)+1)^(1/3.5)-1));
    %%% End of function
end