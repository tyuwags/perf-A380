function [clht, cdht, cmht] = f_stab_coeffs(plane, alpha_ht_deg, mach_nb, downwash)

clht = interp2(plane.aeroCoeffs.f_clht.y_mach, plane.aeroCoeffs.f_clht.x_alpha, ...
    plane.aeroCoeffs.f_clht.value, mach_nb, alpha_ht_deg, 'spline');

cdht = interp2(plane.aeroCoeffs.f_cdht.y_mach, plane.aeroCoeffs.f_cdht.x_alpha, ...
    plane.aeroCoeffs.f_cdht.value, mach_nb, alpha_ht_deg, 'spline');



cmht = 0;

%%% End of the function
end