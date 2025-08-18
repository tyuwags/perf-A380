function [m, fb, x, CO, NOx, UHC, CO2] = f_state_cruise(altitude_m, mach_nb, isa_dev, ...
    plane, dist, vw, nb_step_climb, altitude_m_max, mode)

if nargin < 8
    altitude_m_max = altitude_m;
    mode = m_engine.mode.nmcl;
end

x = 0;
fb = 0;
CO = 0;
NOx = 0;
UHC = 0;
CO2 = 0;
m = plane.currentWeight;

currentAltitude = altitude_m;

step_climb = (altitude_m_max - altitude_m)/(nb_step_climb);

step_climb_dist = dist/(nb_step_climb + 1);

climb_targets = step_climb_dist * (1:nb_step_climb); % points de montée en NM
climb_index = 1;

trim = @m_trim.f_trim;

while dist > x

    if climb_index <= nb_step_climb && x >= climb_targets(climb_index)
        altitude_m = altitude_m + step_climb;
        climb_index = climb_index + 1;
    end

    if currentAltitude >= altitude_m
        [wf, alpha, delta, gamma, fn] = m_trim.f_trim(currentAltitude, mach_nb, isa_dev, plane);
        delta_x = m_convert.f_length(min(25, dist - x), 'naut mi', 'm');
        vgs = m_convert.f_mach_to_tas(mach_nb, currentAltitude, isa_dev) + vw;
        delta_t = delta_x/vgs;
        x = x + m_convert.f_length(vgs*delta_t, 'm', 'naut mi');
    else
        [wf, alpha, delta, gamma, fn] = m_trim.f_trim_rise(currentAltitude, mach_nb, isa_dev, plane);
        delta_h = min(m_convert.f_length(1000, 'ft', 'm'), altitude_m - currentAltitude);
        v_t = m_convert.f_mach_to_tas(mach_nb, currentAltitude, isa_dev);
        delta_t = delta_h/(v_t*sind(gamma));
        x = x + m_convert.f_length((v_t*cosd(gamma) + vw)*delta_t, 'm', 'naut mi');
        currentAltitude = currentAltitude + delta_h;
    end
    
    
    m = m - wf * delta_t;
    plane.fuelConsumed(wf*delta_t);
    fb = fb + wf * delta_t;
    wfc = wf / (m_atmos.f_delta(currentAltitude)*sqrt(m_atmos.f_theta(currentAltitude, isa_dev)));
    CO = CO + wf * delta_t * m_engine.f_emision_indices(currentAltitude, mach_nb, isa_dev, m_engine.pollutant.CO, wfc/4)/1000;
    NOx = NOx + wf * delta_t * m_engine.f_emision_indices(currentAltitude, mach_nb, isa_dev, m_engine.pollutant.NOx, wfc/4)/1000;
    CO2 = CO2 + wf * delta_t * m_engine.f_emision_indices(currentAltitude, mach_nb, isa_dev, m_engine.pollutant.CO2, wfc/4)/1000;
    UHC = UHC + wf * delta_t * m_engine.f_emision_indices(currentAltitude, mach_nb, isa_dev, m_engine.pollutant.UHC, wfc/4)/1000;

    
    %plane.displayInfo();


end

end
