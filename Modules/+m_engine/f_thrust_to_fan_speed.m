function n1_out = f_thrust_to_fan_speed(altitude_m, mach_nb, isa_dev, thrust_n_c)
%F_THRUST_TO_FAN_SPEED Summary of this function goes here
%   Detailed explanation goes here

residual = @(n1) (m_engine.f_thrust_model(altitude_m, mach_nb, isa_dev, n1) - thrust_n_c);

% m_engine.f_thrust_model(altitude_m, mach_nb, isa_dev, 100)
% thrust_n_c

n1_guess = 50;

options = optimset('Display', 'off');


n1_out = fsolve(residual, n1_guess, options);

end