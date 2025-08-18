function AF = f_AF_mach_const(altitude_m, mach_nb, isa_dev)
%F_AF_MACH_CONST Calcul du facteur AF pour une montée à Mach constant
%
%   AF = f_AF_mach_const(mach_nb, altitude_m, isa_dev, m_atmos)
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
        AF = -0.13318 * mach_nb^2 * (T_ISA / T);
    else
        AF = 0;
    end
end
