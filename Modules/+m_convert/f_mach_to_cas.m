function cas_mps = f_mach_to_cas(mach_nb, altitude_m)
    
    a0 = m_atmos.f_speed_sound(altitude_m, 0);
    delta = m_atmos.f_delta(altitude_m);
    
    cas_mps = a0*sqrt(5*((delta*((1+0.2*mach_nb^2)^3.5-1)+1)^(1/3.5)-1));
    
    %%% End of function
end