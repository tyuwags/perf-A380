function m_aero = f_moment(alpha, delta, fn, cms, dist, altitude_m, isa_dev, mach_nb, plane)
%F_MOMENT Summary of this function goes here
%   Detailed explanation goes here

rho = m_atmos.f_density(altitude_m, isa_dev);
v = m_convert.f_mach_to_tas(mach_nb, altitude_m, isa_dev);
my = 1/2*rho*v^2*plane.wingChord*plane.wingArea*cms;

L = plane.weight*9.81 - fn * sind(alpha); % phi_t

m_aero = dist * L - my;

end