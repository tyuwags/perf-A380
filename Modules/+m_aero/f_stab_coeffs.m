function [clht, cdht, cmht] = f_stab_coeffs(aero_data, alpha_ht_deg, mach_nb, downwash)

clht = interpn(aero_data.f_clht.x_alpha, aero_data.f_clht.y_mach, ...
    aero_data.f_clht.value, alpha_ht_deg, mach_nb);

cdht = interpn(aero_data.f_cdht.x_alpha, aero_data.f_cdht.y_mach, ...
    aero_data.f_cdht.value, alpha_ht_deg, mach_nb);



cmht = cdht*cosd(downwash) + clht*sind(downwash) - clht*cosd(downwash) + cdht*sind(downwash);

%%% End of the function
end