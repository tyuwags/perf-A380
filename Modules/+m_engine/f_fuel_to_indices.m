function indices_ref = f_fuel_to_indices(altitude_m, mach_nb, isa_dev, wfc, indices_array)
%F_FUEL_TO_FAN_SPEED Summary of this function goes here
%   Detailed explanation goes here

wfc_ref = log([0.261 0.749 2.262 2.738]);


indices_ref = exp(interp1(wfc_ref, log(indices_array), log(wfc), 'spline'));

end