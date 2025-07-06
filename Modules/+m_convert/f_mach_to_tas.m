function tas_mps = f_mach_to_tas(mach_nb, altitude_m, isa_dev)
    
    %%% Compute Mach
    a = m_atmos.f_speed_sound(altitude_m, isa_dev);
    tas_mps = a*mach_nb;
    
    %%% End of function
end