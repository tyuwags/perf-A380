function [m, fb, x] = f_state_cruise(altitude_m, mach_nb, isa_dev, ...
    plane, dist, vw, nb_step_climb, altitude_m_max)

if nargin < 8
    altitude_m_max = altitude_m;
end

x = 0;
fb = 0;
m = plane.currentWeight;

step_climb = (altitude_m_max - altitude_m)/(nb_step_climb + 1);

step_climb_dist = dist/(nb_step_climb + 1);

climb_targets = step_climb_dist * (1:nb_step_climb); % points de montée en NM
climb_index = 1;

while dist > x

    if climb_index <= nb_step_climb && x >= climb_targets(climb_index)
        altitude_m = altitude_m + step_climb;
        climb_index = climb_index + 1;
    end

    delta_x = m_convert.f_length(min(25, dist - x), 'naut mi', 'm');
    vgs = m_convert.f_mach_to_tas(mach_nb, altitude_m, isa_dev) + vw;
    delta_t = delta_x/vgs;
    [wf, alpha, delta, fn] = m_trim.f_trim(altitude_m, mach_nb, isa_dev, plane);
    m = m - wf * delta_t;
    plane.fuelConsumed(wf*delta_t);
    fb = fb + wf * delta_t;
    x = x + m_convert.f_length(vgs*delta_t, 'm', 'naut mi');
end

end
