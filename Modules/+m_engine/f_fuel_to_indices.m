function indices_ref = f_fuel_to_indices(altitude_m, mach_nb, isa_dev, wfc, indices_array)
%F_FUEL_TO_FAN_SPEED Summary of this function goes here
%   Detailed explanation goes here

fan_speed = log([7 30 85 100]);

n1 = m_engine.f_fuel_flow_to_speed_fan(altitude_m, mach_nb, isa_dev, wfc);

indices_ref = exp(interp1(fan_speed, log(indices_array), log(n1), 'linear'));

end