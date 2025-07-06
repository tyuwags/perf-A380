function indices = f_emision_indices(altitude_m, mach_nb, ...
    isa_dev, pollutant, wfc)

x = 1;
y = 0.5;

theta = m_atmos.f_theta(altitude_m, isa_dev);
delta = m_atmos.f_delta(altitude_m);

wfc_ref = (1+0.2*mach_nb^2)*theta^(3.8+y)/(delta^(1-x))*wfc;

switch pollutant
    case m_engine.pollutant.NOx
        indices = m_engine.f_emission_NOx(altitude_m, mach_nb, isa_dev, wfc_ref);
    case m_engine.pollutant.UHC
        indices = m_engine.f_emission_UHC(altitude_m, mach_nb, isa_dev, wfc_ref);
    case m_engine.pollutant.CO
        indices = m_engine.f_emission_CO(altitude_m, mach_nb, isa_dev, wfc_ref);
    case m_engine.pollutant.CO2
        indices = 3160; % g/kg
    otherwise
        error("This pollutant isn't implemented: " + pollutant);
        return;
end
end