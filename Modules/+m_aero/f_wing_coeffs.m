function [clwb, cdwb, cmwb] = f_wing_coeffs(plane, alpha_deg, mach_nb)

% Interpolation du coefficient de portance pour l'aile+fuselage en fonction
% de alpha et mach
clwb = interp2(plane.aeroCoeffs.f_clwb.y_mach(1:end-2), plane.aeroCoeffs.f_clwb.x_alpha, ...
    plane.aeroCoeffs.f_clwb.value(:, 1:end-2), mach_nb, alpha_deg, 'spline');

% Interpolation du coefficient de traînée pour l'aile+fuselage en fonction
% de alpha et mach
cdwb = interp2(plane.aeroCoeffs.f_cdwb.y_mach(1:end-2), plane.aeroCoeffs.f_cdwb.x_alpha, ...
    plane.aeroCoeffs.f_cdwb.value(:, 1:end-2), mach_nb, alpha_deg, 'spline');

% Interpolation du coefficient de tangage pour l'aile+fuselage en fonction
% de alpha et mach
cmwb = interp2(plane.aeroCoeffs.f_cmwb.y_mach(1:end-2), plane.aeroCoeffs.f_cmwb.x_alpha, ...
    plane.aeroCoeffs.f_cmwb.value(:, 1:end-2), mach_nb, alpha_deg, 'spline');

%%% End of the function
end