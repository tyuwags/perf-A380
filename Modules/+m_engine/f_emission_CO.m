function indices = f_emission_CO(altitude_m, mach_nb, ...
    isa_dev, wfc_ref)
%F_EMISSION_CO Summary of this function goes here
%   Detailed explanation goes here

CO = [12.65 1.05 0.31 0.33];

indices_ref = m_engine.f_fuel_to_indices(altitude_m, mach_nb, isa_dev, wfc_ref, CO);

theta = m_atmos.f_theta(altitude_m, isa_dev);
delta = m_atmos.f_delta(altitude_m);

indices = indices_ref*theta^3.3/delta^1.02;
end