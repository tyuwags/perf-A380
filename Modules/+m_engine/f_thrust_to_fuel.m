function fuelflow_kgps = f_thrust_to_fuel(altitude_m, mach_nb,...
    isa_dev, thrust_n)

delta = m_atmos.f_delta(altitude_m);

corrected_thrust_n = thrust_n/delta;

%%% Convert the fuel flow for the output of the function
n1 = m_engine.f_thrust_to_fan_speed(altitude_m, mach_nb, isa_dev, corrected_thrust_n);

fuelflow_kgps = m_engine.f_fuel_flow_model(altitude_m, mach_nb, isa_dev, n1);

end