function n1_out = f_thrust_to_fan_speed(altitude_m, mach_nb, isa_dev, thrust_n)
%F_THRUST_TO_FAN_SPEED Summary of this function goes here
%   Detailed explanation goes here

residual = @(n1) (m_engine.f_thrust_model(altitude_m, mach_nb, isa_dev, n1) - thrust_n);

n1_guess = [0 100];

n1_out = fzero(residual, n1_guess);

end