function [clwb, cdwb, cmwb] = f_wing_coeffs(plane, alpha_deg, mach_nb)

% Interpolation du coefficient de portance pour l'aile+fuselage en fonction
% de alpha et mach
clwb = interpn(plane.aeroCoeffs.f_clwb.x_alpha, plane.aeroCoeffs.f_clwb.y_mach, ...
    plane.aeroCoeffs.f_clwb.value, alpha_deg, mach_nb);

% Interpolation du coefficient de traînée pour l'aile+fuselage en fonction
% de alpha et mach
cdwb = interpn(plane.aeroCoeffs.f_cdwb.x_alpha, plane.aeroCoeffs.f_cdwb.y_mach, ...
    plane.aeroCoeffs.f_cdwb.value, alpha_deg, mach_nb);

% Interpolation du coefficient de tangage pour l'aile+fuselage en fonction
% de alpha et mach
cmwb = interpn(plane.aeroCoeffs.f_cmwb.x_alpha, plane.aeroCoeffs.f_cmwb.y_mach, ...
    plane.aeroCoeffs.f_cmwb.value, alpha_deg, mach_nb);

%%% End of the function
end