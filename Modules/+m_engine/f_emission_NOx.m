function indices = f_emission_NOx(altitude_m, mach_nb, ...
    isa_dev, wfc_ref)
%F_EMISSION_NOX Summary of this function goes here
%   Detailed explanation goes here

NOx = [5.24 12.9 31.37 41.73];

indices_ref = m_engine.f_fuel_to_indices(altitude_m, mach_nb, isa_dev, wfc_ref, NOx);

theta = m_atmos.f_theta(altitude_m, isa_dev);
delta = m_atmos.f_delta(altitude_m);
rh = 0.8;
T = m_atmos.f_temperature(altitude_m, isa_dev);
psat = 6.107*10^(7.5*(T-273.15)/(T-35.85));

P = m_atmos.f_pressure(altitude_m, isa_dev);

omega = 0.62197058*rh*psat/(0.1*P-rh*psat);

indices = indices_ref*sqrt(delta^1.02/theta^3.3)*exp(-19*(omega-0.00634));
end