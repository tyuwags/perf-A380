function wf = f_trim(altitude_m, mach_nb, isa_dev, ...
    plane)
%F_TRIM Summary of this function goes here
%   Detailed explanation goes here

fn_max = 332.44 * 10^3 * 4;

g0 = 9.81;
phi_t = 0;

eps_alpha = 10^-3;
eps_delta = 10^-3;
eps_fn = 10^-3;

alpha = 0;
delta = 0;
fn = 0.4 * fn_max;

condition = true;

V_t = m_convert.f_mach_to_tas(mach_nb, altitude_m, isa_dev);
rho = m_atmos.f_pressure(altitude_m, isa_dev);

while condition
    alpha_0 = alpha;
    delta_0 = delta; 
    fn_0 = fn; 
    
    L = plane.weight * g0 - fn * sind(alpha + phi_t);
    q = 1/2 * rho * V_t^2;
    Cl = L / (q*plane.wingArea);

    [cls, cds, cms] = m_aero.f_aero_coeffs(plane, alpha, mach_nb, delta);

    alpha = fzero(@(a) cls - Cl, alpha);
    D = q * plane.wingArea * cds;

    fn = D/(cosd(alpha + phi_t));

    delta = fzero(@(stab) m_aero.f_moment(alpha, delta, fn, cms, plane.xcg - plane.xac, altitude_m, isa_dev, mach_nb, plane) - m_engine.f_moment(plane, fn, phi_t), delta);

    condition = eps_alpha > abs(alpha - alpha_0) || eps_delta > abs(delta - delta_0) || eps_fn > abs(fn - fn_0);
    
end

wf = m_engine.f_thrust_to_fuel(altitude_m, mach_nb, isa_dev, fn);

end