function AF = f_AF_cas_const(altitude_m, mach_nb, isa_dev)
%F_AF Calcul du facteur AF pour une montée à CAS constant
%
%   AF = f_AF(mach_nb, altitude_m, isa_dev, m_atmos)
%
%   Entrées :
%       mach_nb    - Nombre de Mach (M)
%       altitude_m - Altitude en mètres (h)
%       isa_dev    - Déviation ISA en °C
%       m_atmos    - Structure atmosphérique avec méthode f_temperature
%
%   Sortie :
%       AF - Facteur AF

    % Température réelle
    T = m_atmos.f_temperature(altitude_m, isa_dev);
    % Température ISA (isa_dev = 0)
    T_ISA = m_atmos.f_temperature(altitude_m, 0);

    % Calcul
    if altitude_m <= 11000
        AF = 0.7 * mach_nb^2 * ( ...
            ((1 + 0.2*mach_nb^2)^3.5 - 1) / ...
            (0.7*mach_nb^2 * (1 + 0.2*mach_nb^2)^2.5) ...
            - 0.190263 * T_ISA / T );
    else
        AF = ((1 + 0.2*mach_nb^2)^3.5 - 1) / ...
             ((1 + 0.2*mach_nb^2)^2.5);
    end
end
