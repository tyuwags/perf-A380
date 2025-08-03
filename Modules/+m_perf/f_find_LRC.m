function [Mach_LRC, SR_LRC, Mach_MRC, SR_MRC] = f_find_LRC(altitude, ISA_dev, V_W, plane)
    % Étape 1 : calcul du MRC par échantillonnage
    [Mach_MRC, SR_MRC, Mach_vect, SR_vect] = m_perf.f_find_MRC(altitude,ISA_dev, V_W, plane);

    % Étape 2 : objectif LRC = 99% du SR MRC
    SR_target = 0.99 * SR_MRC;

    % Étape 3 : optimisation dans l'intervalle [Mach_MRC, 0.89]
    f_opt = @(x) (m_perf.f_specific_range(x, altitude, ISA_dev, V_W, plane) - SR_target)^2;
    lb = Mach_MRC; ub = 0.89;
    options = optimoptions('fmincon', 'Display', 'off');
    Mach_LRC = fmincon(f_opt, Mach_MRC + 0.01, [], [], [], [], lb, ub, [], options);

    % SR correspondant
    SR_LRC = m_perf.f_specific_range(Mach_LRC, altitude, ISA_dev, V_W, plane);
end
