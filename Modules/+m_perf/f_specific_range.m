function SR = f_specific_range(M, altitude, ISA_dev, V_W_mps, plane)
    % Equilibrage de l'avion
    W_F = m_trim.f_trim(altitude, M, ISA_dev, plane);

    % Estimation de la vitesse vraie
    V_TAS = m_convert.f_mach_to_tas(M, altitude, ISA_dev);

    % Vitesse au sol
    V_GS = V_TAS + V_W_mps;

    % Specific Range
    SR = V_GS / W_F;
end