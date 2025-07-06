function spd_sound_mps = f_speed_sound(altitude_m, isa_dev)

    %%% Compute the speed of sound
    gamma = 1.4;
    Ra = 287.05; 
    T = m_atmos.f_temperature(altitude_m, isa_dev);
    spd_sound_mps = sqrt(gamma*Ra*T);

end