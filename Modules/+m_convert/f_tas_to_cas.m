function cas_mps = f_tas_to_cas(tas_mps, altitude_m, isa_dev)

    mach_nb = m_convert.f_tas_to_mach(tas_mps, altitude_m, isa_dev);
    cas_mps = m_convert.f_mach_to_cas(mach_nb, altitude_m);
    
    %%% End of function
end