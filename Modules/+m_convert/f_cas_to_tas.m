function tas_mps = f_cas_to_tas(cas_mps, altitude_m, isa_dev)

    %%% Convert the mach_nb into tas
    M = m_convert.f_cas_to_mach(cas_mps, altitude_m, isa_dev);
    
    tas_mps = m_convert.f_mach_to_tas(M, altitude_m, isa_dev);
    
    %%% End of function
end