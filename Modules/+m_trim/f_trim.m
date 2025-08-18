function [wf, alpha, delta_stab, gamma, fn] = f_trim(altitude_m, mach_nb, isa_dev, ...
    plane)
%F_TRIM Summary of this function goes here
%   Detailed explanation goes here

fn_max = 332.44 * 10^3 * 4;

g0 = 9.80665;
phi_t = plane.phi_t;

eps_alpha = 10^(-4);
eps_delta = 10^(-4);
eps_fn = 10^(-2);

alpha = 0;
delta_stab = 0;
fn = 0.4 * fn_max;

condition = true;

V_t = m_convert.f_mach_to_tas(mach_nb, altitude_m, isa_dev);
rho = m_atmos.f_density(altitude_m, isa_dev);


max_iter = 100;
iter = 0;

options = optimset('Display', 'off');

while condition
    alpha_0 = alpha;
    delta_0 = delta_stab; 
    fn_0 = fn; 

    L = plane.currentWeight * g0 - fn * sind(alpha + phi_t);
    q = 1/2 * rho * V_t^2;
    Cl = L / (q*plane.wingArea);

    alpha = fsolve(@(a) m_aero.f_aero_coeffs(plane, a, mach_nb, delta_stab) - Cl, 0, options);


    [cls, cds, cms] = m_aero.f_aero_coeffs(plane, alpha, mach_nb, delta_stab);
    D = q * plane.wingArea * cds;

    fn = D/(cosd(alpha + phi_t));

    % disp(m_aero.f_moment(alpha, delta, fn, altitude_m, isa_dev, mach_nb, plane) + m_engine.f_moment(plane, fn, phi_t))
    delta_stab = fsolve(@(stab) m_aero.f_moment(alpha, stab, altitude_m, isa_dev, mach_nb, plane) + m_engine.f_moment(plane, alpha, fn, phi_t), 0, options);

    iter = iter+1;

    condition = (eps_alpha > abs(alpha - alpha_0) || eps_delta > abs(delta_stab - delta_0) || eps_fn > abs(fn - fn_0)) && iter < max_iter;
    
end

% SFC = 0.6;
delta = m_atmos.f_delta(altitude_m);
theta = m_atmos.f_theta(altitude_m, isa_dev);

gamma = 0;

plane.setAlpha(alpha);
plane.setDelta(delta_stab);
plane.setThrust(fn);
plane.setGamma(gamma);
% fn/4/delta < m_engine.f_thrust_model(altitude_m, mach_nb, isa_dev, 100)
plane.setFanSpeed(m_engine.f_thrust_to_fan_speed(altitude_m, mach_nb, isa_dev, fn/4/delta));

% wf = m_convert.f_mass(m_convert.f_force(fn, 'N', 'lbf') * SFC, 'lbm', 'kg')/3600;

wf = m_engine.f_thrust_to_fuel(altitude_m, mach_nb, isa_dev, fn/4)*4*delta*sqrt(theta);

end