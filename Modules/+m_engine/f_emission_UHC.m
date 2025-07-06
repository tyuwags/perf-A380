function indices = f_emission_UHC(altitude_m, mach_nb, ...
    isa_dev, wfc_ref)
%F_EMISSION_UHC Summary of this function goes here
%   Detailed explanation goes here

UHC = [4.04 0.07 0.03 0.03];

indices_ref = m_engine.f_fuel_to_indices(altitude_m, mach_nb, isa_dev, wfc_ref, UHC);

theta = m_atmos.f_theta(altitude_m, isa_dev);
delta = m_atmos.f_delta(altitude_m);

indices = indices_ref*theta^3.3/delta^1.02;
end