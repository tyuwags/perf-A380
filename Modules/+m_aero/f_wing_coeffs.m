function [clwb, cdwb, cmwb] = f_wing_coeffs(aero_data, alpha_deg, mach_nb)

% Interpolation du coefficient de portance pour l'aile+fuselage en fonction
% de alpha et mach
clwb = interpn(aero_data.f_clwb.x_alpha, aero_data.f_clwb.y_mach, ...
    aero_data.f_clwb.value, alpha_deg, mach_nb);

% Interpolation du coefficient de traînée pour l'aile+fuselage en fonction
% de alpha et mach
cdwb = 0;

% Interpolation du coefficient de tangage pour l'aile+fuselage en fonction
% de alpha et mach
cmwb = 0;

%%% End of the function
end