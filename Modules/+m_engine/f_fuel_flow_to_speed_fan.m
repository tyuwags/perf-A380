function n1_out = f_fuel_flow_to_speed_fan(altitude_m, mach_nb, isa_dev, wfc)
%F_FUEL_FLOW_TO_SPEED_FAN Summary of this function goes here
%   Detailed explanation goes here
residual = @(n1) (m_engine.f_fuel_flow_model(altitude_m, mach_nb, isa_dev, n1) - wfc);

n1_guess = [0 100];

n1_out = fzero(residual, n1_guess);

end