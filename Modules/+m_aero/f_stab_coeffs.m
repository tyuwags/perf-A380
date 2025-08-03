function [clht, cdht, cmht] = f_stab_coeffs(plane, alpha_ht_deg, mach_nb, downwash)

clht = interpn(plane.aeroCoeffs.f_clht.x_alpha, plane.aeroCoeffs.f_clht.y_mach, ...
    plane.aeroCoeffs.f_clht.value, alpha_ht_deg, mach_nb);

cdht = interpn(plane.aeroCoeffs.f_cdht.x_alpha, plane.aeroCoeffs.f_cdht.y_mach, ...
    plane.aeroCoeffs.f_cdht.value, alpha_ht_deg, mach_nb);



cmht = 0;

%%% End of the function
end