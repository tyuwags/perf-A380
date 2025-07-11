function fuelflow_kgps = f_fuel_flow(altitude_m , mach_nb, ...
    isa_dev, mode)

%%% Convert the fuel flow for the output of the function

n1 = m_engine.f_fan_speed(altitude_m, isa_dev, mode);

fuelflow_kgps = m_engine.f_fuel_flow_model(n1, mach_nb, altitude_m, isa_dev);

%%% End of function
end