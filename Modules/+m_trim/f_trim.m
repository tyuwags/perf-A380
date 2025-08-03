function [wf, alpha, delta, fn] = f_trim(altitude_m, mach_nb, isa_dev, ...
    plane)
%F_TRIM Summary of this function goes here
%   Detailed explanation goes here

fn_max = 332.44 * 10^3;

g0 = 9.81;
phi_t = plane.phi_t;

eps_alpha = 10^-1;
eps_delta = 10^-1;
eps_fn = 10^0;

alpha = 0;
delta = 0;
fn = 0.4 * fn_max;

condition = true;

V_t = m_convert.f_mach_to_tas(mach_nb, altitude_m, isa_dev);
rho = m_atmos.f_density(altitude_m, isa_dev);

% deltas = linspace(-2, 15, 100);
% moments = arrayfun(@(d) m_aero.f_moment(alpha, d, fn, altitude_m, isa_dev, mach_nb, plane) + m_engine.f_moment(plane, fn, phi_t), deltas);
% plot(deltas, moments); grid on;
% xlabel('\delta_{stab}'); ylabel('Moment total');

% return

max_iter = 5;
iter = 0;

while condition
    alpha_0 = alpha;
    delta_0 = delta; 
    fn_0 = fn; 
    L = plane.currentWeight * g0 - fn * sind(alpha + phi_t);
    q = 1/2 * rho * V_t^2;
    Cl = L / (q*plane.wingArea);


    alpha = fzero(@(a) (m_aero.f_aero_coeffs(plane, a, mach_nb, delta) - Cl)^2, [-2 15]);
    [cls, cds, cms] = m_aero.f_aero_coeffs(plane, alpha, mach_nb, delta);
    D = q * plane.wingArea * cds;

    fn = D/(cosd(alpha + phi_t));

    % disp(m_aero.f_moment(alpha, delta, fn, altitude_m, isa_dev, mach_nb, plane) + m_engine.f_moment(plane, fn, phi_t))

    delta = fzero(@(stab) m_aero.f_moment(alpha, stab, altitude_m, isa_dev, mach_nb, plane) + m_engine.f_moment(plane, alpha, fn, phi_t), [(-14.9 + m_aero.f_downwash(alpha) - alpha) (14.9 + m_aero.f_downwash(alpha) - alpha)]);

    iter = iter+1;

    condition = (eps_alpha > abs(alpha - alpha_0) || eps_delta > abs(delta - delta_0) || eps_fn > abs(fn - fn_0)) && iter < max_iter;
    
end

wf = m_engine.f_thrust_to_fuel(altitude_m, mach_nb, isa_dev, fn/4);

end