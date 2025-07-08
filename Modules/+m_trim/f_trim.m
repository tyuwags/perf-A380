function wf = f_trim(altitude_m, mach_nb, isa_dev, ...
    weight, xcg, geom)
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

V_t = m_convert.f_mach_to_tas(mach_nb);
rho = m_atmos.f_pressure(altitude_m, isa_dev);

while condition
    alpha_0 = alpha;
    delta_0 = delta; 
    fn_0 = fn; 
    
    L = weight * g0 - fn * sin(alpha + phi_t);
    q = 1/2 * rho * V_t^2;
    Cl = L / (q*geom.wing.S_ref);

    alpha = fzero(@(a) CL(a) - Cl, alpha); % changer Cl pour m_aero.CL
    D = q * geom.wing.S_ref * CD(alpha, delta);

    fn = D/(cos(alpha + phi_t));

    delta = fzero(@(stab) m_aero.f_moment(alpha, delta, fn) + m_engine.f_moment(fn), delta);

    condition = eps_alpha > abs(alpha - alpha_0) || eps_delta > abs(delta - delta_0) || eps_fn > abs(fn - fn_0);
    
end

end