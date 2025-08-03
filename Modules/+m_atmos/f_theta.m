function theta = f_theta(altitude_m, isa_dev)
    % f_theta - Calcule le rapport de température adimensionnel θ = T / T0
    % à une altitude donnée, en tenant compte de la déviation ISA.
    %
    % Entrées :
    %   altitude_m - Altitude en mètres (constante)
    %   isa_dev    - Déviation ISA (en °C ou K), à cette altitude
    %
    % Sortie :
    %   theta      - Rapport adimensionnel θ = T / T0
    
    % Constantes ISA
    T0   = 288.15;   % Température standard au niveau de la mer (K)
    L   = -0.0065;   % Gradient de température (K/m) dans la troposphère
    h11  = 11000;    % Limite troposphère-stratosphère (m)
    T11  = T0 + L * h11;  % Température à 11 000 m (K)
    theta11 = T11 / T0;    % θ à 11 000 m
    
    % Calcul de θ selon la région atmosphérique
    if altitude_m < h11
        % Troposphère
        theta = 1 + (isa_dev + L * altitude_m) / T0;
    else
        % Stratosphère (température constante)
        theta = theta11 + isa_dev / T0;
    end

end
