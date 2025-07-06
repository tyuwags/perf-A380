function mach_nb = f_tas_to_mach(tas_mps, altitude_m, isa_dev)

    %%% Convert the tas to mach number
    % Using the module atmos to determine speed of sound
    a = m_atmos.f_speed_sound(altitude_m, isa_dev);
    
    mach_nb = tas_mps/a;
    
    %%% End of function
end