function thrust_n = f_thrust(altitude_m, mach_nb, isa_dev, ...
    mode)

%%% Convert the thrust for the output of the function

n1 = m_engine.f_fan_speed(altitude_m, isa_dev, mode);

thrust_n = m_engine.f_thrust_model(altitude_m, mach_nb, isa_dev, n1);

%%% End of function
end