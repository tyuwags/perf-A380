function m_ac = f_moment(alpha, delta, altitude_m, isa_dev, mach_nb, plane)
%F_MOMENT Summary of this function goes here
%   Detailed explanation goes here

rho = m_atmos.f_density(altitude_m, isa_dev);
v = m_convert.f_mach_to_tas(mach_nb, altitude_m, isa_dev);

[cls, cds, cms] = m_aero.f_aero_coeffs(plane, alpha, mach_nb, delta);

L = 0.5 * rho * v^2 * plane.wingArea * cls;

D = 0.5 * rho * v^2 * plane.wingArea * cds; %?


m_ac = 0.5 * rho * v^2 * plane.wingChord * plane.wingArea * cms - L * (plane.xcg - plane.xac);

end