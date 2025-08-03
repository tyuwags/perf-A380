function [Mach_MRC, SR_MRC, Mach_vect, SR_vect] = f_find_MRC(altitude, ISA_dev, V_W, plane)
    % Définition du vecteur de Mach
    Mach_vect = 0.7 : 0.01 : 1;
    SR_vect = zeros(size(Mach_vect));

    % Calcul du Specific Range pour chaque Mach
    for k = 1:length(Mach_vect)
        Mach = Mach_vect(k)
        SR_vect(k) = m_perf.f_specific_range(Mach, altitude, ISA_dev, V_W, plane);
    end

    % Recherche du Mach qui maximise le Specific Range
    [SR_MRC, idx_MRC] = max(SR_vect);
    Mach_MRC = Mach_vect(idx_MRC);
end
