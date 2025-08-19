function [mach_econ, tas_econ, cost_min,wf] = f_econ_speed(altitude_m, isa_dev, vw_mps, ...
    CI, plane)
%F_ECON_SPEED Calcule le Mach et TAS qui minimise la fonction de coût ECON
%   Inputs :
%       altitude_m : Altitude de croisière [m]
%       isa_dev    : Déviation ISA [K]
%       vw_mps     : composante du vent [m/s] (positive si de face)
%       CI         : Cost Index [unité dépend du modèle]
%       plane      : structure de l’avion contenant sa masse, config, etc.
%
%   Outputs :
%       mach_econ : Mach économique optimal
%       tas_econ  : True Air Speed associé [m/s]
%       cost_min  : valeur minimale de la fonction coût

    beta = 60/3600;  % facteur d'équivalence entre coût et carburant (ajuster selon unités)

    % Domaine de recherche
    mach_range = 0.5 : 0.01 : 0.89;
    
    best_cost = inf;
    mach_econ = NaN;
    tas_econ = NaN;

    for mach = mach_range
        try
            [wf, ~, ~, ~] = m_trim.f_trim(altitude_m, mach, isa_dev, plane);  % kg/s
            vt = m_convert.f_mach_to_tas(mach, altitude_m, isa_dev);  % m/s
            vgs = vt + vw_mps;

            if vgs <= 0
                continue;  % évite les cas où vent contraire bloque
            end

            cost = (wf + beta * CI) / vgs;

            if cost < best_cost
                best_cost = cost;
                mach_econ = mach;
                tas_econ = vt;
                cost_min = cost;
            end
        catch
            % En cas d'erreur (trim échoue), on ignore ce point
            continue;
        end
    end

    if isnan(mach_econ)
        error('Impossible de trouver une vitesse ECON dans l''intervalle donné.');
    end

end

